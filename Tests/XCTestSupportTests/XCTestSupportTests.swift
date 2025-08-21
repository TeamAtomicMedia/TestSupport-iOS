import Testing
@testable import XCTestSupport

struct TestRobot: Robot {
    func doStuff() {}
}

@MainActor
@Test func example() async throws {
    // Basic compilation example
    TestRobot()
        .doStuff()
}
