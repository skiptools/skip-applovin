// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.sdk.AppLovinSdkSettings
import com.applovin.sdk.AppLovinTermsAndPrivacyPolicyFlowSettings
import com.applovin.sdk.AppLovinSdkConfiguration
import android.net.Uri

// MARK: - ALTermsAndPrivacyPolicyFlowSettings

/// This interface contains settings that enable the MAX Terms and Privacy Policy Flow.
public class ALTermsAndPrivacyPolicyFlowSettings {
    private let settings: AppLovinTermsAndPrivacyPolicyFlowSettings
    
    internal init(_ settings: AppLovinTermsAndPrivacyPolicyFlowSettings) {
        self.settings = settings
    }
    
    /// Set this to `true` to enable the Terms Flow. You must also provide your privacy policy and terms of service URLs in this object, and you must provide a `NSUserTrackingUsageDescription` string in your `Info.plist` file.
    ///
    /// This defaults to the value that you entered into your `Info.plist` file via `AppLovinConsentFlowInfo` ⇒ `AppLovinConsentFlowEnabled`.
    public var isEnabled: Bool {
        get {
            settings.isEnabled()
        }
        set {
            settings.setEnabled(newValue)
        }
    }
    
    /// URL for your company's privacy policy. This is required in order to enable the Terms Flow.
    ///
    /// This defaults to the value that you entered into your `Info.plist` file via `AppLovinConsentFlowInfo` ⇒ `AppLovinConsentFlowPrivacyPolicy`.
    public var privacyPolicyURL: URL? {
        get {
            if let uri = settings.getPrivacyPolicyUri() {
                return URL(string: uri.toString())
            }
            return nil
        }
        set {
            if let url = newValue, let uri = Uri.parse(url.absoluteString) {
                settings.setPrivacyPolicyUri(uri)
            } else {
                settings.setPrivacyPolicyUri(nil)
            }
        }
    }
    
    /// URL for your company's terms of service. This is optional; you can enable the Terms Flow with or without it.
    ///
    /// This defaults to the value that you entered into your `Info.plist` file via `AppLovinConsentFlowInfo` ⇒ `AppLovinConsentFlowTermsOfService`.
    public var termsOfServiceURL: URL? {
        get {
            if let uri = settings.getTermsOfServiceUri() {
                return URL(string: uri.toString())
            }
            return nil
        }
        set {
            if let url = newValue, let uri = Uri.parse(url.absoluteString) {
                settings.setTermsOfServiceUri(uri)
            } else {
                settings.setTermsOfServiceUri(nil)
            }
        }
    }
    
    /// Set this to `true` to show the Terms and Privacy Policy alert in GDPR regions prior to presenting the CMP prompt. The alert will show in non-GDPR regions regardless of this setting.
    ///
    /// This defaults to `false`.
    public var shouldShowTermsAndPrivacyPolicyAlertInGDPR: Bool {
        get {
            settings.shouldShowTermsAndPrivacyPolicyAlertInGdpr()
        }
        set {
            settings.setShowTermsAndPrivacyPolicyAlertInGdpr(newValue)
        }
    }
    
    /// Set debug user geography. You may use this to test CMP flow by setting this to `.GDPR`.
    ///
    /// The flow would only be shown to new users. If you wish to test the flow after completing the CMP prompt, you would need to delete and re-install the app.
    ///
    /// NOTE: The debug geography is used only when the app is in debug mode.
    public var debugUserGeography: ALConsentFlowUserGeography {
        get {
            let geography = settings.getDebugUserGeography()
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
        set {
            let geography: AppLovinSdkConfiguration.ConsentFlowUserGeography
            switch newValue {
            case .unknown:
                geography = AppLovinSdkConfiguration.ConsentFlowUserGeography.UNKNOWN
            case .GDPR:
                geography = AppLovinSdkConfiguration.ConsentFlowUserGeography.GDPR
            case .other:
                geography = AppLovinSdkConfiguration.ConsentFlowUserGeography.OTHER
            }
            settings.setDebugUserGeography(geography)
        }
    }
}

// MARK: - ALSdkSettings

/// This class contains mutable settings for the AppLovin SDK.
public class ALSdkSettings {
    private let settings: AppLovinSdkSettings
    
    internal init(_ settings: AppLovinSdkSettings) {
        self.settings = settings
    }
    
    /// Settings relating to the MAX Terms and Privacy Policy Flow.
    public var termsAndPrivacyPolicyFlowSettings: ALTermsAndPrivacyPolicyFlowSettings {
        ALTermsAndPrivacyPolicyFlowSettings(settings.getTermsAndPrivacyPolicyFlowSettings())
    }
    
    /// A toggle for verbose logging for the SDK. This is set to `false` by default. Set it to `false` if you want the SDK to be silent (this is recommended for App Store submissions).
    ///
    /// If set to `true` AppLovin messages will appear in the standard application log which is accessible via the console. All AppLovin log messages are prefixed with the `/AppLovinSdk: [AppLovinSdk]` tag.
    ///
    /// Verbose logging is *disabled* (`false`) by default.
    public var isVerboseLoggingEnabled: Bool {
        get {
            settings.isVerboseLoggingEnabled()
        }
        set {
            settings.setVerboseLogging(newValue)
        }
    }
    
    /// Whether to begin video ads in a muted state or not. Defaults to `false` unless you change this in the dashboard.
    public var isMuted: Bool {
        get {
            settings.isMuted()
        }
        set {
            settings.setMuted(newValue)
        }
    }
    
    /// Whether the Creative Debugger will be displayed after flipping the device screen down twice. Defaults to `true`.
    public var isCreativeDebuggerEnabled: Bool {
        get {
            settings.isCreativeDebuggerEnabled()
        }
        set {
            settings.setCreativeDebuggerEnabled(newValue)
        }
    }
    
    /// An identifier for the current user. This identifier will be tied to SDK events and AppLovin's optional S2S postbacks.
    ///
    /// If you use reward validation, you can optionally set an identifier that AppLovin will include with its currency validation postbacks (for example, a username or email address). AppLovin will include this in the postback when AppLovin pings your currency endpoint from our server.
    public var userIdentifier: String? {
        get {
            settings.getUserIdentifier()
        }
        set {
            settings.setUserIdentifier(newValue)
        }
    }
    
    /// A copy of the extra parameters that are currently set.
    public var extraParameters: [String: String] {
        get {
            if let map = settings.getExtraParameters() {
                return Dictionary(map)
            }
            return [:]
        }
    }
    
    /// Set an extra parameter to pass to the AppLovin server.
    ///
    /// - Parameters:
    ///   - key: Parameter key. Must not be nil.
    ///   - value: Parameter value. May be nil.
    public func setExtraParameter(forKey key: String, value: String?) {
        settings.setExtraParameter(key, value)
    }
}
#endif
#endif
