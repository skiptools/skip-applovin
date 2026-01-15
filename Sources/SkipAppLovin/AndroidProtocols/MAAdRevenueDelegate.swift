// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a delegate to be notified about ad revenue events.
public protocol MAAdRevenueDelegate: AnyObject {
    /// The SDK invokes this callback when it detects a revenue event for an ad.
    ///
    /// The SDK invokes this callback on the UI thread.
    ///
    /// - Parameter ad: The ad for which the revenue event was detected.
    func didPayRevenue(for ad: MAAd)
}

#endif
#endif
