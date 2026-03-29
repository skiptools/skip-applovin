// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !SKIP_BRIDGE
#if SKIP

/// This delegate is notified when a user watches a rewarded video and of whether a reward was granted or rejected.
public protocol MARewardedAdDelegate: MAAdDelegate {
    /// The SDK invokes this method when a user should be granted a reward.
    ///
    /// - Parameters:
    ///   - ad: Ad for which the reward ad was rewarded.
    ///   - reward: The reward to be granted to the user.
    func didRewardUser(for ad: MAAd, with reward: MAReward)
}
#endif
#endif
