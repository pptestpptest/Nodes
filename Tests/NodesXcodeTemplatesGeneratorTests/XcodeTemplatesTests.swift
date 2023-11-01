//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class XcodeTemplatesTests: XCTestCase {

    private typealias Config = XcodeTemplates.Config

    private struct TestContext: Context {

        let dictionary: [String: Any] = ["key": "value"]
    }

    private struct TestXcodeTemplate: XcodeTemplate {

        let name: String = "name"
        let type: String = "type"
        let stencils: [StencilTemplate] = []
        let context: Context = TestContext()
        let propertyList: PropertyList = .init(description: "description", sortOrder: 23) {}
    }

    func testGenerateWithIdentifier() throws {
        let fileSystem: FileSystemMock = .init()
        try XcodeTemplates(config: Config()).generate(identifier: "identifier", using: fileSystem)
        assertSnapshot(matching: fileSystem.directories,
                       as: .dump,
                       named: "Directories")
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        assertSnapshot(matching: writes.map { (path: $0.path, atomically: $0.atomically) },
                       as: .dump,
                       named: "Writes")
        writes.forEach { write in
            let name: String = write.path
                .split(separator: "/")
                .reversed()[0...1]
                .reversed()
                .joined(separator: "-")
                .replacingOccurrences(of: [".xctemplate", "___FILEBASENAME___", ".swift", ".plist"], with: "")
            assertSnapshot(matching: write.contents, as: .lines, named: "Contents.\(name)")
        }
        assertSnapshot(matching: fileSystem.copies,
                       as: .dump,
                       named: "Copies")
        assertSnapshot(matching: fileSystem.deletions,
                       as: .dump,
                       named: "Deletions")
    }

    func testGenerateWithURL() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try XcodeTemplates(config: Config()).generate(at: url, using: fileSystem)
        assertSnapshot(matching: fileSystem.directories,
                       as: .dump,
                       named: "Directories")
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        assertSnapshot(matching: writes.map { (path: $0.path, atomically: $0.atomically) },
                       as: .dump,
                       named: "Writes")
        writes.forEach { assertSnapshot(matching: $0.contents, as: .lines, named: "Contents.\($0.path)") }
        assertSnapshot(matching: fileSystem.copies,
                       as: .dump,
                       named: "Copies")
        assertSnapshot(matching: fileSystem.deletions,
                       as: .dump,
                       named: "Deletions")
    }
}
