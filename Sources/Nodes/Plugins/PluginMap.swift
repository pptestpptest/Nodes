//
//  Created by Christopher Fuller on 10/21/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

open class PluginMap<KeyType: Hashable, ComponentType, BuildType, StateType> {

    public final class Plugin {

        private let _create: (StateType) -> BuildType?

        public init(create: @escaping (StateType) -> BuildType?) {
            _create = create
        }

        public func create(state: StateType) -> BuildType? {
            _create(state)
        }
    }

    fileprivate let component: ComponentType

    public init(component: ComponentType) {
        self.component = component
    }

    open func plugins(component: ComponentType) -> [KeyType: Plugin] {
        fatalError("Method in abstract base class must be overridden")
    }

    public func createAll(state: StateType) -> [BuildType] {
        plugins(component: component).compactMap { $0.value.create(state: state) }
    }

    public func create(key: KeyType, state: StateType) -> BuildType? {
        plugins(component: component)[key]?.create(state: state)
    }
}

extension PluginMap.Plugin where StateType == Void {

    public convenience init(_ create: @escaping @autoclosure () -> BuildType?) {
        self.init(create: create)
    }

    public func create() -> BuildType? {
        create(state: ())
    }
}

extension PluginMap where StateType == Void {

    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    public func create(key: KeyType) -> BuildType? {
        create(key: key, state: ())
    }
}

open class PluginMapWithDefault<KeyType: Hashable,
                                ComponentType,
                                BuildType,
                                StateType>: PluginMap<KeyType, ComponentType, BuildType, StateType> {

    open func `default`(component: ComponentType, state: StateType) -> BuildType {
        fatalError("Method in abstract base class must be overridden")
    }

    public override func createAll(state: StateType) -> [BuildType] {
        [`default`(component: component, state: state)] + super.createAll(state: state)
    }

    public override func create(key: KeyType, state: StateType) -> BuildType {
        super.create(key: key, state: state) ?? `default`(component: component, state: state)
    }
}

extension PluginMapWithDefault where StateType == Void {

    public func create(key: KeyType) -> BuildType {
        create(key: key, state: ())
    }
}
