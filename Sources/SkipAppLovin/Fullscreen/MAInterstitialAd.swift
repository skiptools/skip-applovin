// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import SwiftUI
import android.app.Activity
import com.applovin.mediation.ads.MaxInterstitialAd
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdRequestListener
import com.applovin.mediation.MaxAdReviewListener
import com.applovin.mediation.MaxAdExpirationListener

/// This class represents a full-screen interstitial ad.
public class MAInterstitialAd {
    /// A delegate that will be notified about ad events.
    public weak var delegate: MAAdDelegate?
    
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
    
    /// The ad unit identifier this MAInterstitialAd was
    /// initialized with and is loading ads for.
    public var adUnitIdentifier: String {
        ad.getAdUnitId()
    }
    
    private let ad: MaxInterstitialAd
    
    /// Creates a new mediation interstitial.
    ///
    /// - Parameter adUnitIdentifier: Ad unit ID to load ads
    ///   for.
    public init(adUnitIdentifier: String) {
        self.ad = MaxInterstitialAd(adUnitIdentifier)
        let listener = MaxAdListenerAdapter(self)
        ad.setListener(listener)
        ad.setRevenueListener(listener)
        ad.setRequestListener(listener)
        ad.setAdReviewListener(listener)
        ad.setExpirationListener(listener)
    }
    
    /// Load the ad for the current interstitial. Set
    /// delegate to assign a delegate that should be notified
    /// about ad load state.
    public func load() {
        ad.loadAd()
    }
    
    /// Show the loaded interstitial ad.
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
        show(
            forPlacement: placement,
            customData: customData,
            activity: nil
        )
    }
    
    /// Show the loaded interstitial ad for a given placement
    /// and custom data to tie ad events to, and an
    /// activity to present the ad from.
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
    ///   - activity: The activity to display
    ///     the ad from. If nil, will be inferred
    func show(
        forPlacement placement: String?,
        customData: String?,
        activity: Activity?
    ) {
        let activity = activity ?? UIApplication.shared.androidActivity
        ad.showAd(placement, customData, activity)
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
        key: String,
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
        key: String,
        value: Any?
    ) {
        ad.setLocalExtraParameter(key, value)
    }
}

class MaxAdListenerAdapter: MaxAdListener, MaxAdRevenueListener, MaxAdRequestListener, MaxAdReviewListener, MaxAdExpirationListener {
    weak var interstitialAd: MAInterstitialAd?
    init(_ interstitialAd: MAInterstitialAd) {
        self.interstitialAd = interstitialAd
    }
    
    override func onAdRevenuePaid(maxAd: MaxAd) {
        interstitialAd?.revenueDelegate?.didPayRevenue(for: MAAd(maxAd))
    }
    
    override func onAdRequestStarted(adUnitId: String) {
        interstitialAd?.requestDelegate?.didStartAdRequest(forAdUnitIdentifier: adUnitId)
    }
    
    override func onCreativeIdGenerated(creativeId: String, maxAd: MaxAd) {
        interstitialAd?.adReviewDelegate?.didGenerateCreativeIdentifier(creativeId, for: MAAd(maxAd))
    }
    
    override func onExpiredAdReloaded(expiredAd: MaxAd, newAd: MaxAd) {
        interstitialAd?.expirationDelegate?.didReloadExpiredAd(MAAd(expiredAd), withNewAd: MAAd(newAd))
    }
    override func onAdLoaded(_ ad: MaxAd) {
        interstitialAd?.delegate?.didLoad(MAAd(ad))
    }
    override func onAdDisplayed(_ ad: MaxAd) {
        interstitialAd?.delegate?.didDisplay(MAAd(ad))
    }
    override func onAdHidden(_ ad: MaxAd) {
        interstitialAd?.delegate?.didHide(MAAd(ad))
    }
    override func onAdClicked(_ ad: MaxAd) {
        interstitialAd?.delegate?.didClick(MAAd(ad))
    }
    override func onAdLoadFailed(_ adUnitIdentifier: String, error: MaxError) {
        interstitialAd?.delegate?.didFailToLoadAd(forAdUnitIdentifier: adUnitIdentifier, withError: MAError(error))
    }
    override func onAdDisplayFailed(_ ad: MaxAd, error: MaxError) {
        interstitialAd?.delegate?.didFail(toDisplay: MAAd(ad), withError: MAError(error))
    }
}
#endif
#endif
