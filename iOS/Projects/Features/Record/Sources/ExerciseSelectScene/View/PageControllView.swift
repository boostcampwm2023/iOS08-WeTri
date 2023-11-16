//
//  PageControllView.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - UIPageControl

public final class UIPageControl: UIView {
  let countOfPage: Int
  var currentPageIndex: Int = 0
  let spacing: CGFloat = 8
  var pages: [RoundShadowView] = []
  var pageswidthConstraint: [NSLayoutConstraint] = []

  // MARK: - 과연 UIVIew를 optional로 만드는게 맞을까?

  /// 2 와 5 사이 숫자를 입력하세요 아닐경우 nil이 리턴됩니다.
  public init(count: Int = 2) {
    countOfPage = (UIPageControlDefaultProperty.range).contains(count) ?
      count :
      UIPageControlDefaultProperty.numOfMinPage

    super.init(frame: .init(origin: .zero, size: CGSize(width: 60, height: 10)))

    makePages()
    makePageConstraints()
    selectPage(at: 0)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }

  private enum UIPageControlDefaultProperty {
    static let numOfMinPage = 2
    static let numOfMaxPage = 5

    static let range = numOfMaxPage ... numOfMaxPage

    static let selectedPageColor = DesignSystemColor.main03
    static let deselectedPageColor = DesignSystemColor.gray02

    static let selectedPageWidth: CGFloat = 40
    static let deselectedPageWidth: CGFloat = 10
  }
}

private extension UIPageControl {
  func makePages() {
    pages = (0 ..< countOfPage).enumerated().map { _, _ -> RoundShadowView in
      return pageViewObject
    }
  }

  func makePageConstraints() {
    var targetLeadingAnchor = safeAreaLayoutGuide.leadingAnchor
    var targetSpacing: CGFloat = 0

    pages.forEach { page in
      // 중요: 맨 처음 Page객체는 왼쪽으로 붙여야 하기에 필수 불가결적으로 다음 로직이 필요합니다.
      if targetLeadingAnchor != safeAreaLayoutGuide.leadingAnchor {
        targetSpacing = spacing
      }

      addSubview(page)
      page.leadingAnchor.constraint(equalTo: targetLeadingAnchor, constant: targetSpacing).isActive = true
      page.heightAnchor.constraint(equalToConstant: spacing).isActive = true

      let widthAnchor = page.widthAnchor.constraint(equalToConstant: UIPageControlDefaultProperty.deselectedPageWidth)
      widthAnchor.isActive = true
      pageswidthConstraint.append(widthAnchor)

      targetLeadingAnchor = page.trailingAnchor
    }
  }

  var pageViewObject: RoundShadowView {
    let view = RoundShadowView(
      shadow: .init(
        shadowColor: DesignSystemColor.gray02.cgColor,
        shadowOffset: CGSize(width: 0, height: 1),
        shadowOpacity: 0.2, shadowRadius: 4.0
      ),
      cornerRadius: 4,
      backgroundColor: DesignSystemColor.gray03.cgColor
    )

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
}

public extension UIPageControl {
  func selectPage(at pageIndex: Int) {
    guard 0 ..< pages.count ~= pageIndex else {
      return
    }
    let page = pages[pageIndex]
    page.update(color: UIPageControlDefaultProperty.selectedPageColor)

    let pageWidthConstraint = pageswidthConstraint[pageIndex]
    pageWidthConstraint.constant = UIPageControlDefaultProperty.selectedPageWidth
  }

  func deselectPage(at pageIndex: Int) {
    guard 0 ..< pages.count ~= pageIndex else {
      return
    }
    let page = pages[pageIndex]
    page.update(color: UIPageControlDefaultProperty.deselectedPageColor)

    let pageWidthConstraint = pageswidthConstraint[pageIndex]
    pageWidthConstraint.constant = UIPageControlDefaultProperty.deselectedPageWidth
  }
}
