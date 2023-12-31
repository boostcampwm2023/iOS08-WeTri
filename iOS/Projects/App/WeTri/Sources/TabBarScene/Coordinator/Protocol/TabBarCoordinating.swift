//
//  TabBarCoordinating.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

protocol TabBarCoordinating: Coordinating {
  var tabBarController: UITabBarController { get }
}
