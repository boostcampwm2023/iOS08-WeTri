//
//  LoginCoordinating.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Coordinator
import Foundation

protocol LoginCoordinating: Coordinating {
  func finish(initialUser: InitialUser?, token: Token?)
}
