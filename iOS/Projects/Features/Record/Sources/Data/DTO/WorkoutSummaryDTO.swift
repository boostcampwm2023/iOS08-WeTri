import Foundation

// MARK: - WorkoutSummaryDTO

/// 운동 데이터를 요약해서 보여줄 때 사용하는 Response 모델입니다.
struct WorkoutSummaryDTO: Decodable, Identifiable {
  /// 운동 요약 정보 고유 Identifier
  let id: Int

  /// 운동 종류
  ///
  /// e.g. swimming, running
  let workout: String

  /// 운동한 시간
  ///
  /// 초(s)단위로 받아옵니다.
  let workoutTime: Int

  /// 총 운동한 거리
  let distance: Int

  /// 소모한 칼로리
  let calorie: Int

  /// 평균 심박수
  let avgBPM: Int?

  /// 운동 중에 기록한 최소 심박수
  let minBPM: Int?

  /// 운동 중에 기록한 최대 심박수
  let maxBPM: Int?

  /// 운동 기록한 날짜
  let createdAt: String

  /// 게시물 등록 여부
  let isPosted: Bool

  /// 운동 위치 정보
  let locations: [LocationDTO]

  enum CodingKeys: String, CodingKey {
    case id
    case workout
    case workoutTime
    case distance
    case calorie
    case avgBPM = "avgBpm"
    case minBPM = "minBpm"
    case maxBPM = "maxBpm"
    case createdAt
    case isPosted
    case locations
  }
}

// MARK: - LocationDTO

/// 위도와 경도를 나타내는 위치 정보 데이터
struct LocationDTO: Codable {
  /// 위도
  let latitude: Double

  /// 경도
  let longitude: Double
}

// MARK: CustomStringConvertible

extension LocationDTO: CustomStringConvertible {
  var description: String {
    return "\(latitude)/\(longitude)"
  }
}
