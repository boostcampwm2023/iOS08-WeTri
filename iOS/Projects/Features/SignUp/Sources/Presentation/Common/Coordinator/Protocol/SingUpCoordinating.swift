//
//  SingUpCoordinating.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation

public protocol SignUpCoordinating: Coordinating {
  func pushSingUpContainerViewController()
}
