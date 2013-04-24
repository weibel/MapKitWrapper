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
      # CoordinateSpan.new({:latitude_delta => 1, :longitude_delta => 2})
      # CoordinateSpan.new(CoordinateSpan)
      # CoordinateSpan.new(MKCoordinateSpan)
      def initialize(*args)
        latitudedelta, longitudedelta = nil, nil
        args.flatten!
        case args.size
          when 1
            arg = args.first
            if arg.is_a?(MKCoordinateSpan)
              latitudedelta, longitudedelta = arg.latitudeDelta, arg.longitudeDelta
            elsif arg.is_a?(CoordinateSpan)
              latitudedelta, longitudedelta = arg.latitude_delta, arg.longitude_delta
            elsif arg.is_a?(Hash)
              latitudedelta, longitudedelta = arg[:latitude_delta], arg[:longitude_delta]
            end
          when 2
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
      # CoordinateRegion.new({:center => {:latitude => 56, :longitude => 10.6}, :span => {:latitude_delta => 3.1, :longitude_delta => 3.1}}
      # CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
      # CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
      def initialize(*args)
        center, span = nil, nil
        case args.size
          when 1
            arg = args[0]
            if arg.is_a?(CoordinateRegion) || arg.is_a?(MKCoordinateRegion)
              center, span = arg.center, arg.span
            elsif  arg.is_a?(Hash)
              center, span = arg[:center], arg[:span]
            end
          when 2
            center = args[0]
            span = args[1]
        end
        @sdk = MKCoordinateRegionMake(LocationCoordinate.new(center).sdk, CoordinateSpan.new(span).sdk)
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
      # MapPoint.new({:x => 50, :y => 45})
      # MapPoint.new(MKMapPoint)
      def initialize(*args)
        args.flatten!
        x, y = nil, nil
        case args.size
          when 1
            arg = args[0]
            if arg.is_a?(MKMapPoint) || arg.is_a?(MapPoint)
              x, y = arg.x, arg.y
            elsif arg.is_a?(Hash)
              x, y = arg[:x], arg[:y]
            end
          when 2
            x, y = args[0], args[1]
        end
        @sdk = MKMapPointMake(x, y)
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
      # MapSize.new({:width => 10, :height => 12})
      # MapSize.new(MKMapSize)
      def initialize(*args)
        args.flatten!
        width, height = nil, nil
        case args.size
          when 1
            arg= args[0]
            if arg.is_a?(MKMapSize) || arg.is_a?(MapSize)
              width, height = arg.width, arg.height
            elsif arg.is_a?(Hash)
              width, height = arg[:width], arg[:height]
            end
          when 2
            width, height = args[0], args[1]
        end
        @sdk = MKMapSizeMake(width, height)
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
      # MapRect.new({:origin => {:x => 5.0, :y => 8.0}, :size => {:width => 6.0, :height => 9.0}})
      # MapRect.new(MapPoint, MapSize)
      # MapRect.new(MKMapPoint, MKMapSize)
      def initialize(*args)
        origin, size = nil, nil
        case args.size
          when 1
            origin, size = args[0][:origin], args[0][:size]
          when 2
            origin, size = args[0], args[1]
          when 4
            origin, size = [args[0], args[1]], [args[2], args[3]]
        end
        origin, size = MapPoint.new(origin), MapSize.new(size)
        @sdk = MKMapRectMake(origin.x, origin.y, size.width, size.height)
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