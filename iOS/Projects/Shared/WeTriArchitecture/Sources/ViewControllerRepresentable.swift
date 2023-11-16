//
//  ViewControllerRepresentable.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import class UIKit.UIViewController

// MARK: - ViewControllerRepresentable

public protocol ViewControllerRepresentable: AnyObject {
  var viewController: UIViewController { get }
}

public extension ViewControllerRepresentable where Self: UIViewController {
  var viewController: UIViewController {
    return self
  }
}
