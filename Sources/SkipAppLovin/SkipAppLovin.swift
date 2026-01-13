// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
import Foundation
import OSLog

#if SKIP
// SKIP @bridge
class MASegment {
    /// The key of the segment. Must be a non-negative number
    /// in the range of [0, 32000].
    let key: Int
    
    /// The value(s) associated with the key. Each value must be
    /// a non-negative number in the range of [0, 32000].
    let values: [Int]
    
    /// Initializes a new MASegment with the specified key
    /// and value(s).
    ///
    /// - Parameters:
    ///   - key: The key of the segment. Must be a non-negative
    ///     number in the range of [0, 32000].
    ///   - values: The value(s) associated with the key. Each
    ///     value must be a non-negative number in the range of
    ///     [0, 32000].
    init(key: Int, values: [Int]) {
        self.key = key
        self.values = values
    }
}

// SKIP @bridge
class MASegmentCollection {
    /// An array of MASegment objects.
    let segments: [MASegment]
    
    internal init(segments: [MASegment]) {
        self.segments = segments
    }
    
    /// Creates a MASegmentCollection object from the builder
    /// in the builderBlock.
    ///
    /// - Parameter builderBlock: A closure that configures
    ///   the builder.
    /// - Returns: A MASegmentCollection object.
    static func segmentCollection(
        withBuilderBlock builderBlock: (
            MASegmentCollectionBuilder
        ) -> Void
    ) -> MASegmentCollection {
        let builder = MASegmentCollectionBuilder()
        builderBlock(builder)
        return builder.build()
    }
    
    /// Creates a builder object for MASegmentCollection.
    ///
    /// - Returns: A MASegmentCollectionBuilder object.
    static func builder() -> MASegmentCollectionBuilder {
        return MASegmentCollectionBuilder()
    }
}

/// Builder class used to create a MASegmentCollection object.
class MASegmentCollectionBuilder {
    private var segments: [MASegment] = []
    
    /// Adds a MASegment to the collection.
    ///
    /// - Parameter segment: The MASegment to add.
    func addSegment(_ segment: MASegment) {
        segments.append(segment)
    }
    
    /// Builds a MASegmentCollection object from the builder
    /// properties' values.
    ///
    /// - Returns: A MASegmentCollection object.
    func build() -> MASegmentCollection {
        return MASegmentCollection(segments: segments)
    }
}


// MARK: - ALSdkInitializationConfiguration

struct ALSdkInitializationConfiguration {
    let sdkKey: String
    let axonEventKey: String?
    let mediationProvider: String?
    let pluginVersion: String?
    let segmentCollection: MASegmentCollection?
    let testDeviceAdvertisingIdentifiers: [String]?
    let adUnitIdentifiers: [String]?
    let isExceptionHandlerEnabled: Bool
    
    init(
        sdkKey: String,
        axonEventKey: String? = nil,
        mediationProvider: String? = nil,
        pluginVersion: String? = nil,
        segmentCollection: MASegmentCollection? = nil,
        testDeviceAdvertisingIdentifiers: [String]? = nil,
        adUnitIdentifiers: [String]? = nil,
        isExceptionHandlerEnabled: Bool
    ) {
        self.sdkKey = sdkKey
        self.axonEventKey = axonEventKey
        self.mediationProvider = mediationProvider
        self.pluginVersion = pluginVersion
        self.segmentCollection = segmentCollection
        self.testDeviceAdvertisingIdentifiers = testDeviceAdvertisingIdentifiers
        self.adUnitIdentifiers = adUnitIdentifiers
        self.isExceptionHandlerEnabled = isExceptionHandlerEnabled
    }
    
    // MARK: - Initialization
    
    static func configuration(
        withSdkKey sdkKey: String
    ) -> ALSdkInitializationConfiguration {
        return ALSdkInitializationConfiguration(
            sdkKey: sdkKey,
            axonEventKey: nil,
            mediationProvider: nil,
            pluginVersion: nil,
            segmentCollection: nil,
            testDeviceAdvertisingIdentifiers: [],
            adUnitIdentifiers: [],
            isExceptionHandlerEnabled: true
        )
    }
    
