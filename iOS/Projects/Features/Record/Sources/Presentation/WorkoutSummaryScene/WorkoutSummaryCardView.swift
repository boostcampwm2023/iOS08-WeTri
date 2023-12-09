//
//  WorkoutSummaryCardView.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import CoreLocation
import DesignSystem
import MapKit
import UIKit

// MARK: - WorkoutSummaryItemView

private final class WorkoutSummaryItemView: UIView {
  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2)
    label.text = "타이틀"
    label.textAlignment = .center
    return label
  }()

  private let informationLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .headline)
    label.text = "120bpm"
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }

  private func setupViews() {
    addSubview(titleLabel)
    addSubview(informationLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    informationLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

        informationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
        informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      ]
    )
  }

  func configure(withTitle title: String, value: String) {
    titleLabel.text = title
    informationLabel.text = value
  }
}

// MARK: - WorkoutSummaryCardView

final class WorkoutSummaryCardView: UIView {
  // MARK: - UI Components

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title3, weight: .medium)
    return label
  }()

  private let mapView: MKMapView = .init()

  private let timeItemView: WorkoutSummaryItemView = .init()

  private let distanceItemView: WorkoutSummaryItemView = .init()

  private let caloriesItemView: WorkoutSummaryItemView = .init()

  private let averageHeartRateItemView: WorkoutSummaryItemView = .init()

  private let maximumHeartRateItemView: WorkoutSummaryItemView = .init()

  private let minimumHeartRateItemView: WorkoutSummaryItemView = .init()

  private let activityStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    return stackView
  }()

  private let heartRateStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    return stackView
  }()

  private let wholeStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = Metrics.wholeStackViewSpacing
    stackView.axis = .vertical
    return stackView
  }()

  private let containerRoundedView: UIView = {
    let view = UIView()
    view.backgroundColor = DesignSystemColor.secondaryBackground
    view.layer.cornerRadius = Metrics.cardViewCornerRadius
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
    mapView.delegate = self
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayouts()
    setupConstraints()
    mapView.delegate = self
  }

  private func setupLayouts() {
    addSubview(containerRoundedView)

    containerRoundedView.addSubview(wholeStackView)

    for view in [dateLabel, mapView, activityStackView, heartRateStackView] {
      wholeStackView.addArrangedSubview(view)
    }

    for activityItem in [timeItemView, distanceItemView, caloriesItemView] {
      activityStackView.addArrangedSubview(activityItem)
    }

    for heartRateItem in [averageHeartRateItemView, maximumHeartRateItemView, minimumHeartRateItemView] {
      heartRateStackView.addArrangedSubview(heartRateItem)
    }
  }

  private func setupConstraints() {
    containerRoundedView.translatesAutoresizingMaskIntoConstraints = false
    wholeStackView.translatesAutoresizingMaskIntoConstraints = false
    mapView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        containerRoundedView.topAnchor.constraint(equalTo: topAnchor),
        containerRoundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
        containerRoundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
        containerRoundedView.bottomAnchor.constraint(equalTo: bottomAnchor),

        wholeStackView.topAnchor.constraint(equalTo: containerRoundedView.topAnchor, constant: Metrics.wholeStackViewInset),
        wholeStackView.leadingAnchor.constraint(equalTo: containerRoundedView.leadingAnchor, constant: Metrics.wholeStackViewInset),
        wholeStackView.trailingAnchor.constraint(equalTo: containerRoundedView.trailingAnchor, constant: -Metrics.wholeStackViewInset),
        wholeStackView.bottomAnchor.constraint(equalTo: containerRoundedView.bottomAnchor, constant: -Metrics.wholeStackViewBottomInset),

        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.66),
      ]
    )
  }

  func configure(with model: WorkoutSummaryModel) {
    dateLabel.text = model.createdAt.description
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad

    // 시간초 설정
    if let formattedString = formatter.string(from: TimeInterval(model.workoutTime)) {
      timeItemView.configure(withTitle: "시간", value: "\(formattedString)")
    }

    // 지도 설정
    configureMapPolyline(with: model.locations)

    distanceItemView.configure(withTitle: "거리", value: "\(model.distance)")
    caloriesItemView.configure(withTitle: "칼로리", value: "\(model.calorie)")

    averageHeartRateItemView.configure(withTitle: "Avg.HR", value: "\(model.averageHeartRate.flatMap(String.init) ?? "-")")
    minimumHeartRateItemView.configure(withTitle: "Min.HR", value: "\(model.minimumHeartRate.flatMap(String.init) ?? "-")")
    maximumHeartRateItemView.configure(withTitle: "Max.HR", value: "\(model.maximumHeartRate.flatMap(String.init) ?? "-")")
  }

  private func configureMapPolyline(with locations: [LocationModel]) {
    let currentLocations =
      if !locations.isEmpty { locations.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) } }
    else { [CLLocation(latitude: 37.22738768300735, longitude: 127.06500224609061)] }
    let coordinates = currentLocations.map(\.coordinate)
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

    mapView.removeOverlays(mapView.overlays)
    mapView.addOverlay(polyline)
    // 지도 뷰 업데이트
    let latitudes = currentLocations.map(\.coordinate.latitude)
    let longitudes = currentLocations.map(\.coordinate.longitude)
    let maxLatitude = latitudes.max() ?? 0
    let minLatitude = latitudes.min() ?? 0
    let maxLongitude = longitudes.max() ?? 0
    let minLongitude = longitudes.min() ?? 0
    let region = MKCoordinateRegion(
      center: .init(
        latitude: (maxLatitude + minLatitude) / 2,
        longitude: (maxLongitude + minLongitude) / 2
      ),
      span: .init()
    )
    mapView.setRegion(region, animated: true)
  }
}

// MARK: MKMapViewDelegate

extension WorkoutSummaryCardView: MKMapViewDelegate {
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

// MARK: WorkoutSummaryCardView.Metrics

private extension WorkoutSummaryCardView {
  enum Metrics {
    static let cardViewCornerRadius: CGFloat = 8
    static let wholeStackViewSpacing: CGFloat = 24
    static let wholeStackViewInset: CGFloat = 12
    static let wholeStackViewBottomInset: CGFloat = 30
  }
}
