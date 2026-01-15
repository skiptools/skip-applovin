// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

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
