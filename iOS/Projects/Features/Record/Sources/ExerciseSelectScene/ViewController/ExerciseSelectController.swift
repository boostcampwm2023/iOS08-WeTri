//
//  ExerciseSelectController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ExerciseSelectController

public class ExerciseSelectController: UIViewController {
  init() {
    
    super.init(nibName: nil, bundle: nil)
  }
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private let exerciseSelectDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1)
    label.textAlignment = .left
    label.text = "1. 운동을 선택하세요"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
}

private extension ExerciseSelectController {
  func setup() {
    setupConstraints()
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
  }
}
