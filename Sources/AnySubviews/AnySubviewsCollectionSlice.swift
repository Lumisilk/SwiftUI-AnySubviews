//
//  AnySubviewsCollectionSlice.swift
//  AnySubviews
//
//  Created by Lumisilk on 2024/07/24.
//

import SwiftUI

/// AnySubviewsCollectionSlice bridging the gap between `SubviewsCollectionSlice` on iOS 18 and later, and `Slice<_VariadicView_Children>` on earlier iOS versions.
public struct AnySubviewsCollectionSlice: RandomAccessCollection {
    
    public typealias Element = AnySubview
    
    public typealias Index = Int
    
    public typealias SubSequence = AnySubviewsCollectionSlice
    
    public typealias Indices = Range<Int>
    
    public typealias Iterator = AnyIterator<AnySubview>
    
    private var box: Any
    
    init(children: Slice<_VariadicView_Children>) {
        box = children
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    init(subviews: SubviewsCollectionSlice) {
        box = subviews
    }
    
    private var children: Slice<_VariadicView_Children> {
        box as! Slice<_VariadicView_Children>
    }
    
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    private var subviews: SubviewsCollectionSlice {
        box as! SubviewsCollectionSlice
    }
    
    public subscript(position: Int) -> AnySubview {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            AnySubview(subviews[position])
        } else  {
            AnySubview(children[position])
        }
    }
    
    public subscript(bounds: Range<Int>) -> AnySubviewsCollectionSlice {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            AnySubviewsCollectionSlice(subviews: subviews[bounds])
        } else  {
            AnySubviewsCollectionSlice(children: children[bounds])
        }
    }
    
    public var startIndex: Int {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            subviews.startIndex
        } else  {
            children.startIndex
        }
    }
    
    public var endIndex: Int {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            subviews.endIndex
        } else  {
            children.endIndex
        }
    }
    
    public func makeIterator() -> Iterator {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            var iterator = subviews.makeIterator()
            return AnyIterator {
                iterator.next().map(AnySubview.init)
            }
        } else  {
            var iterator = children.makeIterator()
            return AnyIterator {
                iterator.next().map(AnySubview.init)
            }
        }
    }
}

extension AnySubviewsCollectionSlice: View {
    @ViewBuilder
    public var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            subviews
        } else  {
            ForEach(children) { $0 }
        }
    }
}
