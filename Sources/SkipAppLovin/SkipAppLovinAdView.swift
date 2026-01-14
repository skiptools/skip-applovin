//
//  SkipAppLovinAdView.swift
//  skip-applovin
//
//  Created by Dan Fabulich on 1/12/26.
//
#if !SKIP_BRIDGE
import SwiftUI
import OSLog

let logger: Logger = Logger(subsystem: "SkipAppLovin", category: "SkipAppLovinAdView")

#if SKIP
import androidx.compose.ui.viewinterop.AndroidView
import com.applovin.mediation.ads.MaxAdView
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxAdViewConfiguration
import com.applovin.mediation.MaxError
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdRequestListener
import androidx.compose.ui.graphics.toArgb

// MARK: - Android

struct AppLovinAdViewWrapper: View {
    let bannerAdUnitIdentifier: String
    let placement: String?
    let adFormat: MAAdFormat?
    let configuration: MAAdViewConfiguration?
    let backgroundColor: Color
    let delegate: MAAdViewAdDelegate?
    let revenueDelegate: MAAdRevenueDelegate?
    let requestDelegate: MAAdRequestDelegate?
    
    init(bannerAdUnitIdentifier: String, adFormat: MAAdFormat? = nil, configuration: MAAdViewConfiguration? = nil, placement: String?, backgroundColor: Color = .black, delegate: MAAdViewAdDelegate? = nil, revenueDelegate: MAAdRevenueDelegate? = nil, requestDelegate: MAAdRequestDelegate? = nil) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.placement = placement
        self.adFormat = adFormat
        self.configuration = configuration
        self.backgroundColor = backgroundColor
        self.delegate = delegate
        self.revenueDelegate = revenueDelegate
        self.requestDelegate = requestDelegate
    }
    
    var body: some View {
        guard let androidActivity = UIApplication.shared.androidActivity else {
            return EmptyView()
        }
        ComposeView { ctx in
            let color = backgroundColor.colorImpl().toArgb()
            AndroidView(factory: { ctx in
                let adView: MaxAdView
                if let adFormat {
                    adView = MaxAdView(bannerAdUnitIdentifier, adFormat.maxAdFormat, configuration?.maxAdViewConfiguration)
                } else {
                    adView = MaxAdView(bannerAdUnitIdentifier, configuration?.maxAdViewConfiguration)
                }
                if let placement {
                    adView.setPlacement(placement)
                }
                let listener = AdViewWrapperListener(delegate: delegate, revenueDelegate: revenueDelegate, requestDelegate: requestDelegate)
                adView.setListener(listener)
                adView.setRevenueListener(listener)
                adView.setRequestListener(listener)
                adView.setBackgroundColor(color)
                adView.loadAd()
                return adView
            }, modifier: ctx.modifier, update: { adView in })
        }
    }
}

class AdViewWrapperListener: MaxAdViewAdListener, MaxAdRevenueListener, MaxAdRequestListener {
    weak var delegate: MAAdViewAdDelegate?
    weak var revenueDelegate: MAAdRevenueDelegate?
    weak var requestDelegate: MAAdRequestDelegate?
    
    init(delegate: MAAdViewAdDelegate?, revenueDelegate: MAAdRevenueDelegate?, requestDelegate: MAAdRequestDelegate?) {
        self.delegate = delegate
        self.revenueDelegate = revenueDelegate
        self.requestDelegate = requestDelegate
    }
    
    override func onAdRevenuePaid(maxAd: MaxAd) {
        logger.info("onAdRevenuePaid \(maxAd)")
        guard let revenueDelegate = revenueDelegate else { return }
        let ad = MAAd(maxAd)
        revenueDelegate.didPayRevenue(for: ad)
    }
    
    override func onAdRequestStarted(adUnitId: String) {
        logger.info("onAdRequestStarted \(adUnitId)")
        requestDelegate?.didStartAdRequest(forAdUnitIdentifier: adUnitId)
    }
    
    override func onAdLoaded(maxAd: MaxAd) {
        logger.info("onAdLoaded \(maxAd)")
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didLoad(ad)
    }

    override func onAdLoadFailed(adUnitId: String, error: MaxError) {
        logger.error("onAdLoadFailed \(error)")
        guard let delegate = delegate else { return }
        let maError = MAError(error)
        delegate.didFailToLoadAd(forAdUnitIdentifier: adUnitId, withError: maError)
    }

