//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

open class AbstractBuilder<ComponentType, BuildType, DynamicBuildDependencyType, DynamicComponentDependencyType> {

    private weak var lastComponent: AnyObject?

    private let componentFactory: (DynamicComponentDependencyType) -> ComponentType

    public init(componentFactory: @escaping (DynamicComponentDependencyType) -> ComponentType) {
        self.componentFactory = componentFactory
    }

    open func build(
        component: ComponentType,
        dynamicBuildDependency: DynamicBuildDependencyType
    ) -> BuildType {
        fatalError("Method in abstract base class must be overridden")
    }

    public final func build(
        _ dynamicBuildDependency: DynamicBuildDependencyType,
        _ dynamicComponentDependency: DynamicComponentDependencyType
    ) -> BuildType {
        let component = componentFactory(dynamicComponentDependency)
        let newComponent = component as AnyObject
        if newComponent === lastComponent {
            assertionFailure("Component must be a new instance")
        }
        lastComponent = newComponent
        return build(component: component, dynamicBuildDependency: dynamicBuildDependency)
    }
}
