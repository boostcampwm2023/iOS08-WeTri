//
//  PeerType.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// 운동을 어떻게 할지(혼자 혹은 랜덤 매칭) 정보를 나타내는 데이터 타입 입니다.
// 이 Entity는 어떻게 운동 할지 카드 UI를 만들 때 사용하는 엔티티 입니다.
// 또한 이 타입을 갖고 내부 로직을 통해
// 혼자 혹은 여럿이 운동할 수 있게 도와줍니다.
struct PeerType: Hashable {
  
  // 카드에서 이미지를 나타내는 String 입니다.
  // UIImage(systemName: peerType.iconSystemImage)처럼 활용됩니다.
  let iconSystemImage: String
  
  // 카드 title의 Text를 나타내기 위해 쓰입니다.
  let titleText: String
  
  // 카드 subTitle의 Text를 나타내기 위해 쓰입니다.
  let descriptionText: String
  
  // 운동을 어떻게 할지(혼자 혹은 랜덤 매칭) 코드를 알려줍니다.
  let typeCode: Int

  init(icon: String, title: String, description: String, typeCode: Int) {
    iconSystemImage = icon
    titleText = title
    descriptionText = description
    self.typeCode = typeCode
  }

  init(peerTypeDTO dto: PeerTypeDTO) {
    iconSystemImage = dto.icon
    titleText = dto.title
    descriptionText = dto.description
    typeCode = dto.typeCode
  }
}
