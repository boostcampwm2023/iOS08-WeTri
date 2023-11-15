//
//  RoundShadowView.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - RoundShadowView

final class RoundShadowView: UIView {
  let containerView = UIView()
  let cornerRadius: CGFloat
  let shadow: CustomShadow

  init(shadow: CustomShadow, cornerRadius: CGFloat) {
    self.shadow = shadow
    self.cornerRadius = cornerRadius
    super.init(frame: .zero)

    layoutView(with: shadow)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func layoutView(with customShadow: CustomShadow) {
    // set the shadow of the view's layer
    layer.backgroundColor = UIColor.clear.cgColor
    layer.shadowColor = customShadow.shadowColor
    layer.shadowOffset = customShadow.shadowOffset
    layer.shadowOpacity = customShadow.shadowOpacity
    layer.shadowRadius = customShadow.shadowRadius

    // set the cornerRadius of the containerView's layer
    containerView.layer.cornerRadius = cornerRadius
    containerView.layer.masksToBounds = true

    addSubview(containerView)

    // add constraints
    containerView.translatesAutoresizingMaskIntoConstraints = false

    // pin the containerView to the edges to the view
    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}

// MARK: - CustomShadow

struct CustomShadow {
  let shadowColor: CGColor
  let shadowOffset: CGSize
  let shadowOpacity: Float
  let shadowRadius: CGFloat
}
