// The Swift Programming Language
// https://docs.swift.org/swift-book


/// A macro that produces the accessor boilerplate for a staticText XCUIElement
@attached(accessor, names: named(get))
public macro staticText(_ string: String) = #externalMacro(module: "RobotMacrosMacros", type: "XCStaticText")
