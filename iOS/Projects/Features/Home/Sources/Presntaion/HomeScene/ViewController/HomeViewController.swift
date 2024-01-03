//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
  // MARK: Properties

  private let viewModel: HomeViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: UICollectionViewDiffableDataSource<Int, FeedElement>? = nil

  private let fetchFeedPublisher: PassthroughSubject<Void, Never> = .init()
  private let didDisplayFeedPublisher: PassthroughSubject<Void, Never> = .init()

  private var feedCount: Int = 0

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
    setCollectionViewDelegate()
    setDataSource()
    addSection()
    setupStyles()
    setupHierarchyAndConstraints()
    setNavigationItem()
    bind()
    fetchFeedPublisher.send()
  }

  func setCollectionViewDelegate() {
    feedListCollectionView.delegate = self
  }

  func addSection() {
    guard var snapshot = dataSource?.snapshot() else {
      return
    }
    snapshot.appendSections([0])
    dataSource?.apply(snapshot)
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
    let output = viewModel.transform(
      input: HomeViewModelInput(
        requestFeedPublisher: fetchFeedPublisher.eraseToAnyPublisher(),
        didDisplayFeed: didDisplayFeedPublisher.eraseToAnyPublisher()
      )
    )

    output.sink { [weak self] state in
      switch state {
      case .idle:
        break
      case let .fetched(feed):
        self?.updateFeed(feed)
      }
    }
    .store(in: &subscriptions)
  }

  func setNavigationItem() {
    navigationItem.rightBarButtonItem = addBarButtonItem
    navigationItem.leftBarButtonItem = titleBarButtonItem
  }

  func updateFeed(_ item: [FeedElement]) {
    guard let dataSource else {
      return
    }
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(item)
    DispatchQueue.main.async { [weak self] in
      dataSource.apply(snapshot)
      self?.didDisplayFeedPublisher.send()
    }

    feedCount = snapshot.numberOfItems
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
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // 만약 셀이 모자르다면 요청을 보냄
    if (feedCount - 1) - indexPath.row < 3 {
      fetchFeedPublisher.send()
    }
  }
}
