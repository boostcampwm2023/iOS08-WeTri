//
//  WorkoutPeerTypeSelectCell.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/19/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutPeerTypeSelectCell

final class WorkoutPeerTypeSelectCell: UICollectionViewCell {
  // MARK: - Initializations

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  static let identifier = "WorkoutPeerSelectCell"
  private var descriptionIconSystemName: String = ""
  private var descriptionTitleText: String = ""
  private var descriptionSubTitleText: String = ""
  private var typeCode: Int = -1

  override var isSelected: Bool {
    didSet {
      if isSelected {
        makeSelectUI()
      } else {
        makeDeslectUI()
      }
    }
  }

  // MARK: UI Components

  private let descriptionIcon: UIImageView = {
    let imageFont: UIFont = .preferredFont(forTextStyle: .title1)
    let configure = UIImage.SymbolConfiguration(font: imageFont)
    let targetImage = UIImage(systemName: "person.3.fill", withConfiguration: configure)

    let imageView = UIImageView(image: targetImage)
    imageView.contentMode = .scaleAspectFill
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = DesignSystemColor.gray02

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let descriptionTitle: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.text = "함께 하기"
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionSubTitle: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.text = "함께 운동을 진행합니다."
    label.textColor = DesignSystemColor.gray03

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var textStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      descriptionTitle,
      descriptionSubTitle,
    ])
    stackView.alignment = .leading
    stackView.axis = .vertical
    stackView.spacing = 6

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var iconIncludeStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      descriptionIcon, textStackView,
    ])
    stackView.spacing = 12
    stackView.alignment = .leading

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
}

private extension WorkoutPeerTypeSelectCell {
  func setup() {
    setupHierarchyAndConstraints()
    setBackgroundColor()
    makeShadowAndRounded()
  }

  func setupHierarchyAndConstraints() {
    contentView.addSubview(iconIncludeStackView)
    iconIncludeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
    iconIncludeStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    descriptionIcon.widthAnchor.constraint(equalToConstant: Metrics.iconWidth).isActive = true
    descriptionIcon.heightAnchor.constraint(equalToConstant: Metrics.iconHeight).isActive = true
  }

  func setBackgroundColor() {
    backgroundColor = DesignSystemColor.primaryBackground
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
    descriptionIcon.tintColor = DesignSystemColor.main03
    descriptionIcon.makeShadow()

    descriptionTitle.textColor = LabelProperty.selectdColor
    descriptionTitle.font = LabelProperty.descriptionTitleDidSelectFont

    descriptionSubTitle.textColor = LabelProperty.selectdColor
    descriptionSubTitle.font = LabelProperty.descriptionSubTitleDidSelectFont
  }

  func makeDeslectUI() {
    descriptionIcon.tintColor = LabelProperty.descriptionIconColor
    descriptionIcon.disableShadow()

    descriptionTitle.textColor = LabelProperty.descriptionTitleTextColor
    descriptionTitle.font = LabelProperty.descriptionTitleFont

    descriptionSubTitle.textColor = LabelProperty.descriptionSubTitleTextColor
    descriptionSubTitle.font = LabelProperty.descriptionSubTitleFont
  }

  enum Metrics {
    static let iconWidth: CGFloat = 60
    static let iconHeight: CGFloat = 42
  }

  enum LabelProperty {
    static let descriptionIconColor: UIColor = DesignSystemColor.gray02

    static let descriptionTitleDidSelectFont: UIFont = .preferredFont(forTextStyle: .title3, with: .traitBold)
    static let descriptionTitleFont: UIFont = .preferredFont(forTextStyle: .title3)
    static let descriptionTitleTextColor: UIColor = DesignSystemColor.primaryText

    static let descriptionSubTitleFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let descriptionSubTitleDidSelectFont: UIFont = .preferredFont(forTextStyle: .caption1, with: .traitBold)
    static let descriptionSubTitleTextColor: UIColor = DesignSystemColor.gray03

    static let selectdColor: UIColor = DesignSystemColor.main03
  }
}

extension WorkoutPeerTypeSelectCell {
  func update(descriptionIconSystemName: String, descriptionTitleText: String, descriptionSubTitleText: String, typeCode: Int) {
    let imageFont: UIFont = .preferredFont(forTextStyle: .title1)
    let configure = UIImage.SymbolConfiguration(font: imageFont)
    let targetImage = UIImage(systemName: descriptionIconSystemName, withConfiguration: configure)

    descriptionIcon.image = targetImage
    descriptionTitle.text = descriptionTitleText
    descriptionSubTitle.text = descriptionSubTitleText

    self.descriptionIconSystemName = descriptionIconSystemName
    self.descriptionTitleText = descriptionTitleText
    self.descriptionSubTitleText = descriptionSubTitleText
    self.typeCode = typeCode
  }

  func info() -> PeerType {
    return .init(
      icon: descriptionIconSystemName,
      title: descriptionTitleText,
      description: descriptionSubTitleText,
      typeCode: typeCode
    )
  }
}

private extension UIImageView {
  func makeShadow() {
    layer.backgroundColor = UIColor.clear.cgColor
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
