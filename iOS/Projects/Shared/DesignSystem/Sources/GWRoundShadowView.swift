//
//  GWRoundShadowView.swift
//  DesignSystem
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - GWRoundShadowView

public final class GWRoundShadowView: UIView {
  let containerView = UIView()
  let cornerRadius: CGFloat
  let customShadow: GWShadow
  private var shadowLayer: CAShapeLayer!
  private var fillColor: CGColor = UIColor.blue.cgColor

  public func update(color: UIColor) {
    fillColor = color.cgColor
  }

  override public func layoutSubviews() {
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

  public init(shadow: GWShadow, cornerRadius: CGFloat, backgroundColor: CGColor) {
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