    static func configuration(
        withSdkKey sdkKey: String,
        axonEventKey: String? = nil,
        builderBlock: (
            (ALSdkInitializationConfigurationBuilder) -> Void
        )?
    ) -> ALSdkInitializationConfiguration {
        let builder = ALSdkInitializationConfigurationBuilder(
            sdkKey: sdkKey,
            axonEventKey: axonEventKey
        )
        builderBlock?(builder)
        return builder.build()
    }
    
    static func builder(
        withSdkKey sdkKey: String,
        axonEventKey: String? = nil
    ) -> ALSdkInitializationConfigurationBuilder {
        return ALSdkInitializationConfigurationBuilder(
            sdkKey: sdkKey,
            axonEventKey: axonEventKey
        )
    }
}

// MARK: - ALSdkInitializationConfigurationBuilder

class ALSdkInitializationConfigurationBuilder {
    let sdkKey: String
    let axonEventKey: String?
    var mediationProvider: String?
    var pluginVersion: String?
    var segmentCollection: MASegmentCollection?
    var testDeviceAdvertisingIdentifiers: [String] = []
    var adUnitIdentifiers: [String] = []
    var isExceptionHandlerEnabled: Bool = true
    
    init(
        sdkKey: String,
        axonEventKey: String? = nil
    ) {
        self.sdkKey = sdkKey
        self.axonEventKey = axonEventKey
    }
    
    // MARK: - Build
    
    func build() -> ALSdkInitializationConfiguration {
        return ALSdkInitializationConfiguration(
            sdkKey: sdkKey,
            axonEventKey: axonEventKey,
            mediationProvider: mediationProvider,
            pluginVersion: pluginVersion,
            segmentCollection: segmentCollection,
            testDeviceAdvertisingIdentifiers: (
                testDeviceAdvertisingIdentifiers
            ),
            adUnitIdentifiers: adUnitIdentifiers,
            isExceptionHandlerEnabled: isExceptionHandlerEnabled
        )
    }
}

// SKIP @bridge
class ALSdkConfiguration {
    /// This enum represents the user's geography used to
    /// determine the type of consent flow shown to the user.
    enum ConsentFlowUserGeography: Int {
        /// User's geography is unknown.
        case unknown
        
        /// The user is in GDPR region.
        case gdpr
        
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
    
    private init(
        consentFlowUserGeography: ConsentFlowUserGeography,
        countryCode: String,
        enabledAmazonAdUnitIdentifiers: [String]?,
        appTrackingTransparencyStatus:
            AppTrackingTransparencyStatus,
        isTestModeEnabled: Bool
    ) {
        self.consentFlowUserGeography =
            consentFlowUserGeography
        self.countryCode = countryCode
        self.enabledAmazonAdUnitIdentifiers =
            enabledAmazonAdUnitIdentifiers
        self.appTrackingTransparencyStatus =
            appTrackingTransparencyStatus
        self.isTestModeEnabled = isTestModeEnabled
    }
}

@available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
enum ALConsentDialogState: Int {
    case unknown
    case applies
    case doesNotApply
}

extension ALSdkConfiguration {
    @available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
    var consentDialogState: ALConsentDialogState {
        return .unknown
    }
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
    
    internal init(
        consentFlowUserGeography: ALConsentFlowUserGeography,
        countryCode: String,
        enabledAmazonAdUnitIdentifiers: [String]?,
        appTrackingTransparencyStatus:
            ALAppTrackingTransparencyStatus,
        isTestModeEnabled: Bool
    ) {
        switch consentFlowUserGeography {
        case .unknown:
            self.consentFlowUserGeography = .unknown
        case .GDPR:
            self.consentFlowUserGeography = .GDPR
        case .other:
            self.consentFlowUserGeography = .other
        @unknown default:
            fatalError()
        }
        self.countryCode = countryCode
        self.enabledAmazonAdUnitIdentifiers =
            enabledAmazonAdUnitIdentifiers
        switch appTrackingTransparencyStatus {
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
        self.isTestModeEnabled = isTestModeEnabled
    }
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
        fatalError()
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
        return SkipALSdkConfiguration(
            consentFlowUserGeography: sdkConfig.consentFlowUserGeography,
            countryCode: sdkConfig.countryCode,
            enabledAmazonAdUnitIdentifiers: sdkConfig.enabledAmazonAdUnitIdentifiers,
            appTrackingTransparencyStatus: sdkConfig.appTrackingTransparencyStatus,
            isTestModeEnabled: sdkConfig.isTestModeEnabled
        )
        #endif
    }
}

#endif
