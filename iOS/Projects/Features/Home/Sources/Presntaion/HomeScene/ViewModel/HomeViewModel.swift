//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - HomeViewModelInput

public struct HomeViewModelInput {
  let requestFeedPublisher: AnyPublisher<Void, Never>
}

public typealias HomeViewModelOutput = AnyPublisher<HomeState, Never>

// MARK: - HomeState

public enum HomeState {
  case idle
  case fetched(feed: [FeedElement])
}

// MARK: - HomeViewModelRepresentable

protocol HomeViewModelRepresentable {
  func transform(input: HomeViewModelInput) -> HomeViewModelOutput
}

// MARK: - HomeViewModel

final class HomeViewModel {
  // MARK: - Properties

  private let useCase: HomeUseCaseRepresentable
  private var subscriptions: Set<AnyCancellable> = []
  var tempID: Int = 0
  init(useCase: HomeUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: HomeViewModelRepresentable

extension HomeViewModel: HomeViewModelRepresentable {
  public func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
    subscriptions.removeAll()

    let fetched: HomeViewModelOutput = input.requestFeedPublisher
//      .flatMap { [useCase] _ in
//        useCase.fetchFeed()
//      }
      .map { [weak self] _ in
        // TODO: not fakeData _를 feed로 바꿔서 리턴하기 -
        return HomeState.fetched(feed: self?.fakeData() ?? [])
      }
      .eraseToAnyPublisher()

    let initialState: HomeViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: fetched)
      .eraseToAnyPublisher()
  }

  private func fakeData() -> [FeedElement] {
    tempID += 8
    return [
      .init(
        ID: 1 + tempID,
        publicID: "",
        nickName: "정다함",
        publishDate: .now,
        profileImage: URL(string: "https://i.ytimg.com/vi/fzzjgBAaWZw/hqdefault.jpg"),
        sportText: "달리기",
        content: "오운완. 오늘도 운동 조졌음. 기분은 좋네 ^^",
        postImages: [
          URL(string: "https://cdn.seniordaily.co.kr/news/photo/202108/2444_1812_1557.jpg"),
          URL(string: "https://t1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/guest/image/7MpZeU0-hBKjmb4tKFHR-Skd7bA.JPG"),
          URL(string: "https://t1.daumcdn.net/brunch/service/guest/image/9xI2XnpJpggfVZV6l1opHBwyeqU.JPG"),
        ],
        like: 2
      ),

      .init(
        ID: 2 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 2
      ),

      .init(
        ID: 3 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),

      .init(
        ID: 4 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),

      .init(
        ID: 5 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),

      .init(
        ID: 6 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),

      .init(
        ID: 7 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),

      .init(
        ID: 8 + tempID,
        publicID: "",
        nickName: "고양이 애호가",
        publishDate: .now,
        profileImage: URL(string: "https://ca.slack-edge.com/T05N9HAKPFW-U05PCNTCV9N-8bbbd8736a14-512"),
        sportText: "수영",
        content: "고양이 애호가입니다. 차린건 없지만 고양이 보고가세요",
        postImages: [
          URL(string: "https://i.ytimg.com/vi/YCaGYUIfdy4/maxresdefault.jpg")!,
          URL(string: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")!,
          URL(string: "https://www.telegraph.co.uk/content/dam/pets/2017/01/06/1-JS117202740-yana-two-face-cat-news_trans_NvBQzQNjv4BqJNqHJA5DVIMqgv_1zKR2kxRY9bnFVTp4QZlQjJfe6H0.jpg?imwidth=450")!,
        ],
        like: 4
      ),
    ]
  }
}
