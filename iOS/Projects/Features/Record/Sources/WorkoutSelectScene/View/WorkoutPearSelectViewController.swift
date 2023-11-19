//
//  WorkoutPearSelectViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/19/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit
import DesignSystem

final class WorkoutPearSelectViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private let startButton: UIButton = {
    let button = UIButton()
    button.configurationUpdateHandler = UIButton.Configuration.mainCircular(label: "출발")
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
}

private extension WorkoutPearSelectViewController {
  func setup() {
    setHierarchyAndConstraints()
  }
  
  func setHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(startButton)
    startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
    startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
  }
  
}
