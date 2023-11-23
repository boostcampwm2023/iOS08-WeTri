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

// MARK: - WorkoutRouteMapViewController

final class WorkoutRouteMapViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutRouteMapViewModelRepresentable

  /// 사용자 위치 추적 배열
  private var locations: [CLLocation] = []

  private var subscriptions: Set<AnyCancellable> = []

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    return locationManager
  }()

  // MARK: UI Components

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = self
    mapView.setUserTrackingMode(.follow, animated: true)
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
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  private func setupLocationManager() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
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

    locations.append(newLocation)
    let coordinates = locations.map(\.coordinate)
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    mapView.addOverlay(polyline)

    // 지도 뷰 업데이트
    let region = MKCoordinateRegion(
      center: newLocation.coordinate,
      latitudinalMeters: Metrics.mapDistance,
      longitudinalMeters: Metrics.mapDistance
    )
    mapView.setRegion(region, animated: true)
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutRouteMapViewController(viewModel: WorkoutRouteMapViewModel())
}
