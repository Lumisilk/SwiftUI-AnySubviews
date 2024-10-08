//
//  SwiftUIView.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/24.
//

import SwiftUI

/// BackportGroup is a backport API for accessing subviews of the given content view.
///
/// After dropping supports for iOS 17,
/// you can remove AnySubviews package completely and replace all 'BackportGroup' with 'Group' throughout your codebase.
public struct BackportGroup<Content: View, Result: View>: View {
    
    private let content: Content
    private let transform: (AnySubviewsCollection) -> Result
    
    /// Constructs a group from the subviews of the given view.
    ///
    /// - Parameters:
    ///   - view: The content view containing the subviews you want to access.
    ///   - transform: A closure that takes an AnySubviewsCollection and returns a new view hierarchy.
    public init(
        subviews view: Content,
        @ViewBuilder transform: @escaping (AnySubviewsCollection) -> Result
    ) {
        self.content = view
        self.transform = transform
    }
    
    public var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            Group(subviews: content) { subviews in
                transform(AnySubviewsCollection(subviews: subviews))
            }
        } else {
            _VariadicView.Tree(
                Root { children in
                    transform(AnySubviewsCollection(children: children))
                },
                content: { content }
            )
        }
    }
}

private struct Root<Result: View>: _VariadicView_ViewRoot {
    let childrenHandler: (_VariadicView_Children) -> Result
    
    func body(children: _VariadicView_Children) -> some View {
        childrenHandler(children)
    }
}

private struct Example<Content: View>: View {
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack {
            BackportGroup(subviews: content()) { subviews in
                subviews[..<(subviews.count / 2)]
                    .padding()
                    .background(Color.gray)
                
                ForEach(subviews[(subviews.count / 2)...]) { subview in
                    subview
                    Divider()
                }
            }
        }
    }
}

#Preview {
    Example {
        ForEach(0..<10) { Text($0.description) }
    }
}
