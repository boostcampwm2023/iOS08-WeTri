//
//  WorkoutPearSelectCell.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/19/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutPearSelectCell

final class WorkoutPearTypeSelectCell: UICollectionViewCell {
  static let identifier = "WorkoutPearSelectCell"

  // MARK: UI Components

  private let descriptionIcon: UIImageView = {
    let imageFont: UIFont = .preferredFont(forTextStyle: .title1)
    let configure = UIImage.SymbolConfiguration(font: imageFont)
    let targetImage = UIImage(systemName: "person.3.fill", withConfiguration: configure)

    let imageView = UIImageView(image: targetImage)
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = DesignSystemColor.primaryBackGround

    imageView.contentMode = .scaleAspectFit

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let descriptionTitle: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.text = "함께 운동을 진행합니다."

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let titleDescription: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.text = "함께 운동을 진행합니다."

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var textStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      descriptionTitle,
      titleDescription,
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

  // MARK: - Initializations

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setupHierarchyAndConstraints() {
    contentView.addSubview(iconIncludeStackView)
    iconIncludeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    iconIncludeStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    descriptionIcon.widthAnchor.constraint(equalToConstant: Metrics.iconWidth).isActive = true
    descriptionIcon.heightAnchor.constraint(equalToConstant: Metrics.iconHeight).isActive = true
  }
}

// MARK: ParticipantsCollectionViewCell.Metrics

private extension WorkoutPearTypeSelectCell {
  enum Metrics {
    static let iconWidth: CGFloat = 60
    static let iconHeight: CGFloat = 42
  }

  enum Strings {
    static let nicknameAccessibilityHint = "닉네임"
    static let workoutDistanceAccessibilityHint = "운동한 거리"
  }
}
