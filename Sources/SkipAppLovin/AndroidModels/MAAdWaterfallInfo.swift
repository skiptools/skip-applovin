// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxAdWaterfallInfo
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxNetworkResponseInfo
import com.applovin.mediation.MaxMediatedNetworkInfo

// MARK: - MAAdLoadState

/// This enum contains possible states of an ad in the waterfall the adapter response info could represent.
public enum MAAdLoadState: Int {
    /// The AppLovin MAX SDK did not attempt to load an ad from this network in the waterfall because an ad higher in the waterfall loaded successfully.
    case adLoadNotAttempted = 0
    
    /// An ad successfully loaded from this network.
    case adLoaded = 1
    
    /// An ad failed to load from this network.
    case adFailedToLoad = 2
}

// MARK: - MANetworkResponseInfo

/// This class represents an ad response in a waterfall.
public class MANetworkResponseInfo {
    /// The state of the ad that this object represents.
    public let adLoadState: MAAdLoadState
    
    /// The mediated network that this adapter response info object represents.
    public let mediatedNetwork: MAMediatedNetworkInfo
    
    /// The credentials used to load an ad from this adapter, as entered in the AppLovin MAX dashboard.
    public let credentials: [String: Any]
    
    /// Whether or not this response is from a bidding request.
    public let isBidding: Bool
    
    /// The amount of time the network took to load (either successfully or not) an ad, in seconds. If an attempt to load an ad has not been made (i.e. the loadState is .adLoadNotAttempted), the value will be -1.
    public let latency: TimeInterval
    
    /// The ad load error this network response resulted in. Will be nil if an attempt to load an ad has not been made or an ad was loaded successfully (i.e. the loadState is NOT .adFailedToLoad).
    public let error: MAError?
    
    internal init(_ maxNetworkResponseInfo: MaxNetworkResponseInfo) {
        // Map AdLoadState enum
        let adLoadStateValue = maxNetworkResponseInfo.getAdLoadState()
        switch adLoadStateValue {
        case MaxNetworkResponseInfo.AdLoadState.AD_LOAD_NOT_ATTEMPTED:
            self.adLoadState = .adLoadNotAttempted
        case MaxNetworkResponseInfo.AdLoadState.AD_LOADED:
            self.adLoadState = .adLoaded
        case MaxNetworkResponseInfo.AdLoadState.FAILED_TO_LOAD:
            self.adLoadState = .adFailedToLoad
        default:
            self.adLoadState = .adLoadNotAttempted
        }
        
        self.mediatedNetwork = MAMediatedNetworkInfo(maxNetworkResponseInfo.getMediatedNetwork())
        
        let bundle = maxNetworkResponseInfo.getCredentials()
        var credentialsDict: [String: Any] = [:]
        if let bundle = bundle {
            let keySet = bundle.keySet()
            for key in keySet {
                if let keyStr = key as? String {
                    let value = bundle.get(keyStr)
                    credentialsDict[keyStr] = value
                }
            }
        }
        self.credentials = credentialsDict
        
        self.isBidding = maxNetworkResponseInfo.isBidding()
        
        let latencyMillis = maxNetworkResponseInfo.getLatencyMillis()
        let latencyMillisLong = latencyMillis as? Int64 ?? 0
        if latencyMillisLong >= 0 {
            self.latency = TimeInterval(latencyMillisLong) / 1000.0
        } else {
            self.latency = -1.0
        }
        
        if let maxError = maxNetworkResponseInfo.getError() {
            self.error = MAError(maxError)
        } else {
            self.error = nil
        }
    }
}

// MARK: - MAMediatedNetworkInfoInitializationStatus

/// An enum describing the adapter's initialization status.
public enum MAMediatedNetworkInfoInitializationStatus: Int {
    /// The adapter is not initialized. Note: networks need to be enabled for an ad unit id to be initialized.
    case adapterNotInitialized = -4
    
    /// The 3rd-party SDK does not have an initialization callback with status.
    case doesNotApply = -3
    
