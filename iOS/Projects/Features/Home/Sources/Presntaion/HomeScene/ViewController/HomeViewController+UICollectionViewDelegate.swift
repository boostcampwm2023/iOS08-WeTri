//
//  HomeViewController+UICollectionViewDelegate.swift
//  HomeFeature
//
//  Created by MaraMincho on 1/2/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Log
import UIKit

extension HomeViewController: UICollectionViewDelegate {
  func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) {
    Log.make().debug("스크롤 끝남")
  }
}
