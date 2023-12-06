//
//  SettingsCoordinating.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

public protocol SettingsCoordinating: Coordinating {
  /// 로그인 창으로 이동합니다.
  func moveToLogin()

  /// 프로필 설정 화면으로 넘어갑니다.
  func moveToProfileSettings()
}
