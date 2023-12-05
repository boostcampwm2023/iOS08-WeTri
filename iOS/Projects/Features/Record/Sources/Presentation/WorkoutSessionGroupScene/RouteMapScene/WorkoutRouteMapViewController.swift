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
}

// MARK: - WorkoutRouteMapViewController

final class WorkoutRouteMapViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutRouteMapViewModelRepresentable

  /// 사용자 위치 추적 배열
  @Published private var locations: [CLLocation] = []
  var kalmanFilterShouldUpdatePositionSubject: PassthroughSubject<KalmanFilterUpdateRequireElement, Never> = .init()
  var kalmanFilterShouldUpdateHeadingSubject: PassthroughSubject<Double, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  lazy var locationManager: CLLocationManager = {
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
    let input: WorkoutRouteMapViewModelInput = .init(
      filterShouldUpdatePositionPublisher: kalmanFilterShouldUpdatePositionSubject.eraseToAnyPublisher(),
      filterShouldUpdateHeadingPublisher: kalmanFilterShouldUpdateHeadingSubject.eraseToAnyPublisher()
    )

    viewModel
      .transform(input: input)
      .sink { [weak self] state in
        switch state {
        case .idle:
          break
        case let .censoredValue(value): self?.updatePolyLine(value)
        }
      }
      .store(in: &subscriptions)
  }

  func updatePolyLine(_ value: KalmanFilterCensored?) {
    guard let value else { return }

    let currentLocation = CLLocation(latitude: value.latitude, longitude: value.longitude)
    locations.append(currentLocation)
    let coordinates = locations.map(\.coordinate)
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

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
  var locationPublisher: AnyPublisher<[CLLocation], Never> {
    $locations.eraseToAnyPublisher()
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

    let currentTime = Date.now
    let timeDistance = currentTime.distance(to: prevDate)

    // 과거 위치와 현재 위치를 통해 위 경도에 관한 속력을 구합니다.
    let v = (
      (newLocation.coordinate.latitude - prevLocation.coordinate.latitude) / timeDistance,
      (newLocation.coordinate.longitude - prevLocation.coordinate.longitude) / timeDistance
    )

    kalmanFilterShouldUpdatePositionSubject.send(
      .init(
        longitude: newLocation.coordinate.longitude,
        latitude: newLocation.coordinate.latitude,
        prevSpeedAtLongitude: v.1,
        prevSpeedAtLatitude: v.0
      )
    )
  }

  func locationManager(_: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    kalmanFilterShouldUpdateHeadingSubject.send(newHeading.trueHeading)
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
  enum Metrics {
    static let mapDistance: CLLocationDistance = 500
    static let horizontal: CGFloat = 24
  }
}
