import XCTest

/// A robot for a view which has been pushed to a NavigationStack.
public protocol PushedRobot<Parent>: Robot {
    associatedtype Parent: Robot
}
public extension PushedRobot {
    func goBack() -> Parent {
        app.toolbars.buttons.firstMatch.tap()
        return Parent()
    }
}
