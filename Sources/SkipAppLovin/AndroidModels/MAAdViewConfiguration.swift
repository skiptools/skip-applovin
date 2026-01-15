// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxAdViewConfiguration

/// Defines the type of adaptive MAAdView.
public enum MAAdViewAdaptiveType: Int {
    /// Default type - standard banner/leader or MREC.
    case none
    
    /// Adaptive ad view anchored to the screen. The MAX SDK
    /// determines the height of the adaptive ad view by
    /// invoking adaptiveSize(forWidth:) which results in a
    /// height that ranges from 50 to 90 points but does not
    /// exceed 15% of the screen height in the current
    /// orientation.
    case anchored
    
    /// Adaptive ad view embedded within scrollable content.
    /// The height can extend up to the device height in the
    /// current orientation unless you restrict it by setting
    /// inlineMaximumHeight.
    case inline
}

// MARK: - MAAdViewConfiguration Builder

/// Builder class that you instantiate to create a
/// MAAdViewConfiguration object before you create a
/// MAAdView. This class contains properties that you can set
/// to configure the properties of the MAAdView that results
/// from the configuration object this class builds.
public class MAAdViewConfigurationBuilder {
    /// The adaptive type of the MAAdView. Defaults to
    /// .none.
    public var adaptiveType: MAAdViewAdaptiveType = .none
    
    /// The custom width, in points, for the adaptive
    /// MAAdView. Must not exceed the width of the application
    /// window.
    public var adaptiveWidth: CGFloat = -1
    
    /// The custom maximum height, in points, for the inline
    /// adaptive MAAdView.
    /// Must be at least 32 points and no more than the device
    /// height in the current orientation. A minimum of 50
    /// points is recommended.
    public var inlineMaximumHeight: CGFloat = -1
    
    // MARK: - Build
    
    /// Builds a MAAdViewConfiguration object from the builder
    /// properties' values.
    ///
    /// - Returns: A MAAdViewConfiguration object.
    func build() -> MAAdViewConfiguration {
        return MAAdViewConfiguration(
            adaptiveType: adaptiveType,
            adaptiveWidth: adaptiveWidth,
            inlineMaximumHeight: inlineMaximumHeight
        )
    }
}

/// This class contains configurable fields for the MAAdView.
public class MAAdViewConfiguration {
    /// The adaptive type of the MAAdView. Defaults to
    /// .none.
    let adaptiveType: MAAdViewAdaptiveType
    
    /// The custom width, in points, for the adaptive
    /// MAAdView. Defaults to -1, which indicates that the
    /// width adapts to span the application window.
    /// This value is only used when you set adaptiveType to
    /// either .anchored or .inline.
    let adaptiveWidth: CGFloat
    
    /// The maximum height, in points, for an inline adaptive
    /// MAAdView. Defaults to -1, allowing the height to
    /// extend up to the device height.
    /// This value is only used when you set adaptiveType to
    /// .inline.
    let inlineMaximumHeight: CGFloat
    
    internal init(
        adaptiveType: MAAdViewAdaptiveType,
        adaptiveWidth: CGFloat,
        inlineMaximumHeight: CGFloat
    ) {
        self.adaptiveType = adaptiveType
        self.adaptiveWidth = adaptiveWidth
        self.inlineMaximumHeight = inlineMaximumHeight
    }
    
    var maxAdViewConfiguration: MaxAdViewConfiguration {
        let maxAdaptiveType: MaxAdViewConfiguration.AdaptiveType
        switch adaptiveType {
        case .none:
            maxAdaptiveType = MaxAdViewConfiguration.AdaptiveType.NONE
        case .anchored:
            maxAdaptiveType = MaxAdViewConfiguration.AdaptiveType.ANCHORED
        case .inline:
            maxAdaptiveType = MaxAdViewConfiguration.AdaptiveType.INLINE
        }
        let result = MaxAdViewConfiguration.builder()
            .setAdaptiveType(maxAdaptiveType)
            .setAdaptiveWidth(Int(adaptiveWidth))
            .setInlineMaximumHeight(Int(inlineMaximumHeight))
            .build()
        return result
    }
    
    // MARK: - Initialization
    
    /// Creates a MAAdViewConfiguration object constructed
    /// from the MAAdViewConfigurationBuilder block.
    /// You may modify the configuration from within the
    /// block.
    ///
    /// - Parameter builderBlock: A closure that configures
    ///   the builder.
    /// - Returns: A MAAdViewConfiguration object.
    public init(
        withBuilderBlock builderBlock: @escaping (
            MAAdViewConfigurationBuilder
        ) -> Void
    ) {
        let builder = MAAdViewConfigurationBuilder()
        builderBlock(builder)
        self.adaptiveType = builder.adaptiveType
        self.adaptiveWidth = builder.adaptiveWidth
        self.inlineMaximumHeight = builder.inlineMaximumHeight
    }
}
#endif
#endif
