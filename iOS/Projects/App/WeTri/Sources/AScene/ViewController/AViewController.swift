//
//  AViewController.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import CommonNetworkingKeyManager
import Keychain
import Log
import Trinet
import UIKit

// MARK: - AViewController

class AViewController: UIViewController {
  let tokenManager = TNKeychainInterceptor.shared
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue
  }

  let decoder = JSONDecoder()
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

// MARK: - AdminStruct

struct AdminStruct: Codable {
  let adminID: String
  let adminPw: String
}

// MARK: - AdminResponse

struct AdminResponse: Decodable {
  let accessToken: String
  let refreshToken: String
}

// MARK: - GWResponse

struct GWResponse<T>: Decodable where T: Decodable {
  let code: Int?
  let errorMessage: String?
  let data: T?
}
