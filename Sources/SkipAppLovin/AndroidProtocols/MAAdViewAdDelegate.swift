// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a listener to be notified about ad view events.
public protocol MAAdViewAdDelegate: MAAdDelegate {
    /// The SDK invokes this method when the MAAdView has expanded to the full screen.
    func didExpand(_ ad: MAAd)
    
    /// The SDK invokes this method when the MAAdView has collapsed back to its original size.
    func didCollapse(_ ad: MAAd)
}

#endif
#endif
