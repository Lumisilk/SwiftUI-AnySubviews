//
//  AnySubview.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/24.
//

import SwiftUI

/// AnySubview bridging the gap between `Subview` on iOS 18 and later, and `_VariadicView_Children.Element` on earlier iOS versions.
public struct AnySubview: View, @preconcurrency Identifiable, Sendable {
    
    public let body: AnyView
    public let id: AnyHashable
    
    init(_ child: _VariadicView_Children.Element) {
        body = AnyView(child)
        id = child.id
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    init(_ subview: SwiftUI.Subview) {
        body = AnyView(subview)
        id = subview.id
    }
}
