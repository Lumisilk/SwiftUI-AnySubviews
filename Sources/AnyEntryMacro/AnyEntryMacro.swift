//
//  AnyEntryMacro.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/08/12.
//
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AnyEntryMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard
            let argument = node.argumentList.first?.expression.as(StringLiteralExprSyntax.self),
            let key = argument.segments.first?.as(StringSegmentSyntax.self)?.content.text,
            let defaultValueExpr = node.argumentList.dropFirst().first?.expression,
            let genericArgument = node.genericArgumentClause?.arguments.first?.argumentType
        else {
            fatalError("Invalid macro usage")
        }

        let keyType = "__Key_\(key)"
        
        let propertyDecl = """
        var \(key): \(keyType).Type {
            \(keyType).self
        }
        """
        
        let enumDecl = """
        enum \(keyType): AnyContainerValueKey, ContainerValueKey {
            static var defaultValue: \(genericArgument) { \(defaultValueExpr) }
            
            @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
            static var containerKeyPath: WritableKeyPath<ContainerValues, \(genericArgument)> {
                \\ContainerValues.delegate.\(key)
            }
        }
        """
        
        return [
            DeclSyntax(stringLiteral: propertyDecl),
            DeclSyntax(stringLiteral: enumDecl)
        ]
    }
}

@main
struct AnyEntryPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AnyEntryMacro.self
    ]
}
