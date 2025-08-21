import XCTest

public extension XCUIElement {
    /// A wait function which accepts waiting for any derived property to be true, and includes a default timeout of 1s.
    func wait(for property: KeyPath<XCUIElement, Bool>, timeout: TimeInterval = 1) -> Bool {
        wait(for: { $0[keyPath: property] }, timeout: timeout)
    }
    
    /// A wait function which accepts waiting for any derived property to be true, and includes a default timeout of 1s.
    func wait(for property: @escaping (Self) -> Bool, timeout: TimeInterval = 1) -> Bool {
        let result = XCTWaiter().wait(
            for: [
                XCTNSPredicateExpectation(
                    predicate: NSPredicate { `self`, _ in
                        guard let self = self as? Self else { return false }
                        return property(self)
                    },
                    object: self
                )
            ],
            timeout: timeout
        )
        return result == .completed
    }
}
