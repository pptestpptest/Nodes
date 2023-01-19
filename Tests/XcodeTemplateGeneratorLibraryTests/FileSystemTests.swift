//
//  FileSystemTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import Nimble
import XcodeTemplateGeneratorLibrary
import XCTest

#if os(macOS)

final class FileSystemTests: XCTestCase {

    private let fileManager: FileManager = .default

    func testLibraryURL() {
        let fileSystem: FileSystem = fileManager
        let libraryURL: URL = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Library")
        expect(fileSystem.libraryURL) == libraryURL
    }

    func testCreateDirectory() throws {
        let fileSystem: FileSystem = fileManager
        let url: URL = try fileManager
            .url(for: .itemReplacementDirectory,
                 in: .userDomainMask,
                 appropriateFor: fileSystem.libraryURL,
                 create: true)
            .appendingPathComponent("directory")
        try expect(fileSystem.createDirectory(at: url, withIntermediateDirectories: false)).toNot(throwAssertion())
    }

    func testWriteAndContents() throws {
        let fileSystem: FileSystem = fileManager
        let url: URL = try fileManager
            .url(for: .itemReplacementDirectory,
                 in: .userDomainMask,
                 appropriateFor: fileSystem.libraryURL,
                 create: true)
            .appendingPathComponent("file")
        let contents: Data = .init("data".utf8)
        try expect(fileSystem.write(contents, to: url, atomically: true)).toNot(throwAssertion())
        try expect(fileSystem.contents(of: url)) == contents
    }
}

#endif
