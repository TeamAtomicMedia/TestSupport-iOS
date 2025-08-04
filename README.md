# TestSupport-iOS
Support toolkit for tests

## TestSupport

A support library for interfacing between app and tests.

### LaunchEnv

Represents a string value passed to the app from a UI test. Extend this type with new constants to pass them to the app.

MyAppTestSupport package:
```swift
extension LaunchEnv {
    static let myEnvValue
}
```

UI Tests:
```swift
import XCTestSupport

XCUIApplication().setLaunchEnv(.myEnvValue, "example")
```

App:
```swift
if let value = LaunchEnv.myEnvValue.value {
    // ...
}
```

### LaunchArg

Represents a boolean value passed to the app from a UI test. Extend this type with new constants to pass them to the app.

MyAppTestSupport package:
```swift
extension LaunchArg {
    static let myArg
}
```

UI Tests:
```swift
import XCTestSupport

XCUIApplication().addLaunchArg(.myArg)
```

App:
```swift
if LaunchArg.myArg.value {
    // ...
}
```

## XCTestSupport

Test-specific extensions and helpers.

### Robots

XCTestSupport includes the Robot protocol, and related protocols such as PushedRobotProtocol.

Robots define the minutiae of how to turn a scenario into specific actions, so tests can focus on describing the scenarios they're testing.

Robots represent a page in the app. Robots can make assertions about a displayed page in the app, based on data provided by the test. Robots can also navigate, returning new robots representing a new page or distinct configuration.

Usage:
```
struct HomeScreenRobot: Robot {
    init() {
        // Wait for an element to appear
    }

    // MARK: - Elements

    var myButton: XCUIElement {
        app.buttons["My Button ID or title"]
    }

    // MARK: - Validation

    @discardableResult
    func checkButtonIsShown(expectedTitle: String? = nil) -> Self {
        XCTAssert(myButton.exists)
        if let expectedTitle {
            XCTAssertEqual(myButton.value as? String, expectedTitle)
        }
        return self
    }

    // MARK: - Navigation

    @discardableResult
    func showDetail() -> DetailRobot<Self> { // `Self` is passed as the Parent robot.
        myButton.tap()
        return DetailRobot()
    }
}

struct DetailRobot<Parent: Robot>: PushedRobot {
    // PushedRobot looks for a `Parent` type and finds the generic param.
    // PushedRobot provides a `.goBack()` method, which returns the parent robot.
    
    // ...
}

func myTest() {
    AppRobot()
        .login() // Returns HomeScreenRobot.
        .checkButtonIsShown(expectedTitle: "Hello world")
        .showDetail() // Returns DetailRobot, which can make assertions that Detail is shown in its init.
        .goBack() // Returns HomeScreenRobot, because HomeScreenRobot set itself as the parent.
}
```

### XCUIApplication

#### addLaunchArg / setLaunchEnv

Configure launch parameters for the app when used in UI tests. See the section under TestSupport above for usage examples.

#### NetMock

This package defines helpers for passing NetMock parameters via launch arguments.

```swift
extension AppRobot {
    @discardableResult
    func failLogin() -> Self {
        // Various alternatives:
        app.netmockOverride("GET", "https://api.example.com/login", response: "Failure")

        app.netmockOverride("https://api.example.com/login", response: "Failure")

        app.netmockOverride("https://api.example.com/login", responses: ["Failure", "Success"])

        let failLoginOverride = NetMock.Override(method: "GET", url: URL(string: "https://api.example.com/login")!, responses: ["Failure"])
        app.netmockOverride(failLoginOverride)

        return self
    }
}
```

#### Uninstall

An uninstall helper is provided on XCUIApplication which deletes the app from the HomeScreen via touch interactions. If an app is able to tear down its state programmatically, that approach is preferred as it is significantly faster.

```swift
app.uninstall()
```

#### Wait

A wait helper is provided, which accepts either a KeyPath or a closure producing a Bool, and an optional custom timeout.

This can be more flexible than the built-in `wait` function recently introduced, which only accepts a KeyPath.

```swift
button.wait(for: \.isHittable)
page.wait(for: \.exists, timeout: 10)
text.wait(for: { $0.value as? String == "Hello world" })
```
