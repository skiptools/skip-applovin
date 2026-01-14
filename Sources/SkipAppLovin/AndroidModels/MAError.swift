//
//  MAError.swift
//  skip-applovin
//
//  Created by Dan Fabulich on 1/13/26.
//

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxError

/// This enum contains various error codes that the SDK can return when a MAX ad fails to load or display.
public enum MAErrorCode: Int {
    /// This error code represents an error that could not be categorized into one of the other defined errors.
    case unspecified = -1
    
    /// This error code indicates that MAX returned no eligible ads from any mediated networks for this app/device.
    case noFill = 204
    
    /// This error code indicates that MAX returned eligible ads from mediated networks, but all ads failed to load.
    case adLoadFailed = -5001
    
    /// This error code indicates that the SDK failed to load an ad because the publisher provided an invalid ad unit identifier.
    case invalidAdUnitIdentifier = -5603
    
    /// This error code indicates that the ad request failed due to a generic network error.
    case networkError = -1000
    
    /// This error code indicates that the ad request timed out due to a slow internet connection.
    case networkTimeout = -1001
    
    /// This error code indicates that the ad request failed because the device is not connected to the internet.
    case noNetwork = -1009
    
    /// This error code indicates that you attempted to show a fullscreen ad while another fullscreen ad is still showing.
    case fullscreenAdAlreadyShowing = -23
    
    /// This error code indicates you are attempting to show a fullscreen ad before the one has been loaded.
    case fullscreenAdNotReady = -24
    
    /// This error code indicates you attempted to present a fullscreen ad from an invalid view controller.
    case fullscreenAdInvalidViewController = -25
}

/// This class encapsulates various data for MAX load and display errors.
public class MAError {
    /// The error code for the error.
    public let code: MAErrorCode
    
    /// The error message for the error.
    public let message: String
    
    /// The mediated network's error code for the error. Available for errors returned in didFailToDisplayAd only.
    public let mediatedNetworkErrorCode: Int
    
    /// The mediated network's error message for the error. Defaults to an empty string. Available for errors returned in didFailToDisplayAd only.
    public let mediatedNetworkErrorMessage: String
    
    /// The underlying waterfall of ad responses.
    public let waterfall: MAAdWaterfallInfo?
    
    /// The latency of the mediation ad load request in seconds.
    public let requestLatency: TimeInterval
    
    internal init(_ maxError: MaxError) {
        self.code = MAErrorCode(rawValue: maxError.getCode()) ?? .unspecified
        self.message = maxError.getMessage() ?? ""
        self.mediatedNetworkErrorCode = maxError.getMediatedNetworkErrorCode()
        self.mediatedNetworkErrorMessage = maxError.getMediatedNetworkErrorMessage() ?? ""
        self.waterfall = nil // TODO: Implement MAAdWaterfallInfo wrapper
        self.requestLatency = TimeInterval(maxError.getRequestLatencyMillis()) / 1000.0
    }
}
#endif
#endif
