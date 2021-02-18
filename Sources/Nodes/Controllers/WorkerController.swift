//
//  Created by Christopher Fuller on 10/3/20.
//  Copyright © 2020 Tinder. All rights reserved.
//

public final class WorkerController {

    public private(set) var workers: [Worker] = []

    public init(workers: [Worker]) {
        self.workers = workers
    }

    deinit {
        stopWorkers()
        workers.forEach { LeakDetector.detect($0) }
    }

    public func startWorkers() {
        workers.forEach { $0.start() }
    }

    public func stopWorkers() {
        workers.forEach { $0.stop() }
    }

    public func firstWorker<T>(ofType type: T.Type) -> T? {
        workers.first { $0 is T } as? T
    }

    public func withFirstWorker<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        guard let worker: T = firstWorker(ofType: type)
        else { return }
        try perform(worker)
    }

    public func workers<T>(ofType type: T.Type) -> [T] {
        workers.compactMap { $0 as? T }
    }

    public func withWorkers<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workers(ofType: type).forEach(perform)
    }
}
