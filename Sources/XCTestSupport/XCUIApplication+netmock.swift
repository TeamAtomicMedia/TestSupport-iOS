import XCTest
import TestSupport
#if canImport(NetMock)
import NetMock
#endif

public extension XCUIApplication {
    
#if canImport(NetMock)
    // MARK: - NetMock
    
    @discardableResult
    func netmockOverride(method: NetMock.Method = .GET, _ url: URL, response: NetMock.Identifier) -> Self {
        netmockOverride(method: method, url, responses: [response])
    }
    
    @discardableResult
    func netmockOverride(method: NetMock.Method = .GET, _ url: URL, responses: [NetMock.Identifier]) -> Self {
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
#endif
}
