//
//  FeedDetailImageScrollView.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - FeedDetailImageScrollView

final class FeedDetailImageScrollView: UIScrollView {}

private extension UICollectionViewLayout {
  func createLayout() -> UICollectionViewCompositionalLayout {
    // Create item
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))

    // Create group with horizontal paging behavior
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

    // Create section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered

    // Create compositional layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}
