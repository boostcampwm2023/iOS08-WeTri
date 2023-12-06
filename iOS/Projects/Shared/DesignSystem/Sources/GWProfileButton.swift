//
//  GWProfileButton.swift
//  DesignSystem
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - GWProfileButton

public final class GWProfileButton: UIButton {
  // MARK: Properties

  /// 사용자의 프로필 이미지를 설정합니다. 만약 nil인경우 사람모양의 기본 이미지로 대체됩니다.
  public var image: UIImage? {
    didSet {
      profileImageView.image = image ?? .init(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
    }
  }

  // MARK: UI Components

  private let profileImageView: UIImageView = {
    let imageView = UIImageView(image: .init(systemName: "person.fill"))
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = DesignSystemColor.main03 // 기본 이미지에 메인 색상을 적용하기 위함
    imageView.backgroundColor = .gray01
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.main03.cgColor
    imageView.clipsToBounds = true
    return imageView
  }()

  private let pencilImageView: UIImageView = {
    let imageView = UIImageView(image: .pencil)
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = Metrics.pencilSize * 0.5
    imageView.backgroundColor = .main03
    imageView.tintColor = .secondaryBackground
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.secondaryBackground.cgColor
    return imageView
  }()

  // MARK: Initializations

  public init(image: UIImage? = nil, frame: CGRect = .zero) {
    self.image = image
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayouts()
    setupConstraints()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    profileImageView.layer.cornerRadius = profileImageView.bounds.height * 0.5
  }

  // MARK: Configurations

  private func setupLayouts() {
    addSubview(profileImageView)
    addSubview(pencilImageView)
  }

  private func setupConstraints() {
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    pencilImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        profileImageView.topAnchor.constraint(equalTo: topAnchor),
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

        pencilImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        pencilImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        pencilImageView.widthAnchor.constraint(equalToConstant: Metrics.pencilSize),
        pencilImageView.heightAnchor.constraint(equalToConstant: Metrics.pencilSize),
      ]
    )
  }
}

// MARK: GWProfileButton.Metrics

private extension GWProfileButton {
  enum Metrics {
    static let pencilSize: CGFloat = 24
  }
}
