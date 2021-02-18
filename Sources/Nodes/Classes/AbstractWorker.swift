//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

/// @mockable
public protocol Worker: AnyObject {

    var isWorking: Bool { get }

    func start()
    func stop()
}

open class AbstractWorker<CancellableType: Cancellable>: Worker {

    public var cancellables: Set<CancellableType> = .init()

    public private(set) var isWorking: Bool = false

    public init() {}

    deinit {
        stop()
    }

    open func didStart() {}
    open func willStop() {}

    public final func start() {
        guard !isWorking
        else { return }
        isWorking = true
        didStart()
    }

    public final func stop() {
        guard isWorking
        else { return }
        willStop()
        cancellables.forEach {
            $0.cancel()
            LeakDetector.detect($0)
        }
        cancellables.removeAll()
        isWorking = false
    }
}
