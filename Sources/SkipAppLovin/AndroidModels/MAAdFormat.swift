// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxAdFormat

public class MAAdFormat: CustomStringConvertible {
    // MARK: - Static Ad Formats
    
    /// Represents a 320×50 banner advertisement.
    public static let banner = MAAdFormat(
        label: "BANNER",
        size: CGSize(width: 320, height: 50),
        maxAdFormat: MaxAdFormat.BANNER
    )
    
    /// Represents a 300×250 rectangular advertisement.
    public static let mrec = MAAdFormat(
        label: "MREC",
        size: CGSize(width: 300, height: 250),
        maxAdFormat: MaxAdFormat.MREC
    )
    
    /// Represents a 728×90 leaderboard advertisement
    /// (for tablets).
    public static let leader = MAAdFormat(
        label: "LEADER",
        size: CGSize(width: 728, height: 90),
        maxAdFormat: MaxAdFormat.LEADER
    )
    
    /// Represents a full-screen advertisement.
    public static let interstitial = MAAdFormat(
        label: "INTER",
        size: .zero,
        maxAdFormat: MaxAdFormat.INTERSTITIAL
    )
    
    /// Similar to `interstitial`, except that it is shown
    /// upon opening the app.
    public static let appOpen = MAAdFormat(
        label: "APP_OPEN",
        size: .zero,
        maxAdFormat: MaxAdFormat.APP_OPEN
    )
    
    /// Similar to `interstitial` except that users are given
    /// a reward at the end of the advertisement.
    public static let rewarded = MAAdFormat(
        label: "REWARDED",
        size: .zero,
        maxAdFormat: MaxAdFormat.REWARDED
    )
    
    /// Represents a native advertisement.
    public static let native = MAAdFormat(
        label: "NATIVE",
        size: .zero,
        maxAdFormat: MaxAdFormat.NATIVE
    )
    
    /// Rewarded interstitial ads have been removed and this
    /// property will be removed in a future SDK version.
    @available(*, deprecated, message: "Rewarded interstitial ads have been removed and this property will be removed in a future SDK version.")
    public static let rewardedInterstitial = MAAdFormat(
        label: "REWARDED_INTER",
        size: .zero,
        maxAdFormat: MaxAdFormat.REWARDED_INTERSTITIAL
    )
    
    // MARK: - Properties
    
    /// String representing the name of this ad format.
    /// Sample values include "BANNER", "MREC", "INTER",
    /// "REWARDED", etc.
    public let label: String
    
    /// The size of the AdView format ad, or CGSize.zero
    /// otherwise.
    let size: CGSize
    
    let maxAdFormat: MaxAdFormat
    
    private init(label: String, size: CGSize, maxAdFormat: MaxAdFormat) {
        self.label = label
        self.size = size
        self.maxAdFormat = maxAdFormat
    }
    
    // MARK: - Adaptive Banners
    
    /// Get the adaptive banner size for the screen width
    /// (with safe areas insetted) at the current orientation.
    ///
    /// - Note: The height is the only adaptive dimension;
    ///   the width spans the screen.
    /// - Note: Only AdMob / Google Ad Manager currently has
    ///   support for adaptive banners and the maximum height
    ///   is 15% the height of the screen.
    var adaptiveSize: CGSize {
        let context = ProcessInfo.processInfo.androidContext
        let result = maxAdFormat.getAdaptiveSize(context)
        return CGSize(Double(result.getWidth()), Double(result.getHeight()))
    }
    
    /// Get the adaptive banner size for the provided width
    /// at the current orientation.
    ///
    /// - Note: The height is the only adaptive dimension;
    ///   the width that you provide will be passed back to
    ///   you in the returned size.
    /// - Note: Only AdMob / Google Ad Manager currently has
    ///   support for adaptive banners and the maximum height
    ///   is 15% the height of the screen.
    ///
    /// - Parameter width: The width to retrieve the adaptive
    ///   banner size for, in points.
    /// - Returns: The adaptive banner size for the current
    ///   orientation and width.
    func adaptiveSize(forWidth width: CGFloat) -> CGSize {
        let context = ProcessInfo.processInfo.androidContext
        let result = maxAdFormat.getAdaptiveSize(Int(width.rounded(.down)), context)
        return CGSize(Double(result.getWidth()), Double(result.getHeight()))
    }
    
    // MARK: - Type Checks
    
    /// Whether or not the ad format is fullscreen: that is,
    /// an interstitial or rewarded.
    public var isFullscreenAd: Bool {
        return self === Self.interstitial ||
               self === Self.appOpen ||
               self === Self.rewarded ||
               self === Self.rewardedInterstitial
    }
    
    /// Whether or not the ad format is one of the following:
    /// a banner, leader, or MREC.
    public var isAdViewAd: Bool {
        return self === Self.banner ||
               self === Self.leader ||
               self === Self.mrec
    }
    
    /// Whether or not the ad format is a banner or leader.
    public var isBannerOrLeaderAd: Bool {
        return self === Self.banner || self === Self.leader
    }
    
    /// Human-readable representation of the format.
    public var displayName: String {
        switch self {
        case Self.banner:
            return "Banner"
        case Self.mrec:
            return "MREC"
        case Self.leader:
            return "Leader"
        case Self.interstitial:
            return "Interstitial"
        case Self.appOpen:
            return "App Open"
        case Self.rewarded:
            return "Rewarded"
        case Self.native:
            return "Native"
        case Self.rewardedInterstitial:
            return "Rewarded Interstitial"
        default:
            return label
        }
    }
    
    public var description: String {
        self.displayName
    }
    
    static func fromMaxAdFormat(_ maxAdFormat: MaxAdFormat) -> MAAdFormat {
        switch maxAdFormat {
        case MaxAdFormat.BANNER:
            return .banner
        case MaxAdFormat.MREC:
            return .mrec
        case MaxAdFormat.LEADER:
            return .leader
        case MaxAdFormat.INTERSTITIAL:
            return .interstitial
        case MaxAdFormat.APP_OPEN:
            return .appOpen
        case MaxAdFormat.REWARDED:
            return .rewarded
        case MaxAdFormat.NATIVE:
            return .native
        case MaxAdFormat.REWARDED_INTERSTITIAL:
            return .rewardedInterstitial
        default:
            fatalError("Unknown MaxAdFormat: \(maxAdFormat)")
        }
    }
}
#endif
#endif
