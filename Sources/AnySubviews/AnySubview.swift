//
//  AnySubview.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/24.
//

import SwiftUI

/// A type erasing view for `Subview` on iOS 18 and `_VariadicView_Children.Element` on other below 18.
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
