## SwiftUI-AnySubviews

SwiftUI-AnySubviews backports iOS 18's subview accessing API to iOS 13, providing a unified API to consistently interact with subviews across different iOS versions.

On iOS 18, SwiftUI introduces a new API [Group(subviews:transform:)](https://developer.apple.com/documentation/swiftui/group/init(subviews:transform:)) to allow developers to access the subviews of a given content view. This API is only available for iOS 18. However, there is an API called `VariadicView` exists since the first release of SwiftUI, which has almost the same feature with `Group(subviews:transform:)`. SwiftUI-AnySubViews unifies these two API so developers can use a consistent API across different iOS versions.

You can check VariadicView's detail on The Moving Parts Team's blog [SwiftUI under the Hood: Variadic Views](https://movingparts.io/variadic-views-in-swiftui).

## Requirements

- Xcode 16, Swift 6.0
- iOS 13, macOS 10.15, tvOS 13, watchOS 6, visionOS 1 or later

## Installation

Please choose the following AnySubviews's version based on your Xcode and Swift version.

|            | Swift 6.0    |
| ---------- | ------------ |
| Xcode 16.0 | exact: 1.1.1 |
| Xcode 16.1 | from: 1.2.0  |

Use [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) to add this package.

```
https://github.com/Lumisilk/SwiftUI-AnySubviews.git
```

If you use SwiftUI-AnySubviews in another package, add this line to your dependencies.
```
.product(name: "AnySubviews", package: "SwiftUI-AnySubviews")
```

## Usage

You can use `BackportGroup` basiclly like using `Group(subviews:transform:)`.

Check the official [documents](https://developer.apple.com/documentation/swiftui/group/init(subviews:transform:)) for further usage.

```swift
import AnySubviews

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
| AnyContainerValues | ContainerValues | _ViewTraitKey |

### ContainerValues

[ContainerValues](https://developer.apple.com/documentation/SwiftUI/ContainerValues) is also supported in AnySubviews.
To define your custom container values associated with a view, use macro `AnyEntry` within `AnyContainerValueKeys`'s extension:

```swift
// Define
extension AnyContainerValueKeys {
//  #AnyEntry<Type>(keyName, defaultValue)
    #AnyEntry<Int>("myNumber", 0)
    #AnyEntry<String>("myName", "Name")
}

// Set
someView
    .anyContainerValue(keyPath: \.myNumber, 1)
    .anyContainerValue(keyPath: \.myName, "Lumi")

// Read
BackportGroup(subviews: content) { subviews in
    ForEach(subviews) { subview in
        let number = subview.containerValues.myNumber.description
        let name = subview.containerValues.myName
        Text(number + " " + name)
    }
}
```

## Dropping iOS 17

When your app no longer needs to support iOS 17 and earlier versions, you can simplify your codebase:

1. Remove the SwiftUI-AnySubviews package from your project completely.
2. Replace all occurrences of `BackportGroup` with `Group` throughout your codebase.
3. For `ContainerValues` especially:
    1. Replace definition part with official API `extension ContainerValues { @Entry ... }`.
    2. Replace setting part with official API `.containerValue(key: MyKey.self, value: 2)`.
    3. Reaplce reading part with official API `subview.containerValues.myCustomValue`.

Note: Only proceed with this step when you're certain that your app's minimum supported iOS version is 18 or later.

## TODO

- [ ] Enrich the error desecription of Macro `AnyEntry`
- [ ] Add Swift 5.9 Support?
- [ ] Add a realistic view example using Anysubviews 

## Contributing

Contributions are welcome! Please feel free to submit a Issue or Pull Request.

## License

SwiftUI-AnySubViews is released under the MIT license. See [LICENSE](/LICENSE) for details.
