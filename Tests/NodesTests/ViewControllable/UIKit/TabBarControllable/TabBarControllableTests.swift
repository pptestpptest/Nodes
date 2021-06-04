//
//  TabBarControllableTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 5/4/21.
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class TabBarControllableTests: XCTestCase {

    func testSet() {
        let tabBarController: TabBarControllable = givenTabBarController()
        expect(tabBarController.viewControllers).to(beEmpty())
        let viewControllers: [UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
        expect(viewControllers).to(notBeNilAndElementsToDeallocateAfterTest())
        tabBarController.viewControllers = viewControllers
        expect(tabBarController.viewControllers?.map { $0._asUIViewController() }) == viewControllers
    }

    func testAsUITabBarController() {
        let tabBarController: TabBarControllable = givenTabBarController()
        expect(tabBarController._asUITabBarController()) === tabBarController
        expect(tabBarController._asUITabBarController()).to(beAKindOf(UITabBarController.self))
    }

    private func givenTabBarController() -> UITabBarController {
        let tabBarController: UITabBarController = .init()
        expect(tabBarController).to(notBeNilAndToDeallocateAfterTest())
        return tabBarController
    }
}

#endif
