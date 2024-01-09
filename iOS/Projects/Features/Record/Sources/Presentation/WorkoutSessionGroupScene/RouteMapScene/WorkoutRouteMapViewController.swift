//
//  WorkoutRouteMapViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CoreLocation
import DesignSystem
import Log
import MapKit
import UIKit

// MARK: - LocationTrackingProtocol

/// 위치 정보를 제공받기 위해 사용합니다.
protocol LocationTrackingProtocol: UIViewController {
  /// 위치 정보를 제공하는 Publisher
  var locationPublisher: AnyPublisher<[CLLocation], Never> { get }

  /// 지도 화면에 자신의 경로를 캡처한 이미지 데이터를 제공하는 Publisher
  var mapCaptureData: AnyPublisher<Data?, Never> { get }

  /// 지도 캡처를 요청합니다.
  func requestCapture()
}

// MARK: - WorkoutRouteMapViewController

final class WorkoutRouteMapViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutRouteMapViewModelRepresentable

  /// 사용자 위치 추적 배열
  @Published private var locations: [CLLocationCoordinate2D] = []

  private let mapCaptureDataSubject: PassthroughSubject<Data?, Never> = .init()
  private let mapSnapshotterImageDataSubject: PassthroughSubject<[CLLocation], Never> = .init()

  private let kalmanFilterShouldUpdatePositionSubject: PassthroughSubject<KalmanFilterUpdateRequireElement, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.startMonitoringSignificantLocationChanges()
    manager.distanceFilter = 10
    manager.startUpdatingLocation()

    manager.delegate = self
    return manager
  }()

  // MARK: UI Components

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.delegate = self
    mapView.setUserTrackingMode(.follow, animated: true)

    // Set MKMapView Property
    mapView.isZoomEnabled = false
    mapView.isScrollEnabled = false

    // 각도 조절 가능 여부 (두 손가락으로 위/아래 슬라이드
    mapView.isPitchEnabled = false
    mapView.isRotateEnabled = false
    mapView.showsCompass = true
    mapView.showsUserLocation = true

    return mapView
  }()

  // MARK: Initializations

  init(viewModel: WorkoutRouteMapViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    locationManager.stopUpdatingLocation()
    locationManager.stopMonitoringSignificantLocationChanges()

    Log.make().debug("\(Self.self) deinitialized")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
    setupLocationManager()
  }

  // MARK: Configuration

  private func setupLayouts() {
    view.addSubview(mapView)
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    mapView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
        mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let locationPublisher = mapSnapshotterImageDataSubject.map {
      $0.map { LocationModel(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
    }
    .eraseToAnyPublisher()

    let input: WorkoutRouteMapViewModelInput = .init(
      filterShouldUpdatePositionPublisher: kalmanFilterShouldUpdatePositionSubject.eraseToAnyPublisher(),
      locationListPublisher: locationPublisher
    )

    viewModel
      .transform(input: input)
      .sink { [weak self] state in
        self?.render(state: state)
      }
      .store(in: &subscriptions)
  }

  private func render(state: WorkoutRouteMapState) {
    switch state {
    case .idle:
      break
    case let .snapshotRegion(region): createMapSnapshot(with: region)
    case let .censoredValue(value): updatePolyLine(value)
    }
  }

  /// 스냅샷을 찍습니다. 거리의 위도 경도중 가장 큰값과 작은값을 적절하게 조합해서 사이즈를 만듭니다.
  ///
  /// 만약 스냅샷을 통해서 만들 Location의 데이터가 갯수가 적다면, mapCaptureDataSubject에 nil을 전송합니다.
  private func createMapSnapshot(with regionData: MapRegion) {
    if locations.count < Constants.minimumAmountLocationCount {
      mapCaptureDataSubject.send(nil)
      return
    }

    let polyLine = MKPolyline(coordinates: locations, count: locations.count)
    let span = MKCoordinateSpan(
      latitudeDelta: (regionData.maxLatitude - regionData.minLatitude) * 1.15,
      longitudeDelta: (regionData.maxLongitude - regionData.minLongitude) * 1.15
    )

    var region = MKCoordinateRegion(polyLine.boundingMapRect)
    region.span = span

    let options = MKMapSnapshotter.Options()
    options.region = region
    options.size = mapView.frame.size
    options.showsBuildings = true

    let snapshotter = MKMapSnapshotter(options: options)

    snapshotter.start { [weak self] snapshot, error in
      if let error {
        Log.make().error("사진 Snapshot을 찍는 도중 에러가 발생했습니다.")
        return
      }
      let data = self?.drawLineOnImagePngData(snapshot: snapshot)
      self?.mapCaptureDataSubject.send(data)
    }
  }

  /// MKMapSnapshotter를 통해 PngData를 만듭니다.
  func drawLineOnImagePngData(snapshot: MKMapSnapshotter.Snapshot?) -> Data? {
    guard let snapshot else {
      return nil
    }
    let renderer = UIGraphicsImageRenderer(size: snapshot.image.size)

    let pngData = renderer.pngData { [weak self] context in

      // 이미지의 폴리라인 굵기와 색을 지정해 줍니다.
      context.cgContext.setLineWidth(3.0)
      context.cgContext.setStrokeColor(DesignSystemColor.main03.cgColor)

      self?.locations
        .forEach { location in

          // snapshot에서 현재 위도 경도에 대한 데이터가 어느 CGPoint에 있는지 찾아내고, 이를 Polyline을 그립니다.
          context.cgContext.addLine(to: snapshot.point(for: location))
          context.cgContext.move(to: snapshot.point(for: location))
        }

      // 현재 컨텍스트 에서 여태 그린 Path를 적용합니다.
      context.cgContext.strokePath()
    }
    return pngData
  }

  private func updatePolyLine(_ value: KalmanFilterCensored?) {
    // 칼만 필터가 초기값이 튀기 때문에, 다음과 같이 Location의 갯수가 4 이하인 경우 폴리라인을 그리지 않습니다.
    guard let value else {
      return
    }

    let currentLocation = CLLocation(latitude: value.latitude, longitude: value.longitude)
    locations.append(currentLocation.coordinate)
    let polyline = MKPolyline(coordinates: locations, count: locations.count)

    mapView.removeOverlays(mapView.overlays)
    mapView.addOverlay(polyline)
    // 지도 뷰 업데이트
    let region = MKCoordinateRegion(
      center: currentLocation.coordinate,
      latitudinalMeters: Metrics.mapDistance,
      longitudinalMeters: Metrics.mapDistance
    )
    mapView.setRegion(region, animated: true)
  }

  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }

  private var prevLocation: CLLocation = .init(latitude: 37.5519, longitude: 126.9918)
  private var prevDate = Date.now
}

