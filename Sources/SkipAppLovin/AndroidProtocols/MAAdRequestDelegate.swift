//
//  MAAdRequestDelegate.swift
//  skip-applovin
//
//  Created by Dan Fabulich on 1/13/26.
//

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
