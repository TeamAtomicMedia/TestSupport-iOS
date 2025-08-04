import XCTest
import TestSupport

public extension XCUIApplication {
    
    // MARK: - Launch Arguments
    
    @discardableResult
    func addLaunchArg(_ args: LaunchArg...) -> Self {
        self.launchArguments.append(contentsOf: args.map { "-" + $0.rawValue })
        return self
    }
    
    @discardableResult
    func setLaunchEnv(_ env: LaunchEnv, _ value: String?) -> Self {
        self.launchEnvironment["-" + env.rawValue] = value
        return self
    }
}
