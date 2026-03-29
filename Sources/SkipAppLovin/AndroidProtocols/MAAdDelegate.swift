// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a listener to be notified about ad events.
public protocol MAAdDelegate: AnyObject {
    /// The SDK invokes this method when a new ad has been loaded.
    func didLoad(_ ad: MAAd)
    
    /// The SDK invokes this method when an ad could not be retrieved.
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError)
    
    /// The SDK invokes this method when a full-screen ad is displayed.
    ///
    /// - Warning: This method is deprecated for MRECs. It will only be called for full-screen ads.
    func didDisplay(_ ad: MAAd)
    
    /// The SDK invokes this method when a full-screen ad is hidden.
    ///
    /// - Warning: This method is deprecated for MRECs. It will only be called for full-screen ads.
    func didHide(_ ad: MAAd)
    
    /// The SDK invokes this method when the ad is clicked.
    func didClick(_ ad: MAAd)
    
    /// The SDK invokes this method when the ad failed to display.
    func didFail(toDisplay ad: MAAd, withError error: MAError)
}
#endif
#endif
