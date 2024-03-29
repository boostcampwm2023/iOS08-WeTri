//
//  GWPageConrol.swift
//  DesignSystem
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UIKit

// MARK: - GWPageControl

public final class GWPageControl: UIView {
  /// proeprty
  private let numberOfPage: Int
  private var currentPageIndex: Int = 0
  private let spacing: CGFloat = 8
  private var pages: [UIView] = []
  private var pageswidthConstraint: [NSLayoutConstraint] = []

  // itrinsicContentSize

  /// pageController width value
  /// numOfPage = n, PageSpacing = 8
  /// selectedPageWidth = 40, unSelectedPageWidth = 10
  /// pageControlWidth = 40 + 10(n - 1) + 8(n - 1) = 18n + 22
  private var pageControllerWidth: CGFloat {
    return .init(18 * numberOfPage + 22)
  }

  private var pageControllerHeight: CGFloat = 8
  override public var intrinsicContentSize: CGSize {
    return .init(width: pageControllerWidth, height: pageControllerHeight)
  }

  /// init에서 만약 5보다 큰 수나 2보다 작은 수가 입력되는 경우
  /// page 갯수가 2개로 설정 됩니다.
  public init(count: Int) {
    numberOfPage = (UIPageControlDefaultProperty.range).contains(count) ? count : UIPageControlDefaultProperty.numOfMinPage

    super.init(frame: .zero)

    makePages()
    makePageConstraints()
    updateSelectPage(at: 0)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("can not use initialization")
  }
}

private extension GWPageControl {
  func makePages() {
    pages = (0 ..< numberOfPage).map { _ in pageView }
  }

  func makePageConstraints() {
    var targetLeadingAnchor = safeAreaLayoutGuide.leadingAnchor
    var targetSpacing: CGFloat = 0

    pages.forEach { page in
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

  private var pageView: UIView {
    let view = UIView()
    view.layer.cornerRadius = 4
    view.clipsToBounds = true
    view.backgroundColor = UIPageControlDefaultProperty.deselectedPageColor
    view.layer.cornerCurve = .continuous

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
}

public extension GWPageControl {
  func select(at pageIndex: Int) {
    if pageIndex >= pages.count || currentPageIndex < 0 {
      return
    }
    updateDeselectPage(at: currentPageIndex)
    currentPageIndex = pageIndex
    updateSelectPage(at: currentPageIndex)

    startAnimation()
  }

  func next() {
    if currentPageIndex >= pages.count - 1 || currentPageIndex < 0 {
      return
    }
    updateDeselectPage(at: currentPageIndex)
    currentPageIndex += 1
    updateSelectPage(at: currentPageIndex)

    startAnimation()
  }

  func back() {
    if currentPageIndex >= pages.count || currentPageIndex <= 0 {
      return
    }
    updateDeselectPage(at: currentPageIndex)
    currentPageIndex -= 1
    updateSelectPage(at: currentPageIndex)

    startAnimation()
  }
}

private extension GWPageControl {
  func startAnimation() {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
      guard let self else { return }
      layoutIfNeeded()
    }
  }

  func updateSelectPage(at pageIndex: Int) {
    guard 0 ..< pages.count ~= pageIndex else {
      return
    }
    let page = pages[pageIndex]
    page.backgroundColor = UIPageControlDefaultProperty.selectedPageColor

    let pageWidthConstraint = pageswidthConstraint[pageIndex]
    pageWidthConstraint.constant = UIPageControlDefaultProperty.selectedPageWidth
  }

  func updateDeselectPage(at pageIndex: Int) {
    guard 0 ..< pages.count ~= pageIndex else {
      return
    }
    let page = pages[pageIndex]
    page.backgroundColor = UIPageControlDefaultProperty.deselectedPageColor

    let pageWidthConstraint = pageswidthConstraint[pageIndex]
    pageWidthConstraint.constant = UIPageControlDefaultProperty.deselectedPageWidth
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
