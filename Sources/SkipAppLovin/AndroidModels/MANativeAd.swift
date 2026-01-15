// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.nativeAds.MaxNativeAd
import com.applovin.mediation.MaxAdFormat
import android.view.View
import android.graphics.drawable.Drawable
import android.net.Uri

// MARK: - MANativeAdImage

/// Represents a native ad image.
public class MANativeAdImage {
    /// The native ad image (Drawable on Android, UIImage on iOS).
    /// On Android, this is nil if the image is loaded from a URL.
    public let image: Any? // Drawable on Android, but we can't directly expose it
    
    /// The native ad image URL.
    public let url: URL?
    
    internal init(_ maxNativeAdImage: MaxNativeAd.MaxNativeAdImage) {
        // On Android, we can get either a Drawable or a Uri
        if let drawable = maxNativeAdImage.getDrawable() {
            self.image = drawable
            self.url = nil
        } else if let uri = maxNativeAdImage.getUri() {
            self.image = nil
            self.url = URL(string: uri.toString())
        } else {
            self.image = nil
            self.url = nil
        }
    }
}

// MARK: - MANativeAd

/// Represents a native ad to be rendered for an instance of a MAAd.
public class MANativeAd {
    /// The native ad format.
    public let format: MAAdFormat
    
    /// The native ad title text.
    public let title: String?
    
    /// The native ad advertiser text.
    public let advertiser: String?
    
    /// The native ad body text.
    public let body: String?
    
    /// The native ad CTA button text.
    public let callToAction: String?
    
    /// The native ad icon image.
    public let icon: MANativeAdImage?
    
    /// The native ad icon image view.
    /// This is only used for banners using native APIs. Native ads must provide a MANativeAdImage instead.
    /// On Android, this is a View object, but we don't expose it directly in Skip.
    public let iconView: Any? // View on Android, but we can't directly expose it
    
    /// The native ad options view.
    /// On Android, this is a View object, but we don't expose it directly in Skip.
    public let optionsView: Any? // View on Android, but we can't directly expose it
    
    /// The native ad media view.
    /// On Android, this is a View object, but we don't expose it directly in Skip.
    public let mediaView: Any? // View on Android, but we can't directly expose it
    
    /// The native ad main image (cover image).
    public let mainImage: MANativeAdImage?
    
    /// The aspect ratio for the media view if provided by the network. Otherwise returns 0.0.
    public let mediaContentAspectRatio: CGFloat
    
    /// The star rating of the native ad in the [0.0, 5.0] range if provided by the network. Otherwise returns nil.
    public let starRating: Double?
    
    /// Whether or not the ad is expired.
    public let isExpired: Bool
    
    private let maxNativeAd: MaxNativeAd
    
    internal init(_ maxNativeAd: MaxNativeAd) {
        self.maxNativeAd = maxNativeAd
        self.format = MAAdFormat.fromMaxAdFormat(maxNativeAd.getFormat())
        
        self.title = maxNativeAd.getTitle()
        self.advertiser = maxNativeAd.getAdvertiser()
        self.body = maxNativeAd.getBody()
        self.callToAction = maxNativeAd.getCallToAction()
        
        if let maxIcon = maxNativeAd.getIcon() {
            self.icon = MANativeAdImage(maxIcon)
        } else {
            self.icon = nil
        }
        
        // Store View objects but don't expose them directly
        self.iconView = maxNativeAd.getIconView()
        self.optionsView = maxNativeAd.getOptionsView()
        self.mediaView = maxNativeAd.getMediaView()
        
        if let maxMainImage = maxNativeAd.getMainImage() {
            self.mainImage = MANativeAdImage(maxMainImage)
        } else {
            self.mainImage = nil
        }
        
        self.mediaContentAspectRatio = CGFloat(maxNativeAd.getMediaContentAspectRatio())
        
        if let starRatingObj = maxNativeAd.getStarRating() {
            self.starRating = Double(starRatingObj)
        } else {
            self.starRating = nil
        }
        
        self.isExpired = maxNativeAd.isExpired()
    }
    
    /// This method is called before the ad view is returned to the publisher.
    /// The adapters should override this method to register the rendered native ad view and make sure that the view is interactable.
    ///
    /// - Parameter nativeAdView: a rendered native ad view.
    @available(*, deprecated, message: "This method has been deprecated and will be removed in a future SDK version. Please use prepareForInteraction(clickableViews:withContainer:) instead.")
    public func prepareViewForInteraction(_ nativeAdView: Any) {
        // On Android, nativeAdView should be a MaxNativeAdView
        // This is deprecated, so we'll just call the newer method
        fatalError("prepareViewForInteraction is deprecated. Use prepareForInteraction(clickableViews:withContainer:) instead.")
    }
    
    /// This method is called before the ad view is returned to the publisher.
    /// The adapters should override this method to register the rendered native ad view and make sure that the view is interactable.
    ///
    /// - Parameters:
    ///   - clickableViews: The clickable views for the native ad.
    ///   - container: The container for the native ad.
    /// - Returns: true if the call has been successfully handled by a subclass of MANativeAd.
    public func prepareForInteraction(clickableViews: [Any], withContainer container: Any) -> Bool {
        guard let containerView = container as? android.view.ViewGroup,
        let clickableViews = clickableViews as? [View] else {
            fatalError("Invalid clickableViews or container")
        }

        return maxNativeAd.prepareForInteraction(clickableViews.toList(), containerView)
    }
    
    /// Whether or not to run the prepareForInteraction call on the main thread or background thread.
    ///
    /// - Returns: true to run the operation on the main thread, false to run the operation on a background thread. Defaults to true.
    public func shouldPrepareViewForInteractionOnMainThread() -> Bool {
        return maxNativeAd.shouldPrepareViewForInteractionOnMainThread()
    }
    
    /// Whether or not container clickability is supported.
    public var isContainerClickable: Bool {
        return maxNativeAd.isContainerClickable()
    }
    
    /// For supported mediated SDKs, manually invoke a click.
    public func performClick() {
        maxNativeAd.performClick()
    }
    
    /// Mark the ad as expired.
    public func setExpired() {
        maxNativeAd.setExpired()
    }
}
#endif
#endif
