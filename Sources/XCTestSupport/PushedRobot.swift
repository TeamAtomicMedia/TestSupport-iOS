import XCTest

/// A robot for a view which has been pushed to a NavigationStack.
public protocol PushedRobot<Parent>: Robot {
    associatedtype Parent: Robot
}
public extension PushedRobot {
    @discardableResult
    func goBack() -> Parent {
        if app.toolbars.buttons.exists {
            app.toolbars.buttons.firstMatch.tap()
        } else {
            app.navigationBars.buttons.firstMatch.tap()
        }
        return Parent()
    }
    
    @discardableResult
    func checkCanGoBack() -> Self {
        XCTAssert(app.toolbars.buttons.exists || app.navigationBars.buttons.exists)
        return self
    }
}
