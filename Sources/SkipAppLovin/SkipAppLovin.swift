// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
import Foundation
import OSLog

#if SKIP
import com.applovin.sdk.AppLovinSdk
import com.applovin.sdk.AppLovinSdkConfiguration
import com.applovin.sdk.AppLovinSdkInitializationConfiguration
import androidx.compose.ui.platform.LocalContext

@available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
enum ALConsentDialogState: Int {
    case unknown
    case applies
    case doesNotApply
}


#else
import AppLovinSDK
#endif

// SKIP @bridge
public struct SkipALSdkConfiguration: Sendable {
    /// This enum represents the user's geography used to
    /// determine the type of consent flow shown to the user.
    enum ConsentFlowUserGeography: Int {
        /// User's geography is unknown.
        case unknown
        
        /// The user is in GDPR region.
        case GDPR
        
        /// The user is in a non-GDPR region.
        case other
    }
    
    /// AppLovin SDK-defined app tracking transparency status
    /// values (extended to include "unavailable" state on iOS
    /// before iOS14).
    enum AppTrackingTransparencyStatus: Int {
        /// Device is on iOS before iOS14,
        /// AppTrackingTransparency.framework is not available.
        case unavailable = -1
        
        /// The user has not yet received an authorization
        /// request to authorize access to app-related data that
        /// can be used for tracking the user or the device.
        case notDetermined
        
        /// Authorization to access app-related data that can be
        /// used for tracking the user or the device is
        /// restricted.
        case restricted
        
        /// The user denies authorization to access app-related
        /// data that can be used for tracking the user or the
        /// device.
        case denied
        
        /// The user authorizes access to app-related data that
        /// can be used for tracking the user or the device.
        case authorized
    }
    
    /// Get the user's geography used to determine the type of
    /// consent flow shown to the user.
    /// If no such determination could be made,
    /// ConsentFlowUserGeography.unknown will be returned.
    let consentFlowUserGeography: ConsentFlowUserGeography
    
    /// Gets the country code for this user. The value of this
    /// property will be an empty string if no country code is
    /// available for this user.
    ///
    /// - Warning: Do not confuse this with the currency code
    ///   which is "USD" in most cases.
    let countryCode: String
    
    /// Get the list of those Ad Unit IDs that are in the
    /// waterfall that is currently active for a particular user
    /// and for which Amazon Publisher Services is enabled.
    ///
    /// Which waterfall is currently active for a user depends
    /// on things like A/B tests, keyword targeting, or DNT.
    ///
    /// - Returns: `nil` when configuration fetching fails
    ///   (e.g. in the case of no connection) or an empty array
    ///   if no Ad Unit IDs have Amazon Publisher Services
    ///   enabled.
    let enabledAmazonAdUnitIdentifiers: [String]?
    
    /// Indicates whether or not the user authorizes access to
    /// app-related data that can be used for tracking the user
    /// or the device.
    ///
    /// - Warning: Users can revoke permission at any time
    ///   through the "Allow Apps To Request To Track" privacy
    ///   setting on the device.
    let appTrackingTransparencyStatus:
        AppTrackingTransparencyStatus
    
    /// Whether or not test mode is enabled for this session.
    ///
    /// Returns `true` in one of the following cases:
    /// - ALSdkInitializationConfiguration.
    ///   testDeviceAdvertisingIdentifiers was set with current
    ///   device's IDFA prior to SDK initialization.
    /// - Current device was registered as a test device
    ///   through MAX dashboard -> MAX Test Devices prior to
    ///   SDK initialization.
    /// - Test mode was manually enabled for this session
    ///   through the Mediation Debugger during the last
    ///   session.
    /// - Current device is a simulator.
    let isTestModeEnabled: Bool
    
    @available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
    var consentDialogState: ALConsentDialogState {
        return .unknown
    }
    
    #if SKIP
    internal init(_ sdkConfig: AppLovinSdkConfiguration) {
        let consentFlowUserGeography: AppLovinSdkConfiguration.ConsentFlowUserGeography = sdkConfig.getConsentFlowUserGeography()
        switch consentFlowUserGeography {
        case .UNKNOWN:
            self.consentFlowUserGeography = .unknown
        case .GDPR:
            self.consentFlowUserGeography = .GDPR
        case .OTHER:
            self.consentFlowUserGeography = .other
        }
        self.countryCode = sdkConfig.getCountryCode()
        if let enabledAmazonAdUnitIdentifiers = sdkConfig.getEnabledAmazonAdUnitIds() {
            self.enabledAmazonAdUnitIdentifiers = Array(enabledAmazonAdUnitIdentifiers)
        } else {
            self.enabledAmazonAdUnitIdentifiers = nil
        }
        self.appTrackingTransparencyStatus = .unavailable
        self.isTestModeEnabled = sdkConfig.isTestModeEnabled()
    }
    #else
    internal init(_ sdkConfig: ALSdkConfiguration) {
        switch sdkConfig.consentFlowUserGeography {
        case .unknown:
            self.consentFlowUserGeography = .unknown
        case .GDPR:
            self.consentFlowUserGeography = .GDPR
        case .other:
            self.consentFlowUserGeography = .other
        @unknown default:
            fatalError()
        }
        self.countryCode = sdkConfig.countryCode
        self.enabledAmazonAdUnitIdentifiers = sdkConfig.enabledAmazonAdUnitIdentifiers
        switch sdkConfig.appTrackingTransparencyStatus {
        case .unavailable:
            self.appTrackingTransparencyStatus = .unavailable
        case .notDetermined:
            self.appTrackingTransparencyStatus = .notDetermined
        case .restricted:
            self.appTrackingTransparencyStatus = .restricted
        case .denied:
            self.appTrackingTransparencyStatus = .denied
        case .authorized:
            self.appTrackingTransparencyStatus = .authorized
        @unknown default:
            fatalError()
        }
        self.isTestModeEnabled = sdkConfig.isTestModeEnabled
    }
    
    #endif
}


public struct SkipAppLovin: @unchecked Sendable {
    public static let current = SkipAppLovin()
    
    public func initialize(
        sdkKey: String,
        axonEventKey: String? = nil,
        mediationProvider: String? = nil,
        pluginVersion: String? = nil,
        segmentCollection: MASegmentCollection? = nil,
        testDeviceAdvertisingIdentifiers: [String]? = nil,
        adUnitIdentifiers: [String]? = nil,
        exceptionHandlerEnabled: Bool? = nil
    ) async -> SkipALSdkConfiguration {
        #if SKIP
        let builder = AppLovinSdkInitializationConfiguration.builder(sdkKey)
        guard axonEventKey == nil else {
            fatalError("axonEventKey not supported in SkipAppLovin")
        }
        if let mediationProvider {
            builder.setMediationProvider(mediationProvider)
        }
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
            AppLovinSdk.getInstance(ProcessInfo.processInfo.androidContext).initialize(builder.build()) { sdkConfig in
                continuation.resume(returning: sdkConfig)
            }
        }
        return SkipALSdkConfiguration(sdkConfig)
        #else
        let initConfig: ALSdkInitializationConfiguration
        if let axonEventKey {
            initConfig = ALSdkInitializationConfiguration(sdkKey: sdkKey, axonEventKey: axonEventKey) { builder in
                if let mediationProvider {
                    builder.mediationProvider = mediationProvider
                }
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
                if let mediationProvider {
                    builder.mediationProvider = mediationProvider
                }
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
        let sdkConfig = await ALSdk.shared().initialize(with: initConfig)
        return SkipALSdkConfiguration(sdkConfig)
        #endif
    }
}

#endif
