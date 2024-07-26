## SwiftUI-AnySubViews

SwiftUI-AnySubviews is a library that unifies subview access APIs across different iOS versions, providing a consistent interface for SwiftUI developers.

On iOS 18, SwiftUI introduces a new API [Group(subviews:transform:)](https://developer.apple.com/documentation/swiftui/group/init(subviews:transform:) to allow developers to access the subviews of a given content view. This API is only available for iOS 18. However, there is an API called `VariadicView` exists since the first release of SwiftUI, which has almost the same feature with `Group(subviews:transform:)`.

SwiftUI-AnySubViews unifies these two API so developers can use a consistent API across different iOS versions, providing compatibility and future-proofing your SwiftUI code.

## Requirements

- Xcode 16 (Swift 6.0)
- iOS 13, macOS 10.15, tvOS 13, watchOS 6, visionOS 1 or later

## Installation

Use [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) to add this package.
```
https://github.com/Lumisilk/SwiftUI-AnySubviews.git
```

## Usage

You can use `BackportGroup` basiclly like using `Group(subviews:transform:)`.

Check [the official documents](https://developer.apple.com/documentation/swiftui/group/init(subviews:transform:)) for further usage.

```swift
import BackportGroup

struct CardsView<Content: View>: View {
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            BackportGroup(subviews: content) { subviews in
                HStack {
                    if subviews.count >= 2 {
                        SecondaryCard { subview[1] }
                    }
                    if let first = subviews.first {
                        FeatureCard { first }
                    }
                    if subviews.count >= 3 {
                        SecondaryCard { subviews[2] }
                    }
                }
                if subviews.count > 3 {
                    subviews[3...]
                }
            }
        }
    }
}
```

### Types

SwiftUI-AnySubViews unifies the following types, ensuring consistent API usage across different iOS versions:

| AnySubViews | iOS 18 API | below iOS 18 |
| --- | --- | --- |
| AnySubview | Subview | \_VariadicView_Children.Element |
| AnySubviewsCollection | SubviewsCollection | \_VariadicView_Children |
| AnySubviewsCollectionSlice | SubviewsCollectionSlice | Slice<_VariadicView_Children> |

## Limitation

Due to Swift language constraints, setting and accessing [container values](https://developer.apple.com/documentation/swiftui/containervalues) of a view is not supported in this library.

## Dropping iOS 17

When your app no longer needs to support iOS 17 and earlier versions, you can simplify your codebase:

1. Remove the SwiftUI-AnySubviews package from your project.
2. Replace all occurrences of `BackportGroup` with `Group` throughout your codebase.

Note: Only proceed with this step when you're certain that your app's minimum supported iOS version is 18 or later.

## Contributing

Contributions are welcome! Please feel free to submit a Issue or Pull Request.

## License

SwiftUI-AnySubViews is released under the MIT license. See [LICENSE](/LICENSE) for details.
