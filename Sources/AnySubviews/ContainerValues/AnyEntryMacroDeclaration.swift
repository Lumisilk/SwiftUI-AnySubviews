//
//  AnyEntryMacroDeclaration.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/08/12.
//

@freestanding(declaration, names: arbitrary)
public macro AnyEntry<T>(_ key: String, _ defaultValue: T) = #externalMacro(module: "AnyEntryMacro", type: "AnyEntryMacro")
