# SkipAppLovin

This is a free [Skip](https://skip.tools) Swift/Kotlin library project wrapping around the AppLovin MAX library for iOS and Android.

AppLovin MAX provides a closed-source SDK for iOS and Android. Each SDK has a Github repo, but the repos only contain sample code and bug reports.

* https://github.com/appLovin/AppLovin-MAX-SDK-iOS/
* https://github.com/AppLovin/AppLovin-MAX-SDK-Android/

There are integration guides here:
* https://support.axon.ai/en/max/ios/overview/integration/
* https://support.axon.ai/en/max/android/overview/integration/

There's no generated HTML API documentation for either library.

## Initialization

Before attempting to load any ads, you'll need to initialize AppLovin with your SDK key, using `SkipAppLovin`, like this:

```swift
let YOUR_SDK_KEY = "..."
let result = await SkipAppLovin.current.initialize(sdkKey: YOUR_SDK_KEY)
```

You can find your SDK key in the https://dash.applovin.com/o/account#keys section of the AppLovin dashboard.

### Settings

The `initialize` function accepts a number of parameters:

```swift
/// Initializes the AppLovin SDK.
///
/// - Parameters:
///   - sdkKey: SDK key for the AppLovin SDK. See https://dash.applovin.com/o/account#keys
///   - axonEventKey: Axon event key for the AppLovin SDK.
///   - mediationProvider: The mediation provider. Set this either by using one of the provided strings in ALMediationProvider, or your own string if you do not find an applicable one there.
///   - pluginVersion: Sets the plugin version for the mediation adapter or plugin.
///   - segmentCollection: A collection of user segments. See https://support.axon.ai/en/max/ios/overview/data-and-keyword-passing/ for more details
///   - testDeviceAdvertisingIdentifiers: Enable devices to receive test ads by passing in the advertising identifier (IDFA or IDFV on iOS, GAID on Android) of each test device. Refer to AppLovin logs for the id of your current device.
///   - adUnitIdentifiers: The MAX ad unit IDs that you will use for this instance of the SDK. This initializes third-party SDKs with the credentials configured for these ad unit IDs.
///   - exceptionHandlerEnabled: Whether or not the AppLovin SDK listens to exceptions. Defaults to true.
/// - Returns: An ALSdkConfiguration object.
public func initialize(
    sdkKey: String,
    axonEventKey: String? = nil,
    mediationProvider: String = ALMediationProviderMAX,
    pluginVersion: String? = nil,
    segmentCollection: MASegmentCollection? = nil,
    testDeviceAdvertisingIdentifiers: [String]? = nil,
    adUnitIdentifiers: [String]? = nil,
    exceptionHandlerEnabled: Bool? = nil
) async -> ALSdkConfiguration {
```

Some privacy settings are configured via `ALPrivacySettings`.

```swift
/// This class contains privacy settings for AppLovin.
public struct ALPrivacySettings {
    /// Sets whether or not the user has provided consent for information-sharing with AppLovin.
    ///
    /// - Parameter hasUserConsent: `true` if the user provided consent for information-sharing with AppLovin. `false` by default.
    public static func setHasUserConsent(_ hasUserConsent: Bool) { /* ... */}
    
    /// Sets whether or not the user has opted out of the sale of their personal information.
    ///
    /// - Parameter doNotSell: `true` if the user opted out of the sale of their personal information.
    public static func setDoNotSell(_ doNotSell: Bool) { /* ... */ }
}
```

Use them like this before initializing the SDK:

```swift
import SkipAppLovin
#if canImport(AppLovinSDK)
import AppLovinSDK
#endif

ALPrivacySettings.setDoNotSell(true)
ALPrivacySettings.setHasUserConsent(false)
let result = await SkipAppLovin.current.initialize(sdkKey: YOUR_SDK_KEY)
```

And some other settings are configured via `ALSdkSettings`.

```swift
/// This class contains mutable settings for the AppLovin SDK.
public class ALSdkSettings {
        
    /// Settings relating to the MAX Terms and Privacy Policy Flow.
    public var termsAndPrivacyPolicyFlowSettings: ALTermsAndPrivacyPolicyFlowSettings { /* ... */ }
    
    /// A toggle for verbose logging for the SDK. This is set to `false` by default. Set it to `false` if you want the SDK to be silent (this is recommended for App Store submissions).
    ///
    /// If set to `true` AppLovin messages will appear in the standard application log which is accessible via the console. All AppLovin log messages are prefixed with the `/AppLovinSdk: [AppLovinSdk]` tag.
    ///
    /// Verbose logging is *disabled* (`false`) by default.
    public var isVerboseLoggingEnabled: Bool {  /* ... */ }
    
    /// Whether to begin video ads in a muted state or not. Defaults to `false` unless you change this in the dashboard.
    public var isMuted: Bool { /* ... */ }
    
    /// Whether the Creative Debugger will be displayed after flipping the device screen down twice. Defaults to `true`.
    public var isCreativeDebuggerEnabled: Bool { /* ... */ }
    
    /// An identifier for the current user. This identifier will be tied to SDK events and AppLovin's optional S2S postbacks.
    ///
    /// If you use reward validation, you can optionally set an identifier that AppLovin will include with its currency validation postbacks (for example, a username or email address). AppLovin will include this in the postback when AppLovin pings your currency endpoint from our server.
    public var userIdentifier: String? { /* ... */ }
    
    /// Set an extra parameter to pass to the AppLovin server.
    ///
    /// - Parameters:
    ///   - key: Parameter key. Must not be nil.
    ///   - value: Parameter value. May be nil.
    public func setExtraParameter(forKey key: String, value: String?) {  /* ... */ }
}
```

You can access `ALSdkSettings` like this: 

```swift
let settings: ALSdkSettings = SkipAppLovin.current.settings
SkipAppLovin.current.settings.isVerboseLoggingEnabled = true
let result = await SkipAppLovin.current.initialize(sdkKey: YOUR_SDK_KEY)
```

You can mutate the current settings at any time, e.g. to mute or unmute ads.

## Banner Ads and MRECs

AppLovin is implemented against UIKit. Their documentation for SwiftUI recommends rolling your own `UIViewRepresentable`. That's what we've done in `SkipAppLovinAdView.swift`.

You can use it like this:

```swift
import SkipAppLovin

SkipAppLovinAdView(bannerAdUnitIdentifier: "YOUR_AD_UNIT_ID", adFormat: .banner) // 320x50
SkipAppLovinAdView(bannerAdUnitIdentifier: "YOUR_AD_UNIT_ID", adFormat: .leader) // 728x90
SkipAppLovinAdView(bannerAdUnitIdentifier: "YOUR_AD_UNIT_ID", adFormat: .mrec) // 300x250
```

You can also use a "flexible" banner, which automatically switches between `.banner` and `.leader` based on available width.

```swift
SkipAppLovinFlexibleBannerAdView(bannerAdUnitIdentifier: "YOUR_AD_UNIT_ID")
```

There are many optional parameters available.

```swift
public struct SkipAppLovinAdView: View {
    /// Creates a banner/leader/MREC ad view for a given ad unit ID
    ///
    /// - Parameters:
    ///   - bannerAdUnitIdentifier: Ad unit ID to load ads for.
    ///   - adFormat: Ad format to load ads for: banner, leader, or mrec.
    ///   - configuration: Configuration object for customizing the ad view's properties. See MAAdViewConfiguration for more details.
    ///   - placement: The placement name that you assign when you integrate each ad format, for granular reporting in ad events (e.g. "Rewarded_Store", "Rewarded_LevelEnd").
    ///   - delegate: A delegate that will be notified about ad events.
    ///   - revenueDelegate: A delegate that will be notified about ad revenue events (`didPayRevenueForAd`).
    ///   - requestDelegate: A delegate that will be notified about ad request events (`didStartAdRequest`).
    ///   - adReviewDelegate: A delegate that will be notified about Ad Review events (`didGenerateCreativeIdentifier`).
    ///   - extraParameters: Extra parameter key/value pairs for the ad.
    ///   - localExtraParameters: Local extra parameters to pass to the adapter instances.
    ///   - customData: The custom data to tie the showing ad to, for ILRD and rewarded postbacks via the {CUSTOM_DATA} macro. Maximum size is 8KB.
    public init(
        bannerAdUnitIdentifier: String,
        adFormat: MAAdFormat,
        configuration: MAAdViewConfiguration? = nil,
        placement: String? = nil,
        delegate: MAAdViewAdDelegate? = nil,
        revenueDelegate: MAAdRevenueDelegate? = nil,
        requestDelegate: MAAdRequestDelegate? = nil,
        adReviewDelegate: MAAdReviewDelegate? = nil,
        extraParameters: [String: String] = [:],
        localExtraParameters: [String: Any?] = [:],
        customData: String? = nil,
    ) { /* ... */ }
}
```

## Fullscreen ads

Fullscreen ads prevent the user from interacting with the app until the ad goes away. For example, users might have to watch a video (or at least part of a video) and then tap "skip".

AppLovin offers three kinds of fullscreen ads:

* Interstitial: You call `load()`; eventually an ad is loaded. After it's ready, you call `show()`.
* App Open: The API for this looks the same as plain Interstitial ads, but when they load, AppLovin stores the ad on disk. As a result, during app launch, you can check whether an ad is ready and show it at launch.
* Rewarded: Basically the same API as Interstitial, but the actual ad units differ, and you get a `didRewardUser(for: MAAd, reward: MAReward)` event to give users an amount of virtual currency. Rewarded ads generally require some real user interaction, not just waiting and tapping "skip."

The API is basically the same in all three cases:

```swift
import SkipAppLovin
#if canImport(AppLovinSDK)
import AppLovinSDK
#endif

let interstitialAd = MAInterstitialAd(adUnitIdentifier: "YOUR_AD_UNIT_ID")
interstitialAd.load()
// ... later ...
if interstitialAd.ready {
    interstitialAd.show()
}

let appOpenAd = MAAppOpenAd(adUnitIdentifier: "YOUR_AD_UNIT_ID")
appOpenAd.load()
// ... later ...
appOpenAd.show()

let rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "YOUR_REWARDED_AD_UNIT_ID")
rewardedAd.load()
// ... later ...
rewardedAd.show()
```

You can set delegates on a fullscreen ad to be notified of events, especially `didLoad`.

```swift
ad.delegate = myAdDelegate // MAAdDelegate, or MARewardedAdDelegate for rewarded ads
    // the didLoad event lets you know when an ad is ready to show

ad.revenueDelegate = myAdDelegate // `didPayRevenueForAd`
ad.requestDelegate = myAdDelegate // `didStartAdRequest`
ad.adReviewDelegate = myAdDelegate // `didGenerateCreativeIdentifier`
ad.expirationDelegate = myAdDelegate // `didReloadExpiredAd`
```

There are a few other methods available on fullscreen ads:

```swift
/// Show the loaded ad.
///
/// - Use delegate to assign a delegate that should be
///   notified about display events.
/// - Use isReady to check if an ad was successfully
///   loaded.
///
/// - Parameters:
///   - placement: The placement to tie the showing ad's
///     events to.
///   - customData: The custom data to tie the showing
///     ad's events to. Maximum size is 8KB.
public func show(
    forPlacement placement: String? = nil,
    customData: String? = nil
) { /* ... */ }


/// Whether or not this ad is ready to be shown.
public var isReady: Bool { /* ... */ }

/// Sets an extra key/value parameter for the ad.
///
/// - Parameters:
///   - key: Parameter key.
///   - value: Parameter value.
public func setExtraParameter(
    forKey key: String,
    value: String?
) { /* ... */ }

/// Set a local extra parameter to pass to the adapter
/// instances. Will not be available in the adapter's
/// initialization method.
///
/// - Parameters:
///   - key: Parameter key. Must not be null.
///   - value: Parameter value. May be null.
public func setLocalExtraParameter(
    forKey key: String,
    value: Any?
) { /* ... */ }
```

## Debuggers

The SDK allows you to run two "debuggers," the "mediation debugger" and the "creative debugger." They each pop up a sheet with troubleshooting information.

You can call them like this:

```swift
import SkipAppLovin

Button("Mediation Debugger") {
    SkipAppLovin.current.showMediationDebugger()
}
Button("Creative Debugger") {
    SkipAppLovin.current.showCreativeDebugger()
}
```

## TODO Native Ads

No support for native ads yet.

## Building

This project is a free Swift Package Manager module that uses the
[Skip](https://skip.tools) plugin to transpile Swift into Kotlin.

Building the module requires that Skip be installed using
[Homebrew](https://brew.sh) with `brew install skiptools/skip/skip`.
This will also install the necessary build prerequisites:
Kotlin, Gradle, and the Android build tools.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.

## License

This software is licensed under the
[GNU Lesser General Public License v3.0](https://spdx.org/licenses/LGPL-3.0-only.html),
with a [linking exception](https://spdx.org/licenses/LGPL-3.0-linking-exception.html)
to clarify that distribution to restricted environments (e.g., app stores) is permitted.
