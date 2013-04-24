#= require core_location_data_types

module MapKit
  ##
  # Wrappers for the Map Kit Data Types
  # http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
  module DataTypes
    ##
    # Wrapper for MKCoordinateSpan
    class CoordinateSpan
      attr_reader :sdk
      ##
      # CoordinateSpan.new(1,2)
      # CoordinateSpan.new([1,2])
      # CoordinateSpan.new(CoordinateSpan)
      # CoordinateSpan.new(MKCoordinateSpan)
      def initialize(*args)
        latitudedelta, longitudedelta = nil, nil
        args.flatten!
        if args.size == 1
          arg = args.first
          if arg.is_a?(MKCoordinateSpan)
            latitudedelta, longitudedelta = arg.latitudeDelta, arg.longitudeDelta
          elsif arg.is_a?(CoordinateSpan)
            latitudedelta, longitudedelta = arg.latitude_delta, arg.longitude_delta
          end
        elsif args.size == 2
          latitudedelta, longitudedelta = args[0], args[1]
        end
        @sdk = MKCoordinateSpanMake(latitudedelta, longitudedelta)
        self
      end

      def latitude_delta
        @sdk.latitudeDelta
      end

      def longitude_delta
        @sdk.longitudeDelta
      end

      def to_a
        [latitude_delta, longitude_delta]
      end

      def to_h
        {:latitude_delta => latitude_delta, :longitude_delta => longitude_delta}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKCoordinateRegion
    class CoordinateRegion
      include CoreLocation::DataTypes
      attr_reader :sdk
      ##
      # CoordinateRegion.new(CoordinateRegion)
      # CoordinateRegion.new(MKCoordinateRegion)
      # CoordinateRegion.new([56, 10.6], [3.1, 3.1])
      # CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
      # CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
      def initialize(*args)
        if args.size == 1
          if args[0].is_a?(CoordinateRegion)
            center, span = args[0].center.sdk, args[0].span.sdk
          else
            center, span = args[0].center, args[0].span
          end
        else
          center = args[0].is_a?(LocationCoordinate) ? args[0].sdk : args[0]
          span = args[1].is_a?(CoordinateSpan) ? args[1].sdk : args[1]
        end
        @sdk = MKCoordinateRegionMake(center, span)
      end

      def center
        LocationCoordinate.new(@sdk.center)
      end

      def span
        CoordinateSpan.new(@sdk.span)
      end

      def to_h
        {:center => center.to_h, :span => span.to_h}
      end
    end
    ##
    # Wrapper for MKMapPoint
    class MapPoint
      attr_reader :sdk
      ##
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

      def to_a
        [x, y]
      end

      def to_h
        {:x => x, :y => y}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKMapSize
    class MapSize
      attr_reader :sdk
      ##
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

      def to_a
        [width, height]
      end

      def to_h
        {:width => width, :height => height}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKMapRect
    class MapRect
      attr_reader :sdk
      ##
      # MapRect.new(x, y, width, height)
      # MapRect.new([x, y], [width, height])
      # MapRect.new(MapPoint, MapSize)
      # MapRect.new(MKMapPoint, MKMapSize)
      def initialize(*args)
        args.flatten!
        if args.size == 2
          origin = args[0].is_a?(MapPoint) ? args[0] : MapPoint.new(args[0])
          size = args[1].is_a?(MapSize) ? args[1] : MapSize.new(args[1])
          @sdk = MKMapRectMake(origin.sdk.x, origin.sdk.y, size.sdk.width, size.sdk.height)
        elsif args.size == 4
          @sdk = MKMapRectMake(args[0], args[1], args[2], args[3])
        end
      end

      def origin
        MapPoint.new(@sdk.origin)
      end

      def size
        MapSize.new(@sdk.size)
      end

      def to_h
        {:origin => origin.to_h, :size => size.to_h}
      end
    end
  end
end