import XCTest
import TestSupport
import NetMock

public extension XCUIApplication {
    
    // MARK: - NetMock
    
    @discardableResult
    func netmockOverride(method: String = "GET", _ url: URL, response: String) -> Self {
        netmockOverride(method: method, url, responses: [response])
    }
    
    @discardableResult
    func netmockOverride(method: String = "GET", _ url: URL, responses: [String]) -> Self {
        netmockOverride(.init(method: method, url: url, responses: responses))
    }
    
    @discardableResult
    func netmockOverride(_ override: NetMock.Override) -> Self {
        netmockOverride([override])
    }
    
    @discardableResult
    func netmockOverride(_ overrides: [NetMock.Override]) -> Self {
        do {
            let encoded = try String(data: JSONEncoder().encode(overrides), encoding: .utf8)
            return setLaunchEnv(.netMockOverrides, encoded)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
