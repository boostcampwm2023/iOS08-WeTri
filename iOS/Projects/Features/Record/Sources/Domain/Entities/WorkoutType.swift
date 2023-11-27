//
//  WorkoutType.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation


// 사용자가 어떤 운동을 하는지 알려주기 위해 사용하는 Entity입니다.
// 이 Entity를 통해 Card View를 보여줍니다.
public struct WorkoutType: Hashable {
  
  // Card에 나타나는 아이콘의 이미지 이름입니다. (SF Font 이미지 이름)
  // 다음과 같이 활용할 수 있습니다.UIimage(systemName: workoutType.workoutIcon)
  let workoutIcon: String
  
  // 운동이름을 나타냅니다.
  // eg) 달리기 수영 사이클
  let workoutTitle: String
  
  // 어떤 운동을 하는지 숫자로 정의합니다.
  // 중요: 서버측과 통신을 위해 Int로 만들었습니다.
  // eg) 달리기는 1번, 사이클은...
  let typeCode: Int

  init(workoutIcon: String, workoutIconDescription: String, typeCode: Int) {
    self.workoutIcon = workoutIcon
    self.workoutTitle = workoutIconDescription
    self.typeCode = typeCode
  }

  init(workoutTypesDTO dto: WorkoutTypeDTO) {
    workoutIcon = dto.icon
    workoutTitle = dto.description
    typeCode = dto.typeCode
  }
}
