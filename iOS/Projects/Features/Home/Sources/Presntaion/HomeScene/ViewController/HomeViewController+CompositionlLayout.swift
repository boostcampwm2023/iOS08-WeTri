//
//  HomeViewController+CompositionalLayout.swift
//  HomeFeature
//
//  Created by MaraMincho on 1/3/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

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
