import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(ModuleInterfaceTests.allTests),
        ]
    }
#endif
