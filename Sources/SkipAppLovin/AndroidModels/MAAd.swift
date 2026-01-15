// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdWaterfallInfo
import com.applovin.mediation.nativeAds.MaxNativeAd

// MARK: - MAAd

/// This class represents an ad that has been served by AppLovin MAX.
public class MAAd: CustomStringConvertible {
    /// The format of this ad.
    public let format: MAAdFormat
    
    /// The size of the AdView format ad, or CGSize.zero otherwise.
    let size: CGSize
    
    /// The ad unit ID for which this ad was loaded.
    public let adUnitIdentifier: String
    
    /// The ad network from which this ad was loaded.
    public let networkName: String
    
    /// The ad network placement for which this ad was loaded.
    public let networkPlacement: String
    
    /// The creative id tied to the ad, if any.
    public let creativeIdentifier: String?
    
    /// The ad's revenue amount. In the case where no revenue amount exists, or it is not available yet, will return a value of 0.
    public let revenue: Double
    
    /// The precision of the revenue value for this ad.
    public let revenuePrecision: String
    
    /// The placement name that you assign when you integrate each ad format.
    public let placement: String?
    
    /// The underlying waterfall of ad responses.
    public var waterfall: MAAdWaterfallInfo? {
        // MAAd references MAAdWaterfallInfo, which references MAAd, so we need to use a lazy property to avoid infinite recursion
        if _waterfall == nil {
            if let maxWaterfall = maxAd.getWaterfall() {
                _waterfall = MAAdWaterfallInfo(maxWaterfall, parentAd: self)
            }
        }
        return _waterfall
    }
    
    private var _waterfall: MAAdWaterfallInfo?
    
    /// The latency of the mediation ad load request in seconds.
    public let requestLatency: TimeInterval
    
    /// For Native ads only. Get an instance of the MANativeAd containing the assets used to render the native ad view.
    public let nativeAd: MANativeAd?
    
    /// The DSP network that provided the loaded ad when the ad is served through AppLovin Exchange.
    public let DSPName: String?
    
    /// The DSP id network that provided the loaded ad when the ad is served through AppLovin Exchange.
    public let DSPIdentifier: String?
    
    private let maxAd: MaxAd
    
    internal init(_ maxAd: MaxAd) {
        self.maxAd = maxAd
        self.format = MAAdFormat.fromMaxAdFormat(maxAd.getFormat())
        
        let sizeObj = maxAd.getSize()
        self.size = CGSize(width: Double(sizeObj.getWidth()), height: Double(sizeObj.getHeight()))
        
        self.adUnitIdentifier = maxAd.getAdUnitId() ?? ""
        self.networkName = maxAd.getNetworkName() ?? ""
        self.networkPlacement = maxAd.getNetworkPlacement() ?? ""
        self.creativeIdentifier = maxAd.getCreativeId()
        self.revenue = maxAd.getRevenue()
        self.revenuePrecision = maxAd.getRevenuePrecision() ?? ""
        self.placement = maxAd.getPlacement()
        
        self.requestLatency = TimeInterval(maxAd.getRequestLatencyMillis()) / 1000.0
        
        if let maxNativeAd = maxAd.getNativeAd() {
            self.nativeAd = MANativeAd(maxNativeAd)
        } else {
            self.nativeAd = nil
        }
        self.DSPName = maxAd.getDspName()
        self.DSPIdentifier = maxAd.getDspId()
    }
    
    /// Gets the ad value for a given key.
    public func adValue(forKey key: String) -> String? {
        return maxAd.getAdValue(key)
    }
    
    /// Gets the ad value for a given key.
    public func adValue(forKey key: String, defaultValue: String?) -> String? {
        return maxAd.getAdValue(key, defaultValue)
    }
    
    public var description: String {
        "MAAd: adUnitId=\(adUnitIdentifier), format=\(format), networkName=\(networkName)"
    }
}
#endif
#endif
