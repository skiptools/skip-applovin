// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
import SwiftUI
import OSLog

#if SKIP
import com.applovin.sdk.AppLovinSdk
import com.applovin.sdk.AppLovinSdkInitializationConfiguration
import androidx.compose.ui.platform.LocalContext
#elseif canImport(AppLovinSDK)
import AppLovinSDK
#endif

#if SKIP || canImport(AppLovinSDK)
public struct SkipAppLovin: @unchecked Sendable {
    public static let current = SkipAppLovin()
    #if SKIP
    let sdk: AppLovinSdk
    init() {
        sdk = AppLovinSdk.getInstance(ProcessInfo.processInfo.androidContext)
    }
    #else
    let sdk: ALSdk
    init() {
        sdk = ALSdk.shared()
    }
    #endif
    
    
    
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
        #if SKIP
        let builder: AppLovinSdkInitializationConfiguration.Builder
        if let axonEventKey {
            builder = AppLovinSdkInitializationConfiguration.builder(sdkKey, axonEventKey)
        } else {
            builder = AppLovinSdkInitializationConfiguration.builder(sdkKey)
        }
        builder.setMediationProvider(mediationProvider)
        if let pluginVersion {
            builder.setPluginVersion(pluginVersion)
        }
        if let segmentCollection {
            builder.setSegmentCollection(segmentCollection.maxSegmentCollection)
        }
        if let testDeviceAdvertisingIdentifiers {
            builder.setTestDeviceAdvertisingIds(testDeviceAdvertisingIdentifiers.toList())
        }
        if let adUnitIdentifiers {
            builder.setAdUnitIds(adUnitIdentifiers.toList())
        }
        if let exceptionHandlerEnabled {
            builder.setExceptionHandlerEnabled(exceptionHandlerEnabled)
        }
        let sdkConfig = await withCheckedContinuation { continuation in
            sdk.initialize(builder.build()) { sdkConfig in
                continuation.resume(returning: sdkConfig)
            }
        }
        return ALSdkConfiguration(sdkConfig)
        #else
        let initConfig: ALSdkInitializationConfiguration
        if let axonEventKey {
            initConfig = ALSdkInitializationConfiguration(sdkKey: sdkKey, axonEventKey: axonEventKey) { builder in
                builder.mediationProvider = mediationProvider
                if let pluginVersion {
                    builder.pluginVersion = pluginVersion
                }
                if let segmentCollection {
                    builder.segmentCollection = segmentCollection
                }
                if let testDeviceAdvertisingIdentifiers {
                    builder.testDeviceAdvertisingIdentifiers = testDeviceAdvertisingIdentifiers
                }
                if let adUnitIdentifiers {
                    builder.adUnitIdentifiers = adUnitIdentifiers
                }
                if let exceptionHandlerEnabled {
                    builder.exceptionHandlerEnabled = exceptionHandlerEnabled
                }
            }
        } else {
            initConfig = ALSdkInitializationConfiguration(sdkKey: sdkKey) { builder in
                builder.mediationProvider = mediationProvider
                if let pluginVersion {
                    builder.pluginVersion = pluginVersion
                }
                if let segmentCollection {
                    builder.segmentCollection = segmentCollection
                }
                if let testDeviceAdvertisingIdentifiers {
                    builder.testDeviceAdvertisingIdentifiers = testDeviceAdvertisingIdentifiers
                }
                if let adUnitIdentifiers {
                    builder.adUnitIdentifiers = adUnitIdentifiers
                }
                if let exceptionHandlerEnabled {
                    builder.exceptionHandlerEnabled = exceptionHandlerEnabled
                }
            }
        }
        let sdkConfig = await sdk.initialize(with: initConfig)
        return sdkConfig
        #endif
    }
    
    public func showMediationDebugger() {
        sdk.showMediationDebugger()
    }
    
    public func showCreativeDebugger() {
        sdk.showCreativeDebugger()
    }
    
    public var settings: ALSdkSettings {
        #if SKIP
        ALSdkSettings(AppLovinSdk.getInstance( UIApplication.shared.androidActivity ).getSettings())
        #else
        ALSdk.shared().settings
        #endif
    }
}

#endif
#endif
