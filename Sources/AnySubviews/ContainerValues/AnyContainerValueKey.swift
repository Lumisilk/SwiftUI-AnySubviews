//
//  AnyContainerValueKey.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/08/03.
//
import SwiftUI

public extension View {
    @ViewBuilder
    func anyContainerValue<Key: AnyContainerValueKey>(keyPath: KeyPath<AnyContainerValueKeys, Key.Type>, _ value: Key.Value) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            containerValue(Key.self.containerKeyPath, value)
        } else {
            _trait(Key.self, value)
        }
    }
}

public protocol AnyContainerValueKey: _ViewTraitKey {
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    static var containerKeyPath: WritableKeyPath<ContainerValues, Value> { get }
}

public struct AnyContainerValueKeys {}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension ContainerValues {
    var delegate: ContainerValuesDelegate {
        get { ContainerValuesDelegate(values: self) }
        set { self = newValue.values }
    }
}

@dynamicMemberLookup
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct ContainerValuesDelegate {
    var values: ContainerValues
    
    public subscript<Key: ContainerValueKey>(dynamicMember keyPath: KeyPath<AnyContainerValueKeys, Key.Type>) -> Key.Value {
        get {
            values[Key.self]
        }
        set {
            values[Key.self] = newValue
        }
    }
}
