// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.sdk.AppLovinSdkConfiguration

/// This enum represents the user's geography used to
/// determine the type of consent flow shown to the user.
public enum ALConsentFlowUserGeography: Int {
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
public enum ALAppTrackingTransparencyStatus: Int {
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

/// This class contains various properties of the AppLovin SDK configuration.
public final class ALSdkConfiguration: CustomStringConvertible, @unchecked Sendable {
    private let sdkConfig: AppLovinSdkConfiguration
    
    internal init(_ sdkConfig: AppLovinSdkConfiguration) {
        self.sdkConfig = sdkConfig
    }
    
    /// Get the user's geography used to determine the type of
    /// consent flow shown to the user.
    /// If no such determination could be made,
    /// ALConsentFlowUserGeography.unknown will be returned.
    public var consentFlowUserGeography: ALConsentFlowUserGeography {
        let geography = sdkConfig.getConsentFlowUserGeography()
        switch geography {
        case AppLovinSdkConfiguration.ConsentFlowUserGeography.UNKNOWN:
            return .unknown
        case AppLovinSdkConfiguration.ConsentFlowUserGeography.GDPR:
            return .GDPR
        case AppLovinSdkConfiguration.ConsentFlowUserGeography.OTHER:
            return .other
        default:
            return .unknown
        }
    }
    
    /// Gets the country code for this user. The value of this
    /// property will be an empty string if no country code is
    /// available for this user.
    ///
    /// - Warning: Do not confuse this with the currency code
    ///   which is "USD" in most cases.
    public var countryCode: String {
        sdkConfig.getCountryCode()
    }
    
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
    public var enabledAmazonAdUnitIdentifiers: [String]? {
        if let identifiers = sdkConfig.getEnabledAmazonAdUnitIds() {
            return Array(identifiers)
        }
        return nil
    }
    
    /// Indicates whether or not the user authorizes access to
    /// app-related data that can be used for tracking the user
    /// or the device.
    ///
    /// - Warning: Users can revoke permission at any time
    ///   through the "Allow Apps To Request To Track" privacy
    ///   setting on the device.
    public var appTrackingTransparencyStatus: ALAppTrackingTransparencyStatus {
        // Android doesn't have ATT, so always return unavailable
        return .unavailable
    }
    
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
    public var isTestModeEnabled: Bool {
        sdkConfig.isTestModeEnabled()
    }
    
    @available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
    public var consentDialogState: ALConsentDialogState {
        return .unknown
    }
    
    public var description: String {
        "ALSdkConfiguration testMode=\(isTestModeEnabled)"
    }
}

@available(*, deprecated, message: "This API has been deprecated and will be removed in a future release.")
public enum ALConsentDialogState: Int {
    case unknown
    case applies
    case doesNotApply
}

#endif
#endif
