//
//  AttachPictureViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/13/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

// MARK: - AttachPictureViewController

final class AttachPictureViewController: UICollectionViewController {
  // MARK: - Property

  private var subscriptions: Set<AnyCancellable> = []

  private var attachPictureCollectionViewDataSource: UICollectionViewDiffableDataSource<Int, UIImage>? = nil

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Init Function

  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension AttachPictureViewController {
  func setup() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: .makeAttachPictureCollectionViewLayout())
    collectionView.register(AttachPictureCollectionViewCell.self, forCellWithReuseIdentifier: AttachPictureCollectionViewCell.identifier)
    setupStyle()
    setAttachPictureCollectionViewDataSource()
  }

  func setupStyle() {
    collectionView.backgroundColor = .clear
  }

  func setAttachPictureCollectionViewDataSource() {
    attachPictureCollectionViewDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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

  private enum Constants {
    static let addPictureImage: UIImage? = .init(systemName: "plus")
  }
}

private extension UICollectionViewLayout {
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
