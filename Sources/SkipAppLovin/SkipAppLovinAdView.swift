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
#else
import AppLovinSDK

struct AppLovinAdViewWrapper: UIViewRepresentable {
    let bannerAdUnitIdentifier: String
    let placement: String?
    let adFormat: MAAdFormat
    let backgroundColor: UIColor
    init(bannerAdUnitIdentifier: String, adFormat: MAAdFormat, placement: String?, backgroundColor: Color = .black) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.placement = placement
        self.adFormat = adFormat
        self.backgroundColor = UIColor(backgroundColor)
    }
    func makeUIView(context: Context) -> MAAdView
    {
        let adView = MAAdView(adUnitIdentifier:  bannerAdUnitIdentifier, adFormat: adFormat)
        adView.delegate = context.coordinator
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
    class Coordinator: NSObject, MAAdViewAdDelegate
        {
            // MARK: MAAdDelegate Protocol
            
            func didLoad(_ ad: MAAd) {
                print("MAX banner didLoad ad")
            }
            
            func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
                print("MAX banner didFailToLoadAd: \(String(describing: error))")
            }
            
            func didClick(_ ad: MAAd) {}
            
            func didFail(toDisplay ad: MAAd, withError error: MAError) {
                print("MAX banner didFail: \(String(describing: error))")
            }
            
            // MARK: MAAdViewAdDelegate Protocol
            
            func didExpand(_ ad: MAAd) {}
            
            func didCollapse(_ ad: MAAd) {}
            
            // MARK: Deprecated Callbacks
            
            func didDisplay(_ ad: MAAd) { /* use this for impression tracking */ }
            func didHide(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
        }
}

private struct WidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let value2 = nextValue() else { return }
        value = value2
    }
}
#endif

public struct SkipAppLovinAdView: View {
    let bannerAdUnitIdentifier: String
    let placement: String?
    public init(bannerAdUnitIdentifier: String, placement: String? = nil) {
        self.bannerAdUnitIdentifier = bannerAdUnitIdentifier
        self.placement = placement
    }
    #if !SKIP
    @State var adFormat: MAAdFormat?
    #endif
    public var body: some View {
        #if SKIP
        EmptyView()
        #else
        Group {
            if let adFormat {
                AppLovinAdViewWrapper(
                    bannerAdUnitIdentifier: bannerAdUnitIdentifier,
                    adFormat: adFormat,
                    placement: placement,
                )
                    .id(adFormat) // rebuild AdView from scratch when the format changes
                    .frame(height: adFormat.size.height)
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
            let availableAdFormat: MAAdFormat = availableWidth >= MAAdFormat.leader.size.width ? .leader : .banner
            if availableAdFormat != adFormat {
                logger.debug("updating adFormat to \(availableAdFormat)")
                adFormat = availableAdFormat
            }
        }
        #endif
    }
}
#endif
