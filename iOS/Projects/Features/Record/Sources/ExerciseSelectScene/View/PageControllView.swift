//
//  PageControllView.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

final class UIPageControll: UIView {
  init() {
    super.init(frame: .zero)
  }

  override init(frame _: CGRect) {
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private let currentPageView: RoundShadowView = {
    let view = RoundShadowView(
      shadow: .init(
        shadowColor: DesignSystemColor.main03.cgColor,
        shadowOffset: CGSize(width: 0, height: 1),
        shadowOpacity: 0.2, shadowRadius: 4.0
      ),
      cornerRadius: 4
    )
    
    view.backgroundColor = DesignSystemColor.main03

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let pageView: RoundShadowView = {
    let view = RoundShadowView(
      shadow: .init(
        shadowColor: DesignSystemColor.main03.cgColor,
        shadowOffset: CGSize(width: 0, height: 1),
        shadowOpacity: 0.2, shadowRadius: 4.0
      ),
      cornerRadius: 4
    )
    
    view.backgroundColor = DesignSystemColor.main03

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
}
