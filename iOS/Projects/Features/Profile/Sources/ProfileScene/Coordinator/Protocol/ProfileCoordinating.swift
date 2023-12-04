//
//  ProfileCoordinating.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

public protocol ProfileCoordinating: Coordinating {
  /// 설정 창으로 이동합니다.
  func pushToSettings()
}
