//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

open class Plugin<ComponentType, BuildType, StateType> {

    private let component: ComponentType

    public init(component: ComponentType) {
        self.component = component
    }

    open func isEnabled(component: ComponentType, state: StateType) -> Bool {
        fatalError("Method in abstract base class must be overridden")
    }

    open func build(component: ComponentType) -> BuildType {
        fatalError("Method in abstract base class must be overridden")
    }

    public func create(state: StateType) -> BuildType? {
        guard isEnabled(component: component, state: state)
        else { return nil }
        return build(component: component)
    }
}

extension Plugin where StateType == Void {

    public func isEnabled(component: ComponentType) -> Bool {
        isEnabled(component: component, state: ())
    }

    public func create() -> BuildType? {
        create(state: ())
    }
}
