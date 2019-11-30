import XCTest
import Foundation

class VersionCommandTests: XCTestCase {

    func testVersion() throws {
        let process = Process()
        let pipe = Pipe()
        process.launchPath = binaryURL.path
        process.arguments = ["version"]
        process.standardOutput = pipe
        if #available(OSX 10.13, *) {
            try process.run()
        } else {
            process.waitUntilExit()
        }
        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self).trimmingCharacters(in: .newlines)
        XCTAssertEqual(output, "ModuleInterface v0.0.3")
    }

}
