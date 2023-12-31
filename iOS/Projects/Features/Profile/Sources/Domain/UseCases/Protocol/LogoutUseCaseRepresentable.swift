//
//  LogoutUseCaseRepresentable.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

protocol LogoutUseCaseRepresentable {
  func logout() -> AnyPublisher<Bool, Never>
}
