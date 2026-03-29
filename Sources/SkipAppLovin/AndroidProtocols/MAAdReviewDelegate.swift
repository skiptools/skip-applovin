// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !SKIP_BRIDGE
#if SKIP

/// This protocol defines a delegate to be notified when the Ad Review SDK successfully generates a creative id.
public protocol MAAdReviewDelegate: AnyObject {
    /// The SDK invokes this callback when the Ad Review SDK successfully generates a creative id.
    ///
    /// The SDK invokes this callback on the UI thread.
    ///
    /// - Parameters:
    ///   - creativeIdentifier: The Ad Review creative id tied to the ad, if any. You can report creative issues to our Ad review team using this id.
    ///   - ad: The ad for which the ad review event was detected.
    func didGenerateCreativeIdentifier(_ creativeIdentifier: String, for ad: MAAd)
}

#endif
#endif
