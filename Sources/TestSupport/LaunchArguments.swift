import Foundation

/// Extend with static constants to represent string values in the launch environment.
public struct LaunchEnv: RawRepresentable, Sendable {
    public var rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var value: String? {
        ProcessInfo.processInfo.environment["-" + self.rawValue]
    }
}

/// Extend with static constants to represent boolean values in the launch environment.
public struct LaunchArg: RawRepresentable, Sendable {
    public var rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// This argument is set automatically by the system when running for UI tests
    /// The test runner can't identify some complex UI elements - use this to generate a simplified alternative version for the test runner
    public static let isUITest = Self(rawValue: "XCUITest")
    
    public var isSet: Bool {
        CommandLine.arguments.contains("-" + self.rawValue)
    }
}
