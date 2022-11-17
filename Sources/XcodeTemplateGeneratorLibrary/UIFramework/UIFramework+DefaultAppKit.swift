//
//  UIFramework+DefaultAppKit.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """

        static let viewControllerMethodsForRootNode: String = """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewDidAppear() {
                super.viewDidAppear()
                receiver?.viewDidAppear()
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """
    }

    internal static func makeDefaultAppKitFramework() -> UIFramework {
        UIFramework(
            framework: .appKit,
            viewControllerSuperParameters: "nibName: nil, bundle: nil",
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: Defaults.viewControllerMethodsForRootNode
        )
    }
}
