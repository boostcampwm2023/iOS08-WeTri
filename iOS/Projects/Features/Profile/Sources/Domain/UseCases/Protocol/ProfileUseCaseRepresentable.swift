//
//  ProfileUseCaseRepresentable.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

public protocol ProfileUseCaseRepresentable {
  func fetchProfile() -> AnyPublisher<Profile, Error>
  func fetchPosts(lastItem: ProfileItem?, refresh: Bool) -> AnyPublisher<[Post], Error>
}
