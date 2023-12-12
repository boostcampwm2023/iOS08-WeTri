//
//  UserInformationFetcher.swift
//  UserInformationManager
//
//  Created by MaraMincho on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import CommonNetworkingKeyManager
import Foundation
import Log
import Trinet

// MARK: - UserInformationFetcher

public struct UserInformationFetcher {
  private let provider: TNProvider<ProfileFetch>
  public init(session: URLSessionProtocol = URLSession.shared) {
    provider = .init(session: session)
  }

  public func reissueUserProfileInformation() {
    Task {
      let jsonDecoder = JSONDecoder()

      guard
        let data = try? await provider.request(.fetchProfile, interceptor: TNKeychainInterceptor.shared),
        let profileDTO = try? jsonDecoder.decode(GWResponse<ProfileDTO>.self, from: data).data
      else {
        return
      }
      UserInformationManager.shared.setUserName(profileDTO.nickname)
      Log.make().debug("\(profileDTO.nickname)")

      UserInformationManager.shared.setUserProfileImageData(url: profileDTO.profileImage)
      Log.make().debug("\(profileDTO.profileImage)")

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let date = formatter.date(from: profileDTO.birthdate)
      UserInformationManager.shared.setBirthDayDate(date)
      Log.make().debug("\(date ?? .now)")

      UserInformationManager.shared.setUserProfileImageURLString(url: profileDTO.profileImage)
    }
  }
}

// MARK: - ProfileFetch

private enum ProfileFetch: TNEndPoint {
  case fetchProfile

  var path: String {
    switch self {
    case .fetchProfile:
      return "/api/v1/profiles/me"
    }
  }

  var method: TNMethod { .get }
  var query: Encodable? { nil }
  var body: Encodable? { nil }
  var headers: TNHeaders { .default }
}

// MARK: - ProfileDTO

/// 프로필 정보를 갖습니다.
public struct ProfileDTO: Decodable {
  /// 닉네임
  let nickname: String

  /// 성별
  ///
  /// `남자`, `여자`로 반환됩니다.
  let gender: String

  /// 생일
  let birthdate: String

  /// 프로필 이미지
  let profileImage: URL

  /// 사용자의 퍼블릭 아이디 입니다.
  let publicID: String

  enum CodingKeys: String, CodingKey {
    case nickname
    case gender
    case birthdate
    case profileImage
    case publicID = "publicId"
  }
}
