// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a delegate to be notified about ad request events.
public protocol MAAdRequestDelegate: AnyObject {
    /// The SDK invokes this callback when it sends a request for an ad, which can be for the initial ad load and upcoming ad refreshes.
    ///
    /// The SDK invokes this callback on the UI thread.
    ///
    /// - Parameter adUnitIdentifier: The ad unit identifier that the SDK requested an ad for.
    func didStartAdRequest(forAdUnitIdentifier adUnitIdentifier: String)
}

#endif
#endif
