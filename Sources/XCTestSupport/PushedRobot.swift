import XCTest

/// A robot for a view which has been pushed to a NavigationStack.
public protocol PushedRobot<Parent>: Robot {
    associatedtype Parent: Robot
}
public extension PushedRobot {
    func goBack() -> Parent {
        if app.toolbars.buttons.firstMatch.exists {
            app.toolbars.buttons.firstMatch.tap()
        } else {
            app.navigationBars.buttons.firstMatch.tap()
        }
        return Parent()
    }
}
