//
//  WriteBoardViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - WriteBoardViewController

final class WriteBoardViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WriteBoardViewModelRepresentable

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

  private let attachPictureViewController = AttachPictureViewController()

  private let boardDetailTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "게시할 내용"
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let boardDetailTextView: UITextView = {
    let textView = UITextView()
    textView.textColor = DesignSystemColor.primaryText
    textView.font = .preferredFont(forTextStyle: .body)
    textView.contentInset = .init(top: 0, left: Metrics.pictureTitleLabelLeadingSpacing, bottom: 0, right: Metrics.pictureTitleLabelLeadingSpacing)
    textView.backgroundColor = DesignSystemColor.gray01

    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    contentScrollView.contentSize = .init(width: view.frame.width, height: boardDetailTextView.frame.maxY)
  }
}

private extension WriteBoardViewController {
  func setup() {
    workoutHistoryDescriptionView = .init(record: viewModel.record())
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    setupNavigationItem()
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
      .constraint(equalTo: workoutHistoryDescriptionView.bottomAnchor, constant: Metrics.groupBottomSpacing).isActive = true
    attachPictureTitleLabel.leadingAnchor
      .constraint(equalTo: workoutHistoryDescriptionView.leadingAnchor).isActive = true

    // TODO: View에 관한 layout이 어떻게 이루어지는지 그리고 View에 lifeCycle에 대해서 자세하게 공부하기
    guard let attachPictureCollectionView = attachPictureViewController.collectionView else { return }
    contentScrollView.addSubview(attachPictureCollectionView)
    attachPictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
    attachPictureCollectionView.topAnchor
      .constraint(equalTo: attachPictureTitleLabel.bottomAnchor, constant: Metrics.attachPictureBottomSpacing).isActive = true
    attachPictureCollectionView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor).isActive = true
    attachPictureCollectionView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor).isActive = true
    attachPictureCollectionView.heightAnchor.constraint(equalToConstant: 99).isActive = true

    contentScrollView.addSubview(boardDetailTitleLabel)
    boardDetailTitleLabel.topAnchor
      .constraint(equalTo: attachPictureCollectionView.bottomAnchor, constant: Metrics.groupBottomSpacing).isActive = true
    boardDetailTitleLabel.leadingAnchor
      .constraint(equalTo: workoutHistoryDescriptionView.leadingAnchor).isActive = true

    contentScrollView.addSubview(boardDetailTextView)
    boardDetailTextView.topAnchor
      .constraint(equalTo: boardDetailTitleLabel.bottomAnchor, constant: Metrics.inGroupTitleAndContentSpacing).isActive = true
    boardDetailTextView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    boardDetailTextView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    boardDetailTextView.heightAnchor.constraint(equalToConstant: 500).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.secondaryBackground
    modalPresentationCapturesStatusBarAppearance = true
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

    static let groupBottomSpacing: CGFloat = 18

    static let pictureTitleLabelLeadingSpacing: CGFloat = ConstraintsGuideLine.value + 9
    static let attachPictureBottomSpacing: CGFloat = 9

    static let inGroupTitleAndContentSpacing: CGFloat = 9
  }

  enum Constants {
    static let pictureTitleLabelText = "사진"
  }
}

// MARK: UIScrollViewDelegate

extension WriteBoardViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    Log.make().debug("Yes, \(scrollView.isScrollEnabled)")
  }
}
