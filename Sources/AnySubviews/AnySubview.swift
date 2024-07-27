//
//  AnySubview.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/24.
//

import SwiftUI

/// AnySubview bridging the gap between `Subview` on iOS 18 and later, and `_VariadicView_Children.Element` on earlier iOS versions.
public struct AnySubview: View, @preconcurrency Identifiable, Sendable {
    
    public let box: Any
    
    init(_ child: _VariadicView_Children.Element) {
        box = child
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    init(_ subview: Subview) {
        box = subview
    }
    
    private var child: _VariadicView_Children.Element {
        box as!  _VariadicView_Children.Element
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    private var subview: Subview {
        box as! Subview
    }
    
    public var id: AnyHashable {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            subview.id
        } else  {
            child.id
        }
    }
    
    public var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            subview
        } else  {
            child
        }
    }
    
    public var containerValues: AnyContainerValues {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            AnyContainerValues(subview)
        } else  {
            AnyContainerValues(child)
        }
    }
}
