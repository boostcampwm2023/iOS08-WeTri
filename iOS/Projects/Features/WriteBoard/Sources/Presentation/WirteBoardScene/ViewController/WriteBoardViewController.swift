//
//  WriteBoardViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WriteBoardViewController

final class WriteBoardViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WriteBoardViewModelRepresentable

  private var attachPictureCollectionViewDataSource: UICollectionViewDiffableDataSource<Int, UIImage>? = nil

  private let completeButtonDidTapPublisher: PassthroughSubject<Void, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Component

  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()

  private lazy var workoutHistoryDescriptionView: WorkoutHistoryDescriptionView? = nil

  private let attachPictureTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
    label.text = Constants.pictureTitleLabelText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var attachPictureCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .makeAttachPictureCollectionViewLayout())
    collectionView.register(AttachPictureCollectionViewCell.self, forCellWithReuseIdentifier: AttachPictureCollectionViewCell.identifier)
    collectionView.delegate = self
    collectionView.backgroundColor = .clear

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private lazy var completeBarButtonItem: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))

    return button
  }()

  // MARK: Initializations

  init(viewModel: WriteBoardViewModelRepresentable) {
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

private extension WriteBoardViewController {
  func setup() {
    workoutHistoryDescriptionView = .init(record: viewModel.record())
    setAttachPictureCollectionViewDataSource()
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    setupNavigationItem()
  }

  func setAttachPictureCollectionViewDataSource() {
    attachPictureCollectionViewDataSource = .init(collectionView: attachPictureCollectionView) { collectionView, indexPath, itemIdentifier in
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: AttachPictureCollectionViewCell.identifier,
          for: indexPath
        ) as? AttachPictureCollectionViewCell
      else {
        return UICollectionViewCell()
      }

      cell.configure(image: itemIdentifier)
      return cell
    }
    guard
      var snapshot = attachPictureCollectionViewDataSource?.snapshot(),
      let addPicImage = Constants.addPictureImage,
      let testImage = UIImage(systemName: "figure.run")
    else {
      return
    }
    snapshot.appendSections([0])
    snapshot.appendItems([addPicImage, testImage])
    attachPictureCollectionViewDataSource?.apply(snapshot)
  }

  func setupNavigationItem() {
    navigationItem.backButtonTitle = "뒤로"
    navigationItem.title = "글쓰기"

    navigationItem.rightBarButtonItem = completeBarButtonItem
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(contentScrollView)
    contentScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    contentScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true

    guard let workoutHistoryDescriptionView else {
      return
    }

    contentScrollView.addSubview(workoutHistoryDescriptionView)
    workoutHistoryDescriptionView.translatesAutoresizingMaskIntoConstraints = false
    workoutHistoryDescriptionView.topAnchor
      .constraint(equalTo: contentScrollView.topAnchor, constant: Metrics.historyViewTopSpacing).isActive = true
    workoutHistoryDescriptionView.leadingAnchor
      .constraint(equalTo: contentScrollView.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true

    contentScrollView.addSubview(attachPictureTitleLabel)
    attachPictureTitleLabel.topAnchor
      .constraint(equalTo: workoutHistoryDescriptionView.bottomAnchor, constant: Metrics.historyViewBottomSpacing).isActive = true
    attachPictureTitleLabel.leadingAnchor
      .constraint(equalTo: workoutHistoryDescriptionView.leadingAnchor).isActive = true

    contentScrollView.addSubview(attachPictureCollectionView)
    attachPictureCollectionView.topAnchor
      .constraint(equalTo: attachPictureTitleLabel.bottomAnchor, constant: Metrics.attachPictureBottomSpacing).isActive = true
    attachPictureCollectionView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor).isActive = true
    attachPictureCollectionView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor).isActive = true
    attachPictureCollectionView.heightAnchor.constraint(equalToConstant: 99).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.secondaryBackground
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

  @objc
  func completeButtonDidTap() {
    completeButtonDidTapPublisher.send()
  }

  enum Metrics {
    static let historyViewTopSpacing: CGFloat = 6

    static let historyViewBottomSpacing: CGFloat = 18

    static let pictureTitleLabelLeadingSpacing: CGFloat = ConstraintsGuideLine.value + 9
    static let attachPictureBottomSpacing: CGFloat = 9
  }

  enum Constants {
    static let pictureTitleLabelText = "사진"

    static let addPictureImage: UIImage? = .init(systemName: "plus")
  }
}

// MARK: UICollectionViewDelegate

extension WriteBoardViewController: UICollectionViewDelegate {}

extension UICollectionViewLayout {
  static func makeAttachPictureCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(attachPictureCollectionViewCellConstants.width),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(
      top: 0,
      leading: attachPictureCollectionViewCellConstants.itemLeadingAndTrailingInset,
      bottom: 0,
      trailing: attachPictureCollectionViewCellConstants.itemLeadingAndTrailingInset
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(attachPictureCollectionViewCellConstants.height)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = .init(
      top: 0,
      leading: attachPictureCollectionViewCellConstants.groupLeadingAndTrailingInset,
      bottom: 0,
      trailing: attachPictureCollectionViewCellConstants.groupLeadingAndTrailingInset
    )

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  private enum attachPictureCollectionViewCellConstants {
    static let height: CGFloat = 94
    static let width: CGFloat = 94

    static let itemLeadingAndTrailingInset: CGFloat = 6

    static let groupLeadingAndTrailingInset: CGFloat = 29
  }
}
