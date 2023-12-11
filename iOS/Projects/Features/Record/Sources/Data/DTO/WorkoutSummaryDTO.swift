import Foundation

// MARK: - WorkoutSummaryDTO

/// 운동 데이터를 요약해서 보여줄 때 사용하는 Response 모델입니다.
struct WorkoutSummaryDTO: Decodable, Identifiable {
  /// 운동 요약 정보 고유 Identifier
  let id: Int

  /// 운동한 시간
  ///
  /// 초(s)단위로 받아옵니다.
  let workoutTime: Int

  /// 총 운동한 거리
  let distance: Int

  /// 소모한 칼로리
  let calorie: Int

  /// 평균 심박수
  let averageHeartRate: Int?

  /// 운동 중에 기록한 최소 심박수
  let minimumHeartRate: Int?

  /// 운동 중에 기록한 최대 심박수
  let maximumHeartRate: Int?

  /// 운동 기록한 날짜
  let createdAt: Date

  /// 게시물 등록 여부
  let isPosted: Bool

  /// 운동한 경로를 갖는 지도 이미지입니다.
  let mapScreenshots: URL?

  /// 운동 위치 정보
  ///
  /// 문자열로 받아옵니다. e.g. "37.1234/127.312,37.1234/127.3153,..."
  let locations: String

  enum CodingKeys: String, CodingKey {
    case id
    case workoutTime
    case distance
    case calorie
    case createdAt
    case isPosted
    case averageHeartRate = "avgHeartRate"
    case minimumHeartRate = "minHeartRate"
    case maximumHeartRate = "maxHeartRate"
    case mapScreenshots = "mapCapture"
    case locations = "gps"
  }
}
