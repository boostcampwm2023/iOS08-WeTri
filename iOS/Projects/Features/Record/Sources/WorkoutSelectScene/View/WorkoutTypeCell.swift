//
//  WorkoutTypeCell.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutTypeCell

class WorkoutTypeCell: UICollectionViewCell {
  static let identifier = "WorkoutTypeCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    makeShadowAndRounded()
    backgroundColor = DesignSystemColor.primaryBackGround
    setupConstraints()
  }

  override var isSelected: Bool {
    didSet {
      if isSelected {
        makeSelectUI()
      } else {
        makeDeslectUI()
      }
    }
  }

  private let workoutIconDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    label.textAlignment = .center
    label.text = "달리기에용"
    label.contentMode = .scaleAspectFit

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let workoutIcon: UIImageView = {
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 120))
    let icon = UIImage(systemName: "figure.run", withConfiguration: config)
    let imageView = UIImageView(image: icon)
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = DesignSystemColor.primaryText

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

private extension WorkoutTypeCell {
  func setupConstraints() {
    contentView.addSubview(workoutIconDescriptionLabel)
    workoutIconDescriptionLabel.bottomAnchor
      .constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    workoutIconDescriptionLabel.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
    workoutIconDescriptionLabel.trailingAnchor
      .constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

    contentView.addSubview(workoutIcon)
    workoutIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
    workoutIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    workoutIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    workoutIcon.bottomAnchor.constraint(equalTo: workoutIconDescriptionLabel.topAnchor, constant: -15).isActive = true
  }

  func makeShadowAndRounded() {
    let radius: CGFloat = 10
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1.0)
    layer.shadowRadius = 2.0
    layer.shadowOpacity = 0.5
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
  }

  func makeSelectUI() {
    workoutIcon.tintColor = DesignSystemColor.main03
    workoutIcon.makeShadow()

    workoutIconDescriptionLabel.textColor = DesignSystemColor.main03
    workoutIconDescriptionLabel.font = .preferredFont(forTextStyle: .title3, with: .traitBold)
  }

  func makeDeslectUI() {
    workoutIcon.tintColor = DesignSystemColor.primaryText
    workoutIcon.disableShadow()

    workoutIconDescriptionLabel.textColor = DesignSystemColor.primaryText
    workoutIconDescriptionLabel.font = .preferredFont(forTextStyle: .title3)
  }
}

private extension UIImageView {
  func makeShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: -2, height: 2)
    layer.shadowRadius = 2.0
    layer.shadowOpacity = 0.3
    layer.masksToBounds = false
  }

  func disableShadow() {
    layer.shadowOpacity = 0
  }
}
