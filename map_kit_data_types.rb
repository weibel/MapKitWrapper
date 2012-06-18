module MapKit
  # Wrappers for the Map Kit Data Types
  # http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
  module DataTypes

    # Wrapper for MKCoordinateSpan
    class CoordinateSpan
      attr_reader :sdk

      # CoordinateSpan.new(1,2)
      # CoordinateSpan.new([1,2])
      # CoordinateSpan.new(MKCoordinateSpan)
      def initialize(*args)
        args.flatten!
        if args.first.is_a?(MKCoordinateSpan)
          @sdk = args.first
        else
          @sdk = MKCoordinateSpanMake(args[0], args[1])
        end
      end

      def latitude_delta
        @sdk.latitudeDelta
      end

      def longitude_delta
        @sdk.longitudeDelta
      end

      def to_array
        [latitude_delta, longitude_delta]
      end
    end

    # Wrapper for MKCoordinateRegion
    class CoordinateRegion
      include CoreLocation::DataTypes
      attr_reader :sdk

      # CoordinateRegion.new([56, 10.6], [3.1, 3.1])
      # CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
      # CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
      def initialize(center, span)
        center = LocationCoordinate.new(center) if !center.is_a?(LocationCoordinate)
        span = CoordinateSpan.new(span) if !span.is_a?(CoordinateSpan)
        @sdk = MKCoordinateRegionMake(center.sdk, span.sdk)
      end

      def center
        LocationCoordinate.new(@sdk.center)
      end

      def span
        CoordinateSpan.new(@sdk.span)
      end

      def to_hash
        {:center => center.to_array, :span => span.to_array}
      end
    end

    # Wrapper for MKMapPoint
    class MapPoint
      attr_reader :sdk

      # MapPoint.new(50,45)
      # MapPoint.new([50,45])
      # MapPoint.new(MKMapPoint)
      def initialize(*args)
        args.flatten!
        if args.first.is_a?(MKMapPoint)
          @sdk = args.first
        else
          @sdk = MKMapPointMake(args[0], args[1])
        end
      end

      def x
        @sdk.x
      end

      def y
        @sdk.y
      end

      def to_array
        [x, y]
      end
    end

    # Wrapper for MKMapSize
    class MapSize
      attr_reader :sdk

      # MapSize.new(10,12)
      # MapSize.new([10,12])
      # MapSize.new(MKMapSize)
      def initialize(*args)
        args.flatten!
        if args.first.is_a?(MKMapSize)
          @sdk = args.first
        else
          @sdk = MKMapSizeMake(args[0], args[1])
        end
      end

      def width
        @sdk.width
      end

      def height
        @sdk.height
      end

      def to_array
        [width, height]
      end
    end

    # Wrapper for MKMapRect
    class MapRect
      attr_reader :sdk

      # MapRect.new([10,12], [2,4])
      # MapRect.new(MapPoint, MapSize)
      # MapRect.new(MKMapPoint, MKMapSize)
      def initialize(origin, size)
        origin = MapPoint.new(origin) if !origin.is_a?(MapPoint)
        size = MapSize.new(size) if !size.is_a?(MapSize)
        @sdk = MKMapRectMake(origin.sdk.x, origin.sdk.y, size.sdk.width, size.sdk.height)
      end

      def origin
        MapPoint.new(@sdk.origin)
      end

      def size
        MapSize.new(@sdk.size)
      end

      def to_hash
        {:origin => origin.to_array, :size => size.to_array}
      end
    end
  end
end