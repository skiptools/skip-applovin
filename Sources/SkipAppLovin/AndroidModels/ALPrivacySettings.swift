// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import com.applovin.sdk.AppLovinPrivacySettings

/// This class contains privacy settings for AppLovin.
public struct ALPrivacySettings {
    /// Sets whether or not the user has provided consent for information-sharing with AppLovin.
    ///
    /// - Parameter hasUserConsent: `true` if the user provided consent for information-sharing with AppLovin. `false` by default.
    public static func setHasUserConsent(_ hasUserConsent: Bool) {
        AppLovinPrivacySettings.setHasUserConsent(hasUserConsent)
    }
    
    /// Checks if the user has provided consent for information-sharing with AppLovin.
    ///
    /// - Returns: `true` if the user provided consent for information sharing. `false` if the user declined to share information or the consent value has not been set (see `isUserConsentSet`).
    public static func hasUserConsent() -> Bool {
        AppLovinPrivacySettings.hasUserConsent()
    }
    
    /// Checks if user has set consent for information sharing.
    ///
    /// - Returns: `true` if user has set a value of consent for information sharing.
    public static func isUserConsentSet() -> Bool {
        AppLovinPrivacySettings.isUserConsentSet()
    }
    
    /// Sets whether or not the user has opted out of the sale of their personal information.
    ///
    /// - Parameter doNotSell: `true` if the user opted out of the sale of their personal information.
    public static func setDoNotSell(_ doNotSell: Bool) {
        AppLovinPrivacySettings.setDoNotSell(doNotSell)
    }
    
    /// Checks if the user has opted out of the sale of their personal information.
    ///
    /// - Returns: `true` if the user opted out of the sale of their personal information. `false` if the user opted in to the sale of their personal information or the value has not been set (see `isDoNotSellSet`).
    public static func isDoNotSell() -> Bool {
        AppLovinPrivacySettings.isDoNotSell()
    }
    
    /// Checks if the user has set the option to sell their personal information.
    ///
    /// - Returns: `true` if user has chosen an option to sell their personal information.
    public static func isDoNotSellSet() -> Bool {
        AppLovinPrivacySettings.isDoNotSellSet()
    }
    
    /// Parses the IABTCF_VendorConsents string to determine the consent status of the IAB vendor with the provided ID.
    ///
    /// - Parameter vendorIdentifier: Vendor ID as defined in the Global Vendor List.
    /// - Returns: `1` if the vendor has consent, `0` if not, or `nil` if TC data is not available on disk.
    public static func tcfVendorConsentStatus(forIdentifier vendorIdentifier: Int) -> Int? {
        guard let status = AppLovinPrivacySettings.getTcfVendorConsentStatus(vendorIdentifier) else {
            let result: Int? = nil
            return result
        }
        return status ? 1 : 0
    }
    
    /// Parses the IABTCF_AddtlConsent string to determine the consent status of the advertising entity with the provided Ad Technology Provider (ATP) ID.
    ///
    /// - Parameter atpIdentifier: ATP ID of the advertising entity (e.g. 89 for Meta Audience Network).
    /// - Returns: `1` if the advertising entity has consent, `0` if not, or `nil` if no AC string is available on disk or the ATP network was not listed in the CMP flow.
    public static func additionalConsentStatus(forIdentifier atpIdentifier: Int) -> Int? {
        guard let status = AppLovinPrivacySettings.getAdditionalConsentStatus(atpIdentifier) else {
            let result: Int? = nil
            return result
        }
        return status ? 1 : 0
    }
    
    /// Parses the IABTCF_PurposeConsents String to determine the consent status of the IAB defined data processing purpose.
    ///
    /// - Parameter purposeIdentifier: Purpose ID.
    /// - Returns: `1` if the purpose has consent, `0` if not, or `nil` if TC data is not available on disk.
    public static func purposeConsentStatus(forIdentifier purposeIdentifier: Int) -> Int? {
        guard let status = AppLovinPrivacySettings.getPurposeConsentStatus(purposeIdentifier) else {
            let result: Int? = nil
            return result
        }
        return status ? 1 : 0
    }
    
    /// Parses the IABTCF_SpecialFeaturesOptIns String to determine the opt-in status of the IAB defined special feature.
    ///
    /// - Parameter specialFeatureIdentifier: Special feature ID.
    /// - Returns: `1` if the user opted in for the special feature, `0` if not, or `nil` if TC data is not available on disk.
    public static func specialFeatureOptInStatus(forIdentifier specialFeatureIdentifier: Int) -> Int? {
        guard let status = AppLovinPrivacySettings.getSpecialFeatureOptInStatus(specialFeatureIdentifier) else {
            let result: Int? = nil
            return result
        }
        return status ? 1 : 0
    }
}
#endif
#endif
