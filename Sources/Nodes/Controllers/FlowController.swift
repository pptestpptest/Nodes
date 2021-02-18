//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

public final class FlowController {

    public private(set) var flows: [Flow] = []

    internal var isFlowLeakDetectionEnabled: Bool = true

    public init() {}

    deinit {
        flows.forEach(detach)
    }

    public func withoutFlowLeakDetection(withoutFlowLeakDetection: (FlowController) -> Void) {
        isFlowLeakDetectionEnabled = false
        withoutFlowLeakDetection(self)
        isFlowLeakDetectionEnabled = true
    }

    public func attach(starting flow: Flow) {
        guard !flows.contains(where: { $0 === flow }),
              !flow._context.isActive
        else {
            assertionFailure("Unable to attach")
            return
        }
        flows.append(flow)
        flow.start()
    }

    public func detach(ending flow: Flow) {
        guard flows.contains(where: { $0 === flow }),
              flow._context.isActive
        else {
            assertionFailure("Unable to detach")
            return
        }
        flow.end()
        flows.removeAll { $0 === flow }
        if isFlowLeakDetectionEnabled { LeakDetector.detect(flow) }
    }

    public final func detach<T>(endingFlowsOfType type: T.Type, where: (_ flow: T) -> Bool) {
        flows.reversed().forEach { flow in
            guard let typedFlow: T = flow as? T, `where`(typedFlow)
            else { return }
            detach(ending: flow)
        }
    }

    public func firstFlow<T>(ofType type: T.Type) -> T? {
        flows.first { $0 is T } as? T
    }

    public func withFirstFlow<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        guard let flow: T = firstFlow(ofType: type)
        else { return }
        try perform(flow)
    }

    public func flows<T>(ofType type: T.Type) -> [T] {
        flows.compactMap { $0 as? T }
    }

    public func withFlows<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flows(ofType: type).forEach(perform)
    }
}