    /// The 3rd-party SDK is currently initializing.
    case initializing = -2
    
    /// The 3rd-party SDK explicitly initialized, but without a status.
    case initializedUnknown = -1
    
    /// The 3rd-party SDK initialization failed.
    case initializedFailure = 0
    
    /// The 3rd-party SDK initialization was successful.
    case initializedSuccess = 1
}

// MARK: - MAMediatedNetworkInfo

/// This class represents information for a mediated network.
public class MAMediatedNetworkInfo {
    /// The name of the mediated network.
    public let name: String
    
    /// The class name of the adapter for the mediated network.
    public let adapterClassName: String
    
    /// The version of the adapter for the mediated network.
    public let adapterVersion: String
    
    /// The version of the mediated network's SDK.
    public let sdkVersion: String
    
    /// The initialization status of the mediated network's SDK.
    public let initializationStatus: MAMediatedNetworkInfoInitializationStatus
    
    internal init(_ maxMediatedNetworkInfo: MaxMediatedNetworkInfo) {
        self.name = maxMediatedNetworkInfo.getName() ?? ""
        self.adapterClassName = maxMediatedNetworkInfo.getAdapterClassName() ?? ""
        self.adapterVersion = maxMediatedNetworkInfo.getAdapterVersion() ?? ""
        self.sdkVersion = maxMediatedNetworkInfo.getSdkVersion() ?? ""
        
        let statusValue = maxMediatedNetworkInfo.getInitializationStatus()
        switch statusValue {
        case MaxMediatedNetworkInfo.InitializationStatus.NOT_INITIALIZED:
            self.initializationStatus = .adapterNotInitialized
        case MaxMediatedNetworkInfo.InitializationStatus.DOES_NOT_APPLY:
            self.initializationStatus = .doesNotApply
        case MaxMediatedNetworkInfo.InitializationStatus.INITIALIZING:
            self.initializationStatus = .initializing
        case MaxMediatedNetworkInfo.InitializationStatus.INITIALIZED_UNKNOWN:
            self.initializationStatus = .initializedUnknown
        case MaxMediatedNetworkInfo.InitializationStatus.INITIALIZED_FAILURE:
            self.initializationStatus = .initializedFailure
        case MaxMediatedNetworkInfo.InitializationStatus.INITIALIZED_SUCCESS:
            self.initializationStatus = .initializedSuccess
        default:
            self.initializationStatus = .initializedUnknown
        }
    }
}

// MARK: - MAAdWaterfallInfo

/// This class represents an ad waterfall, encapsulating various metadata such as total latency, underlying ad responses, etc.
public class MAAdWaterfallInfo {
    /// The loaded ad, if any, for this waterfall.
    public let loadedAd: MAAd?
    
    /// The ad waterfall name.
    public let name: String
    
    /// The ad waterfall test name.
    public let testName: String
    
    /// The list of network response info objects relating to each ad in the waterfall, ordered by their position.
    public let networkResponses: [MANetworkResponseInfo]
    
    /// The total latency in seconds for this waterfall to finish processing.
    public let latency: TimeInterval
    
    internal init(_ maxAdWaterfallInfo: MaxAdWaterfallInfo, parentAd: MAAd? = nil) {
        if let parentAd {
            self.loadedAd = parentAd
        } else if let maxAd = maxAdWaterfallInfo.getLoadedAd() {
            self.loadedAd = MAAd(maxAd)
        } else {
            self.loadedAd = nil
        }
        
        self.name = maxAdWaterfallInfo.getName() ?? ""
        self.testName = maxAdWaterfallInfo.getTestName() ?? ""
        
        self.networkResponses = Array(maxAdWaterfallInfo.getNetworkResponses()).map { MANetworkResponseInfo($0) }
        
        let latencyMillis = maxAdWaterfallInfo.getLatencyMillis()
        let latencyMillisLong = latencyMillis as? Int64 ?? 0
        self.latency = TimeInterval(latencyMillisLong) / 1000.0
    }
}
#endif
#endif
