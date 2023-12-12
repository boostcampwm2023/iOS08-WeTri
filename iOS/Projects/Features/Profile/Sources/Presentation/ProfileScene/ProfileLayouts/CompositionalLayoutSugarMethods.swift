//
//  CompositionalLayoutSugarMethods.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
  static func createProfileLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionNumber, _ in
      switch sectionNumber {
      case ProfileSection.header.rawValue:
        return .createProfileHeaderSection()
      case ProfileSection.main.rawValue:
        return .createProfileMainSection()
      case ProfileSection.emptyState.rawValue:
        return .createProfileEmptyStateSection()
      default:
        return nil
      }
    }
  }
}

extension NSCollectionLayoutSection {
  /// 프로필 화면에서 상단 헤더의 레이아웃을 갖는 섹션을 설정합니다.
  static func createProfileHeaderSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)) // 대략 300으로 설정함
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]

    return section
  }

  /// 프로필 화면에서 게시글에 들어가는 레이아웃의 섹션을 설정합니다.
  static func createProfileMainSection() -> NSCollectionLayoutSection {
    // 각 아이템의 사이즈를 정의합니다.
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1 / 3),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1 / 3)
    )

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    // 섹션 정의
    return NSCollectionLayoutSection(group: group)
  }

  /// 프로필 화면에서 게시글이 없을 경우 보여지는 Empty View 섹션을 설정합니다.
  static func createProfileEmptyStateSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]

    return section
  }
}
