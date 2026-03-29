// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a delegate to be notified about ad expiration events.
public protocol MAAdExpirationDelegate: AnyObject {
    /// The SDK invokes this callback when a new ad has reloaded after expiration.
    ///
    /// The SDK invokes this callback on the UI thread.
    ///
    /// - Note: `didLoadAd:` is not invoked for a successfully reloaded ad.
    ///
    /// - Parameters:
    ///   - expiredAd: The previously expired ad.
    ///   - newAd: The newly reloaded ad.
    func didReloadExpiredAd(_ expiredAd: MAAd, withNewAd newAd: MAAd)
}

#endif
#endif
