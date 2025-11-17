import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct StaticTextMacro: AccessorMacro, PeerMacro {
//    enum DeclarationType { case varDecl(String), funcDecl((String, String)...) }
    
    private static func declName(from declaration: some SwiftSyntax.DeclSyntaxProtocol) throws -> String {
        guard
            let variableName = SwiftSyntax.VariableDeclSyntax(declaration)
                .flatMap({decl in SwiftSyntax.PatternBindingSyntax(decl.bindings.first)})
                .flatMap({binding in IdentifierPatternSyntax(binding.pattern)?.identifier.text})
        else { throw MacroExpansionErrorMessage("@staticText can only be applied to variables") }
        
        return variableName
    }

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        let varName = try declName(from: declaration)
        let capitalisedVarName = varName.prefix(1).capitalized + varName.dropFirst()
        return [
            DeclSyntax("""
                @discardableResult
                func check\(raw: capitalisedVarName)(exists: Bool) -> Self {
                    XCTAssertEqual(\(raw: varName).exists, exists)
                    return self
                }
            """),
            DeclSyntax("""
                @discardableResult
                func check\(raw: capitalisedVarName)(reads label: String) -> Self {
                    XCTAssertEqual(\(raw: varName).label, label)
                    return self
                }       
            """)
        ]
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        let accessibilityIdentifier = try LabeledExprListSyntax(node.arguments)
            .flatMap({ args in StringLiteralExprSyntax(args.first?.expression)})
            .flatMap(\.segments.description) ?? declName(from: declaration)
        
        return [
            AccessorDeclSyntax("""
            get {
                app.staticTexts["\(raw: accessibilityIdentifier)"]
            }
            """)
        ]
    }
}

@main
struct RobotMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StaticTextMacro.self
    ]
}
