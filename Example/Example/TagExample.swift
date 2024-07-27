//
//  TagExample.swift
//  Example
//
//  Created by Lumisilk on 2024/07/27.
//

import SwiftUI
import AnySubviews

struct TagExample: View {
    var body: some View {
        VStack {
            BackportGroup(subviews: content) { subviews in
                ForEach(subviews) { subview in
                    if let tag = subview.containerValues.tag(for: Double.self) {
                        print(tag)
                    }
                    if let tag = subview.containerValues.tag(for: String.self) {
                        print(tag)
                    }
                    return subview
                }
            }
        }
    }
    
    var content: some View {
        Group {
            Text("1")
                .tag(1.0)
                .tag("1: Directly tagged")
            
            Text("2")
                .tag(2.0)
                .tag("2: tagged then modifier")
                .border(.red)
            
            Text("3")
                .tag(3.1)
                .tag("3.1: tagged inside")
                .background(Color.blue)
                .tag(3.2)
                .tag("3.2: tagged outside")
            
            Group {
                Text("4")
                    .tag(4.0)
                    .tag("4: tagged wrapped by Group")
            }
            
            HStack {
                Text("5")
                    .tag(5.0)
                    .tag("5: tagged wrapped by another container")
            }
        }
    }
}

#Preview {
    TagExample()
}
