import XCTest
import TestSupport

/// A stateless type representing an app page, configuration, or modal.
/// UI-test-specific expectations are passed to the robot's methods by UI tests.
@MainActor
public protocol Robot {
    init()
}

@MainActor
private enum RobotComponents {
    static let app = XCUIApplication()
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
}

public extension Robot {
    var app: XCUIApplication {
        RobotComponents.app
    }
    var springboard: XCUIApplication {
        RobotComponents.springboard
    }
}
