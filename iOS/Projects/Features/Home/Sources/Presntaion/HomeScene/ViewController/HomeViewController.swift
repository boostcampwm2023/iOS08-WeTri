//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
  // MARK: Properties

  private let viewModel: HomeViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  var dataSource: UICollectionViewDiffableDataSource<Int, FeedElement>? = nil

  // MARK: UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "test button"))

  private let titleBarButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(title: "홈")
    item.tintColor = DesignSystemColor.primaryText

    // TODO: 버그가 있는 코드
    // 이유를 알지 못하겠음...
    let titleBarButtonItemFont: UIFont = .preferredFont(forTextStyle: .title1, weight: .bold)
    item.setTitleTextAttributes([.font: titleBarButtonItemFont], for: .normal)
    item.setTitleTextAttributes([.font: titleBarButtonItemFont], for: .selected)

    return item
  }()

  private let addBarButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(systemItem: .add)
    item.tintColor = DesignSystemColor.primaryText

    return item
  }()

  private let feedListCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFeedCollectionViewLayout())
    collectionView.register(FeedItemCollectionViewCell.self, forCellWithReuseIdentifier: FeedItemCollectionViewCell.identifier)
    collectionView.backgroundColor = .clear

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  // MARK: Initializations

  init(viewModel: HomeViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

private extension HomeViewController {
  func setup() {
    setDataSource()
    setupStyles()
    setupHierarchyAndConstraints()
    setNavigationItem()
    bind()
    testCollectionViewDataSource()
  }

  func setDataSource() {
    dataSource = .init(collectionView: feedListCollectionView) { collectionView, indexPath, item in
      let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedItemCollectionViewCell.identifier, for: indexPath)
      guard let cell = dequeuedCell as? FeedItemCollectionViewCell
      else {
        return UICollectionViewCell()
      }
      cell.configure(item)
      return cell
    }
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(feedListCollectionView)
    feedListCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    feedListCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    feedListCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    feedListCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  func setNavigationItem() {
    navigationItem.rightBarButtonItem = addBarButtonItem
    navigationItem.leftBarButtonItem = titleBarButtonItem
  }

  func testCollectionViewDataSource() {
    guard let dataSource else {
      return
    }
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(fakeData(), toSection: 0)
    dataSource.apply(snapshot)
  }

  enum Constants {
    static let navigationTitleText = "홈"
  }

  enum Metrics {}
}

private extension HomeViewController {
  static func makeFeedCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 9, leading: 0, bottom: 9, trailing: 0)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(455))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  func fakeData() -> [FeedElement] {
    return [
      .init(
        ID: 1,
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
        ID: 2,
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
        ID: 3,
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
        ID: 4,
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
        ID: 5,
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
        ID: 6,
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
        ID: 7,
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
        ID: 8,
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
