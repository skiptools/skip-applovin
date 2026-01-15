// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import SwiftUI
import android.app.Activity
import com.applovin.mediation.ads.MaxRewardedAd
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxRewardedAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdRequestListener
import com.applovin.mediation.MaxAdReviewListener
import com.applovin.mediation.MaxAdExpirationListener
import com.applovin.mediation.MaxReward

/// This class represents a full-screen rewarded ad.
public class MARewardedAd {
    /// A delegate that will be notified about ad events.
    public weak var delegate: MARewardedAdDelegate?
    
    /// A delegate that will be notified about ad revenue
    /// events.
    public weak var revenueDelegate: MAAdRevenueDelegate?
    
    /// A delegate that will be notified about ad request
    /// events.
    public weak var requestDelegate: MAAdRequestDelegate?
    
    /// A delegate that will be notified about ad expiration
    /// events.
    public weak var expirationDelegate: MAAdExpirationDelegate?
    
    /// A delegate that will be notified about Ad Review
    /// events.
    public weak var adReviewDelegate: MAAdReviewDelegate?

    /// The ad unit identifier this MARewardedAd was
    /// initialized with and is loading ads for.
    public var adUnitIdentifier: String {
        ad.getAdUnitId()
    }
    
    private let ad: MaxRewardedAd
    
    /// Gets an instance of a MAX rewarded ad.
    ///
    /// - Parameter adUnitIdentifier: Ad unit ID for which to get the ad instance.
    /// - Returns: An instance of a rewarded ad tied to the specified ad unit ID.
    public static func shared(withAdUnitIdentifier adUnitIdentifier: String) -> MARewardedAd {
        let maxAd = MaxRewardedAd.getInstance(adUnitIdentifier)
        return MARewardedAd(maxAd: maxAd)
    }
    
    private init(maxAd: MaxRewardedAd) {
        self.ad = maxAd
        let listener = MaxRewardedAdListenerAdapter(self)
        ad.setListener(listener)
        ad.setRevenueListener(listener)
        ad.setRequestListener(listener)
        ad.setAdReviewListener(listener)
        ad.setExpirationListener(listener)
    }
    
    /// Load the current rewarded ad. Use delegate to assign a delegate that should be notified about ad load state.
    public func load() {
        ad.loadAd()
    }
    
    /// Show the loaded rewarded ad for a given placement and
    /// custom data to tie ad events to.
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
    ) {
        let activity = UIApplication.shared.androidActivity
        if let placement = placement, let customData = customData {
            ad.showAd(placement, customData, activity)
        } else if let placement = placement {
            ad.showAd(placement, activity)
        } else {
            ad.showAd(activity)
        }
    }
    
    /// Whether or not this ad is ready to be shown.
    public var isReady: Bool {
        ad.isReady()
    }
    
    /// Sets an extra key/value parameter for the ad.
    ///
    /// - Parameters:
    ///   - key: Parameter key.
    ///   - value: Parameter value.
    public func setExtraParameter(
        forKey key: String,
        value: String?
    ) {
        ad.setExtraParameter(key, value)
    }
    
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
    ) {
        ad.setLocalExtraParameter(key, value)
    }
}

class MaxRewardedAdListenerAdapter: MaxRewardedAdListener, MaxAdRevenueListener, MaxAdRequestListener, MaxAdReviewListener, MaxAdExpirationListener {
    weak var rewardedAd: MARewardedAd?
    init(_ rewardedAd: MARewardedAd) {
        self.rewardedAd = rewardedAd
    }
    
    override func onUserRewarded(maxAd: MaxAd, maxReward: MaxReward) {
        rewardedAd?.delegate?.didRewardUser(for: MAAd(maxAd), with: MAReward(maxReward: maxReward))
    }
    
    override func onAdRevenuePaid(maxAd: MaxAd) {
        rewardedAd?.revenueDelegate?.didPayRevenue(for: MAAd(maxAd))
    }
    
    override func onAdRequestStarted(adUnitId: String) {
        rewardedAd?.requestDelegate?.didStartAdRequest(forAdUnitIdentifier: adUnitId)
    }
    
    override func onCreativeIdGenerated(creativeId: String, maxAd: MaxAd) {
        rewardedAd?.adReviewDelegate?.didGenerateCreativeIdentifier(creativeId, for: MAAd(maxAd))
    }
    
    override func onExpiredAdReloaded(expiredAd: MaxAd, newAd: MaxAd) {
        rewardedAd?.expirationDelegate?.didReloadExpiredAd(MAAd(expiredAd), withNewAd: MAAd(newAd))
    }
    override func onAdLoaded(_ ad: MaxAd) {
        rewardedAd?.delegate?.didLoad(MAAd(ad))
    }
    override func onAdDisplayed(_ ad: MaxAd) {
        rewardedAd?.delegate?.didDisplay(MAAd(ad))
    }
    override func onAdHidden(_ ad: MaxAd) {
        rewardedAd?.delegate?.didHide(MAAd(ad))
    }
    override func onAdClicked(_ ad: MaxAd) {
        rewardedAd?.delegate?.didClick(MAAd(ad))
    }
    override func onAdLoadFailed(_ adUnitIdentifier: String, error: MaxError) {
        rewardedAd?.delegate?.didFailToLoadAd(forAdUnitIdentifier: adUnitIdentifier, withError: MAError(error))
    }
    override func onAdDisplayFailed(_ ad: MaxAd, error: MaxError) {
        rewardedAd?.delegate?.didFail(toDisplay: MAAd(ad), withError: MAError(error))
    }
}
#endif
#endif
