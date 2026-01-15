// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxReward

/// This object represents a reward given to the user.
public class MAReward {
    /// The label that is used when a label is not given by the third-party network.
    public static var defaultLabel: String = MaxReward.DEFAULT_LABEL
    
    /// The amount that is used when no amount is given by the third-party network.
    public static var defaultAmount: Int = MaxReward.DEFAULT_AMOUNT
    
    /// The reward label or `defaultLabel` if none specified.
    public let label: String
    
    /// The rewarded amount or `defaultAmount` if none specified.
    public let amount: Int
    
    /// Create a reward object, with a label and an amount.
    ///
    /// - Parameters:
    ///   - amount: The rewarded amount.
    ///   - label: The reward label.
    public static func reward(amount: Int = MAReward.defaultAmount, label: String = MAReward.defaultLabel) -> MAReward {
        MAReward(amount: amount, label: label)
    }
    
    init(maxReward: MaxReward) {
        self.amount = maxReward.getAmount()
        self.label = maxReward.getLabel()
    }
    
    init(amount: Int, label: String) {
        self.amount = amount
        self.label = label
    }
}
#endif
#endif
