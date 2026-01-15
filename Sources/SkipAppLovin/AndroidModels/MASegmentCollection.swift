// Licensed under the GNU General Public License v3.0 with Linking Exception
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import com.applovin.mediation.MaxSegment
import com.applovin.mediation.MaxSegmentCollection

// SKIP @bridge
public class MASegment {
    /// The key of the segment. Must be a non-negative number
    /// in the range of [0, 32000].
    let key: Int
    
    /// The value(s) associated with the key. Each value must be
    /// a non-negative number in the range of [0, 32000].
    let values: [Int]
    
    /// Initializes a new MASegment with the specified key
    /// and value(s).
    ///
    /// - Parameters:
    ///   - key: The key of the segment. Must be a non-negative
    ///     number in the range of [0, 32000].
    ///   - values: The value(s) associated with the key. Each
    ///     value must be a non-negative number in the range of
    ///     [0, 32000].
    init(key: Int, values: [Int]) {
        self.key = key
        self.values = values
    }
    
    internal var maxSegment: MaxSegment {
        MaxSegment(key, values.toList())
    }
}

// SKIP @bridge
public class MASegmentCollection {
    /// An array of MASegment objects.
    let segments: [MASegment]
    
    internal init(segments: [MASegment]) {
        self.segments = segments
    }
    
    internal var maxSegmentCollection: MaxSegmentCollection {
        let builder = MaxSegmentCollection.builder()
        for segment in segments {
            builder.addSegment(segment.maxSegment)
        }
        return builder.build()
    }
    
    /// Creates a MASegmentCollection object from the builder
    /// in the builderBlock.
    ///
    /// - Parameter builderBlock: A closure that configures
    ///   the builder.
    /// - Returns: A MASegmentCollection object.
    static func segmentCollection(
        withBuilderBlock builderBlock: (
            MASegmentCollectionBuilder
        ) -> Void
    ) -> MASegmentCollection {
        let builder = MASegmentCollectionBuilder()
        builderBlock(builder)
        return builder.build()
    }
    
    /// Creates a builder object for MASegmentCollection.
    ///
    /// - Returns: A MASegmentCollectionBuilder object.
    static func builder() -> MASegmentCollectionBuilder {
        return MASegmentCollectionBuilder()
    }
}

/// Builder class used to create a MASegmentCollection object.
public class MASegmentCollectionBuilder {
    private var segments: [MASegment] = []
    
    /// Adds a MASegment to the collection.
    ///
    /// - Parameter segment: The MASegment to add.
    func addSegment(_ segment: MASegment) {
        segments.append(segment)
    }
    
    /// Builds a MASegmentCollection object from the builder
    /// properties' values.
    ///
    /// - Returns: A MASegmentCollection object.
    func build() -> MASegmentCollection {
        return MASegmentCollection(segments: segments)
    }
}

#endif
#endif
