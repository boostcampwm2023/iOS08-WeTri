//
//  GWRoundShadowView.swift
//  DesignSystem
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - GWRoundShadowView

final class GWRoundShadowView: UIView {
  let containerView = UIView()
  let cornerRadius: CGFloat
  let customShadow: CustomShadow
  private var shadowLayer: CAShapeLayer!
  private var fillColor: CGColor = UIColor.blue.cgColor

  func update(color: UIColor) {
    fillColor = color.cgColor
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if shadowLayer == nil {
      shadowLayer = CAShapeLayer()

      shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
      shadowLayer.fillColor = fillColor

      shadowLayer.shadowColor = customShadow.shadowColor
      shadowLayer.shadowPath = shadowLayer.path
      shadowLayer.shadowOffset = customShadow.shadowOffset
      shadowLayer.shadowOpacity = customShadow.shadowOpacity
      shadowLayer.shadowRadius = customShadow.shadowRadius

      layer.insertSublayer(shadowLayer, at: 0)
    }

    if shadowLayer.fillColor != fillColor {
      shadowLayer.fillColor = fillColor
    }
  }

  init(shadow: CustomShadow, cornerRadius: CGFloat, backgroundColor: CGColor) {
    customShadow = shadow
    self.cornerRadius = cornerRadius
    fillColor = backgroundColor
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - CustomShadow

struct CustomShadow {
  let shadowColor: CGColor
  let shadowOffset: CGSize
  let shadowOpacity: Float
  let shadowRadius: CGFloat
}
