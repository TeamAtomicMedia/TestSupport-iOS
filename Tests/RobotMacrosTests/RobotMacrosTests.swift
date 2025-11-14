import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(RobotMacrosMacros)
import RobotMacrosMacros

let testMacros: [String: Macro.Type] = [
    "staticText": StaticTextMacro.self,
]
#endif

final class MacrosTests: XCTestCase {
    func testStaticTextWithIdentifier() throws {
        assertMacroExpansion(
            """
            @staticText("TestElement1")
            var myLabel1: XCUIElement
            """,
            expandedSource:
            """
            var myLabel1: XCUIElement {
                get {
                    app.staticTexts["TestElement1"]
                }
            }
            
            @discardableResult
                func checkMyLabel1(exists: Bool) -> Self {
                    XCTAssertEqual(myLabel1.exists, exists)
                    return self
                }
            
            @discardableResult
                func checkMyLabel1(reads label: String) -> Self {
                    XCTAssertEqual(myLabel1.label, label)
                    return self
                }
            """,
            macros: testMacros
        )
    }
    
    func testStaticTextWithoutIdentifier() throws {
        assertMacroExpansion(
            """
            @staticText
            var myLabel2: XCUIElement
            """,
            expandedSource:
            """
            var myLabel2: XCUIElement {
                get {
                    app.staticTexts["myLabel2"]
                }
            }
            
            @discardableResult
                func checkMyLabel2(exists: Bool) -> Self {
                    XCTAssertEqual(myLabel2.exists, exists)
                    return self
                }
            
            @discardableResult
                func checkMyLabel2(reads label: String) -> Self {
                    XCTAssertEqual(myLabel2.label, label)
                    return self
                }
            """,
            macros: testMacros
        )
    }
}
