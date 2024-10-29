//
//  AnyContainerValues.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/27.
//

import SwiftUI

@dynamicMemberLookup
public struct AnyContainerValues {
    private let box: Any
    
    init(_ child: _VariadicView_Children.Element) {
        box = child
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    init(_ subview: Subview) {
        box = subview.containerValues
    }
    
    private var child: _VariadicView_Children.Element {
        box as! _VariadicView_Children.Element
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    private var containerValues: ContainerValues {
        box as! ContainerValues
    }
    
    /// The tag value for the given type if the container values contains one.
    public func tag<V: Hashable>(for type: V.Type) -> V? {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return containerValues.tag(for: type)
        } else  {
            if let traits = Mirror(reflecting: child).descendant("traits", "storage") as? (any BidirectionalCollection) {
                for element in traits {
                    if let value = Mirror(reflecting: element).descendant("value", "tagged") as? V {
                        return value
                    }
                }
            }
            return nil
        }
    }
    
    /// Returns true if the container values contain a tag matching a given value.
    public func hasTag<V: Hashable>(_ tag: V) -> Bool {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return containerValues.hasTag(tag)
        } else  {
            if let traits = Mirror(reflecting: child).descendant("traits", "storage") as? (any BidirectionalCollection) {
                for element in traits {
                    if let value = Mirror(reflecting: element).descendant("value", "tagged") as? V {
                        return value == tag
                    }
                }
            }
            return false
        }
    }
    
    /// Access the particular container value associated with a custom keyPath.
    public subscript<Key: AnyContainerValueKey>(dynamicMember keyPath: KeyPath<AnyContainerValueKeys, Key.Type>) -> Key.Value {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            let keyType = Key.self as! any ContainerValueKey.Type
            return containerValues[keyType] as! Key.Value
        } else  {
            return child[Key.self]
        }
    }
}
