// Kevin Li - 6:35 PM - 6/23/20

import SwiftUI

public class ElegantListManager: ObservableObject {

    @Published var currentPage: (index: Int, state: PageState)
    @Published var activeIndex: Int

    public let pageCount: Int
    public let pageTurnType: PageTurnType

    let maxPageIndex: Int

    public var datasource: ElegantPagerDataSource!
    public var delegate: ElegantPagerDelegate?

    public init(startingPage: Int = 0, pageCount: Int, pageTurnType: PageTurnType) {
        guard pageCount > 0 else { fatalError("Error: pages must exist") }

        currentPage = (startingPage, .completed)
        self.pageCount = pageCount
        self.pageTurnType = pageTurnType
        maxPageIndex = (pageCount-1).clamped(to: 0...2)

        if startingPage == 0 {
            activeIndex = 0
        } else if startingPage == pageCount-1 {
            activeIndex = maxPageIndex
        } else {
            activeIndex = 1
        }
    }

    public func scroll(to page: Int) {
        currentPage = (page, .scroll)
    }

    // Only ever called for a page view with more than 3 pages
    func setCurrentPageToBeRearranged() {
        var currentIndex = currentPage.index

        if activeIndex == 1 {
            if currentIndex == 0 {
                // just scrolled from first page to second page
                currentIndex += 1
            } else if currentIndex == pageCount-1 {
                // just scrolled from last page to second to last page
                currentIndex -= 1
            } else {
                return
            }
        } else {
            if activeIndex == 0 {
                guard currentIndex != 0 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentIndex -= 1
            } else if activeIndex == 2 {
                guard currentIndex != pageCount-1 else { return }
                // case where you're on the first page and you drag and stay on the first page
                currentIndex += 1
            }
        }

        currentPage = (currentIndex, .rearrange)
    }

}

protocol ElegantListManagerDirectAccess: PageTurnTypeDirectAccess {

    var pagerManager: ElegantListManager { get }
    var pageTurnType: PageTurnType { get }

}

extension ElegantListManagerDirectAccess {

    var currentPage: (index: Int, state: PageState) {
        pagerManager.currentPage
    }

    var pageCount: Int {
        pagerManager.pageCount
    }

    var activeIndex: Int {
        pagerManager.activeIndex
    }

    var maxPageIndex: Int {
        pagerManager.maxPageIndex
    }

    var pageTurnType: PageTurnType {
        pagerManager.pageTurnType
    }

}