    override func onAdDisplayFailed(ad: MaxAd, error: MaxError) {
        logger.error("onAdDisplayFailed \(error)")
        guard let delegate = delegate else { return }
        let maAd = MAAd(ad)
        let maError = MAError(error)
        delegate.didFail(toDisplay: maAd, withError: maError)
    }

    override func onAdClicked(maxAd: MaxAd) {
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didClick(ad)
    }

    override func onAdExpanded(maxAd: MaxAd) {
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didExpand(ad)
    }

    override func onAdCollapsed(maxAd: MaxAd) {
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didCollapse(ad)
    }

    override func onAdDisplayed(maxAd: MaxAd) {
        /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didDisplay(ad)
    }

    override func onAdHidden(maxAd: MaxAd) {
        /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */
        guard let delegate = delegate else { return }
        let ad = MAAd(maxAd)
        delegate.didHide(ad)
    }
}

#else
// MARK: - iOS
import AppLovinSDK

struct AppLovinAdViewWrapper: UIViewRepresentable {
    let bannerAdUnitIdentifier: String
    let placement: String?
    let adFormat: MAAdFormat?
    let configuration: MAAdViewConfiguration?
    let backgroundColor: UIColor
    let delegate: MAAdViewAdDelegate?
    let revenueDelegate: MAAdRevenueDelegate?
    let requestDelegate: MAAdRequestDelegate?
    
    init(bannerAdUnitIdentifier: String, adFormat: MAAdFormat? = nil, configuration: MAAdViewConfiguration? = nil, placement: String?, backgroundColor: Color = .black, delegate: MAAdViewAdDelegate? = nil, revenueDelegate: MAAdRevenueDelegate? = nil, requestDelegate: MAAdRequestDelegate? = nil) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.placement = placement
        self.adFormat = adFormat
        self.configuration = configuration
        self.backgroundColor = UIColor(backgroundColor)
        self.delegate = delegate
        self.revenueDelegate = revenueDelegate
        self.requestDelegate = requestDelegate
    }
    
    func makeUIView(context: Context) -> MAAdView
    {
        let adView: MAAdView
        if let adFormat {
            adView = MAAdView(adUnitIdentifier: bannerAdUnitIdentifier, adFormat: adFormat, configuration: configuration)
        } else {
            adView = MAAdView(adUnitIdentifier: bannerAdUnitIdentifier, configuration: configuration)
        }
        context.coordinator.delegate = delegate
        context.coordinator.revenueDelegate = revenueDelegate
        context.coordinator.requestDelegate = requestDelegate
        adView.delegate = context.coordinator
        adView.revenueDelegate = context.coordinator
        adView.requestDelegate = context.coordinator
        if let placement {
            adView.placement = placement
        }
        // Set background color for banners to be fully functional
        adView.backgroundColor = backgroundColor
        
        // Load the first Ad
        adView.loadAd()
        
        return adView
    }
    
    func updateUIView(_ uiView: MAAdView, context: Context) {}
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator()
    }
}

extension AppLovinAdViewWrapper {
    class Coordinator: NSObject, MAAdViewAdDelegate, MAAdRevenueDelegate, MAAdRequestDelegate
        {
            weak var delegate: MAAdViewAdDelegate?
            weak var revenueDelegate: MAAdRevenueDelegate?
            weak var requestDelegate: MAAdRequestDelegate?
            
            // MARK: MAAdRevenueDelegate Protocol
            
            func didPayRevenue(for ad: MAAd) {
                revenueDelegate?.didPayRevenue(for: ad)
            }
            
            // MARK: MAAdRequestDelegate Protocol
            
            func didStartAdRequest(forAdUnitIdentifier adUnitIdentifier: String) {
                requestDelegate?.didStartAdRequest(forAdUnitIdentifier: adUnitIdentifier)
            }
            
            // MARK: MAAdDelegate Protocol
            
            func didLoad(_ ad: MAAd) {
                delegate?.didLoad(ad)
            }
            
            func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
                delegate?.didFailToLoadAd(forAdUnitIdentifier: adUnitIdentifier, withError: error)
            }
            
            func didClick(_ ad: MAAd) {
                delegate?.didClick(ad)
            }
            
