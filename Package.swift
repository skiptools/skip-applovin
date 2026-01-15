// swift-tools-version: 6.1
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "skip-applovin",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SkipAppLovin", type: .dynamic, targets: ["SkipAppLovin"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.6.36"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", from: "13.5.1"),
    ],
    targets: [
        .target(name: "SkipAppLovin", dependencies: [
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package", condition: .when(platforms: [.iOS, .tvOS]))
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipAppLovinTests", dependencies: [
            "SkipAppLovin",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

if Context.environment["SKIP_BRIDGE"] ?? "0" != "0" {
    package.dependencies += [.package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0")]
    package.targets.forEach({ target in
        target.dependencies += [.product(name: "SkipFuseUI", package: "skip-fuse-ui")]
    })
    // all library types must be dynamic to support bridging
    package.products = package.products.map({ product in
        guard let libraryProduct = product as? Product.Library else { return product }
        return .library(name: libraryProduct.name, type: .dynamic, targets: libraryProduct.targets)
    })
}