// MARK: LocationTrackingProtocol

extension WorkoutRouteMapViewController: LocationTrackingProtocol {
  func requestCapture() {
    let locations = locations.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
    mapSnapshotterImageDataSubject.send(locations)
  }

  var mapCaptureData: AnyPublisher<Data?, Never> {
    return mapCaptureDataSubject.eraseToAnyPublisher()
  }

  var locationPublisher: AnyPublisher<[CLLocation], Never> {
    return Just(
      locations.map {
        CLLocation(latitude: $0.latitude, longitude: $0.longitude)
      }
    )
    .eraseToAnyPublisher()
  }
}

// MARK: CLLocationManagerDelegate

extension WorkoutRouteMapViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard
      manager.authorizationStatus == .authorizedWhenInUse
      || manager.authorizationStatus == .authorizedAlways
    else {
      Log.make().error("유저의 위치를 받아올 수 없습니다.")
      return
    }
    locationManager.startUpdatingLocation()
  }

  func locationManager(_: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
    guard let newLocation = newLocations.last
    else {
      Log.make().error("location 값이 존재하지 않습니다.")
      return
    }

    kalmanFilterShouldUpdatePositionSubject.send(
      .init(
        prevCLLocation: prevLocation,
        currentCLLocation: newLocation
      )
    )
    prevLocation = newLocation
  }

  func locationManager(_: CLLocationManager, didFailWithError error: Error) {
    Log.make().error("\(error)")
  }
}

// MARK: MKMapViewDelegate

extension WorkoutRouteMapViewController: MKMapViewDelegate {
  func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let polyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: polyline)
      renderer.strokeColor = DesignSystemColor.main03
      renderer.lineWidth = 3
      return renderer
    }

    return MKOverlayRenderer(overlay: overlay)
  }
}

// MARK: WorkoutRouteMapViewController.Metrics

private extension WorkoutRouteMapViewController {
  enum Constants {
    static let minimumAmountLocationCount: Int = 5

    static let defaultPolyLineLocationList: [[Double]] = [[37.22738768300735, 127.06500224609061]]
  }

  enum Metrics {
    static let mapDistance: CLLocationDistance = 500
    static let horizontal: CGFloat = 24
  }
}
