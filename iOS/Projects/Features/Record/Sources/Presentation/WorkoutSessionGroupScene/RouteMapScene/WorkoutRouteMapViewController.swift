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
import MapKit
import OSLog
import UIKit

// MARK: - WorkoutRouteMapViewController

final class WorkoutRouteMapViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutRouteMapViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    return locationManager
  }()

  // MARK: UI Components

  private let mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
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
    Logger().debug("\(#function)")
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    locationManager.startMonitoringSignificantLocationChanges()
  }
}

// MARK: CLLocationManagerDelegate

extension WorkoutRouteMapViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard
      manager.authorizationStatus == .authorizedWhenInUse
      || manager.authorizationStatus == .authorizedAlways
    else {
      Logger().error("유저의 위치를 받아올 수 없습니다.")
      return
    }
    locationManager.startUpdatingLocation()
  }

  func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    Logger().debug("\(locations)")
  }

  func locationManager(_: CLLocationManager, didFailWithError error: Error) {
    Logger().error("\(error)")
  }
}

// MARK: WorkoutRouteMapViewController.Metrics

private extension WorkoutRouteMapViewController {
  enum Metrics {
    static let horizontal: CGFloat = 24
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutRouteMapViewController(viewModel: WorkoutRouteMapViewModel())
}