            func didFail(toDisplay ad: MAAd, withError error: MAError) {
                delegate?.didFail(toDisplay: ad, withError: error)
            }
            
            // MARK: MAAdViewAdDelegate Protocol
            
            func didExpand(_ ad: MAAd) {
                delegate?.didExpand(ad)
            }
            
            func didCollapse(_ ad: MAAd) {
                delegate?.didCollapse(ad)
            }
            
            // MARK: Deprecated Callbacks
            
            func didDisplay(_ ad: MAAd) {
                /* use this for impression tracking */
                delegate?.didDisplay(ad)
            }
            
            func didHide(_ ad: MAAd) {
                /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */
                delegate?.didHide(ad)
            }
        }
}

#endif
// MARK: - Views

private struct WidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let value2 = nextValue() else { return }
        value = value2
    }
}

public struct SkipAppLovinAdView: View {
    let bannerAdUnitIdentifier: String
    let adFormat: MAAdFormat
    let configuration: MAAdViewConfiguration?
    let placement: String?
    let delegate: MAAdViewAdDelegate?
    let revenueDelegate: MAAdRevenueDelegate?
    let requestDelegate: MAAdRequestDelegate?
    
    public init(bannerAdUnitIdentifier: String, adFormat: MAAdFormat, configuration: MAAdViewConfiguration? = nil, placement: String? = nil, delegate: MAAdViewAdDelegate? = nil, revenueDelegate: MAAdRevenueDelegate? = nil, requestDelegate: MAAdRequestDelegate? = nil) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.adFormat = adFormat
        self.configuration = configuration
        self.placement = placement
        self.delegate = delegate
        self.revenueDelegate = revenueDelegate
        self.requestDelegate = requestDelegate
    }
    public var body: some View {
        AppLovinAdViewWrapper(
            bannerAdUnitIdentifier: bannerAdUnitIdentifier,
            adFormat: adFormat,
            placement: placement,
            delegate: delegate,
            revenueDelegate: revenueDelegate,
            requestDelegate: requestDelegate
        )
        .frame(width: adFormat.size.width, height: adFormat.size.height)
    }
}

/// Automatically switches between banner and leaderboard ad formats based on available width
public struct SkipAppLovinFlexibleBannerAdView: View {
    @State private var uuid = UUID().uuidString
    let bannerAdUnitIdentifier: String
    let configuration: MAAdViewConfiguration?
    let placement: String?
    let delegate: MAAdViewAdDelegate?
    let revenueDelegate: MAAdRevenueDelegate?
    let requestDelegate: MAAdRequestDelegate?
    
    public init(bannerAdUnitIdentifier: String, configuration: MAAdViewConfiguration? = nil, placement: String? = nil, delegate: MAAdViewAdDelegate? = nil, revenueDelegate: MAAdRevenueDelegate? = nil, requestDelegate: MAAdRequestDelegate? = nil) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.configuration = configuration
        self.placement = placement
        self.delegate = delegate
        self.revenueDelegate = revenueDelegate
        self.requestDelegate = requestDelegate
    }
    @State var width: CGFloat? = nil
    @State var adFormat: MAAdFormat?
    public var body: some View {
        Group {
            if let adFormat, let width {
                AppLovinAdViewWrapper(
                    bannerAdUnitIdentifier: bannerAdUnitIdentifier,
                    adFormat: adFormat,
                    placement: placement,
                    delegate: delegate,
                    revenueDelegate: revenueDelegate,
                    requestDelegate: requestDelegate
                )
                .id("\(uuid)-\(adFormat)") // rebuild AdView from scratch when the format changes
                .frame(height: adFormat.adaptiveSize(forWidth: width).height)
                .frame(maxWidth: .infinity)
            } else {
                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }
        }
        .background {
            GeometryReader { proxy in
                let _ = logger.debug("background \(proxy.size.width)")
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
            }
        }
        .onPreferenceChange(WidthPreferenceKey.self) { availableWidth in
            logger.debug("availableWidth: \(String(describing: availableWidth))")
            guard let availableWidth else { return }
            width = availableWidth
            let availableAdFormat: MAAdFormat = availableWidth >= MAAdFormat.leader.size.width ? .leader : .banner
            if availableAdFormat != adFormat {
                logger.debug("updating adFormat to \(availableAdFormat)")
                adFormat = availableAdFormat
            }
        }
    }
}

#endif

