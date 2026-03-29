// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

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
