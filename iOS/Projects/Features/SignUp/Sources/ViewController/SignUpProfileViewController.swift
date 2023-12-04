//
//  SignUpProfileViewController.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import Log
import UIKit

final class SignUpProfileViewController: UIViewController {
  private let subscriptions: Set<AnyCancellable> = []
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
    label.text = "프로필을 만들어 볼까요?"
    return label
  }()
  
  private let profileImageButton: GWProfileButton = {
    let button = GWProfileButton()
    return button
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.text = "닉네임"
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

private extension SignUpProfileViewController {
  func bindUI() {
    
  }
}
// MARK: - Metrics

private enum Metrics {
  static let safeAreaInterval: CGFloat = 24
  static let topInterval: CGFloat = 81
  static let sectionInterval: CGFloat = 48
  static let componentInterval: CGFloat = 9
}
