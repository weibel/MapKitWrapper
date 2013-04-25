#= require core_location_data_types

##
# Wrappers for MapKit
#
module MapKit

  ##
  # Wrappers for the Map Kit Data Types
  # http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
  module DataTypes
    include BaseDataTypes

    ##
    # Wrapper for MKCoordinateSpan
    class CoordinateSpan < Vector

      ##
      # Attribute aliases
      #
      alias :latitude_delta :x
      alias :latitude_delta= :x=
      alias :longitude_delta :y
      alias :longitude_delta= :y=

      ##
      # Initializer for CoordinateSpan
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    CoordinateSpan.new(1,2)
      #    CoordinateSpan.new([1,2])
      #    CoordinateSpan.new({:latitude_delta => 1, :longitude_delta => 2})
      #    CoordinateSpan.new(CoordinateSpan)
      #    CoordinateSpan.new(MKCoordinateSpan)
      def initialize(*args)
        args.flatten!
        self.latitude_delta, self.longitude_delta =
            case args.size
              when 1
                arg = args.first
                case arg
                  when MKCoordinateSpan
                    [arg.latitudeDelta, arg.longitudeDelta]
                  when CoordinateSpan
                    [arg.latitude_delta, arg.longitude_delta]
                  when Hash
                    [arg[:latitude_delta], arg[:longitude_delta]]
                end
              when 2
                [args[0], args[1]]
            end
      end

      ##
      # Returns the wrapped iOS MKCoordinateSpan object
      #
      # * *Returns* :
      #   - A MKCoordinateSpan representation of self
      #
      def api
        MKCoordinateSpanMake(latitude_delta, longitude_delta)
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:latitude_delta => latitude_delta, :longitude_delta => longitude_delta}</tt>
      #
      def to_h
        {:latitude_delta => latitude_delta, :longitude_delta => longitude_delta}
      end
    end

    ##
    # Wrapper for MKCoordinateRegion
    class CoordinateRegion
      include CoreLocation::DataTypes

      ##
      # Attribute reader
      #
      attr_reader :center, :span

      ##
      # Initializer for CoordinateRegion
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    CoordinateRegion.new(CoordinateRegion)
      #    CoordinateRegion.new(MKCoordinateRegion)
      #    CoordinateRegion.new([56, 10.6], [3.1, 3.1])
      #    CoordinateRegion.new({:center => {:latitude => 56, :longitude => 10.6}, :span => {:latitude_delta => 3.1, :longitude_delta => 3.1}})
      #    CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
      #    CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
      #
      def initialize(*args)
        self.center, self.span =
            case args.size
              when 1
                arg = args[0]
                case arg
                  when Hash
                    [arg[:center], arg[:span]]
                  else
                    [arg.center, arg.span]
                end
              when 2
                [args[0], args[1]]
            end
      end

      ##
      # Returns the wrapped iOS MKCoordinateRegion object
      #
      # * *Returns* :
      #   - A MKCoordinateRegion representation of self
      #
      def api
        MKCoordinateRegionMake(@center.api, @span.api)
      end

      ##
      # Assigns a CoreLocation::DataTypes::LocationCoordinate to center.
      #
      # * *Args* :
      #   - +center+ -> accepts a variety of argument types. See docs for the CoreLocation::DataTypes::LocationCoordinate initializer
      #
      def center=(center)
        @center = LocationCoordinate.new(center)
      end

      ##
      # Assigns a MapKit::DataTypes::CoordinateSpan to span
      #
      # * *Args* :
      #   - +span+ -> accepts a variety of argument types. See docs for the MapKit::DataTypes::CoordinateSpan initializer
      #
      def span=(span)
        @span = CoordinateSpan.new(span)
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:center => {:latitude => latitude, :longitude => longitude}, :span => {:latitude_delta => latitude_delta, :longitude_delta => longitude_delta}}</tt>
      #
      def to_h
        {:center => @center.to_h, :span => @span.to_h}
      end

      ##
      # Get self as a String
      #
      # * *Returns* :
      #   - <tt>"{:center => {:latitude => latitude, :longitude => longitude}, :span => {:latitude_delta => latitude_delta, :longitude_delta => longitude_delta}}"</tt>
      #
      def to_s
        to_h.to_s
      end
    end

    ##
    # Wrapper for MKMapPoint
    class MapPoint < Vector

      ##
      # Initializer for MapPoint
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    MapPoint.new(50,45)
      #    MapPoint.new([50,45])
      #    MapPoint.new({:x => 50, :y => 45})
      #    MapPoint.new(MapPoint)
      #    MapPoint.new(MKMapPoint)
      #
      def initialize(*args)
        args.flatten!
        self.x, self.y =
            case args.size
              when 1
                arg = args[0]
                case arg
                  when Hash
                    [arg[:x], arg[:y]]
                  else
                    [arg.x, arg.y]
                end
              when 2
                [args[0], args[1]]
            end
      end

      ##
      # Returns the wrapped iOS MKMapPoint object
      #
      # * *Returns* :
      #   - A MKMapPoint representation of self
      #
      def api
        MKMapPointMake(x, y)
      end

      ##
      # Convert self to location space
      #
      # * *Returns* :
      #   - CoreLocation::LocationCoordinate
      #
      def to_location_space
        CoreLocation::DataTypes::LocationCoordinate.new(MapPoint.pixel_space_x_to_longitude(x),
                                                        MapPoint.pixel_space_y_to_latitude(y))
      end

      private

      ##
      # Convert pixel space x to longitude
      #
      # * *Args*    :
      #   - +pixel_x+ -> Int
      #
      # * *Returns* :
      #   - Longitude as float
      #
      def self.pixel_space_x_to_longitude(pixel_x)
        ((pixel_x.round - BaseDataTypes::Vector::MERCATOR_OFFSET) / BaseDataTypes::Vector::MERCATOR_RADIUS) * 180.0 / Math::PI
      end

      ##
      # Convert pixel space y to latitude
      #
      # * *Args*    :
      #   - +pixel_y+ -> Int
      #
      # * *Returns* :
      #   - Latitude as float
      #
      def self.pixel_space_y_to_latitude(pixel_y)
        (Math::PI / 2.0 - 2.0 * Math.atan(Math.exp((pixel_y.round - BaseDataTypes::Vector::MERCATOR_OFFSET) / BaseDataTypes::Vector::MERCATOR_RADIUS))) * 180.0 / Math::PI
      end
    end

    ##
    # Wrapper for MKMapSize
    class MapSize < Vector

      ##
      # Attribute aliases
      #
      alias :width :x
      alias :width= :x=
      alias :height :y
      alias :height= :y=

      ##
      # Initializer for MapSize
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    MapSize.new(10,12)
      #    MapSize.new([10,12])
      #    MapSize.new({:width => 10, :height => 12})
      #    MapSize.new(MKMapSize)
      #    MapSize.new(MapSize)
      #
      def initialize(*args)
        args.flatten!
        self.width, self.height =
            case args.size
              when 1
                arg = args[0]
                case arg
                  when Hash
                    [arg[:width], arg[:height]]
                  else
                    [arg.width, arg.height]
                end
              when 2
                [args[0], args[1]]
            end
      end

      ##
      # Returns the wrapped iOS MKMapSize object
      #
      # * *Returns* :
      #   - A MKMapSize representation of self
      #
      def api
        MKMapSizeMake(width, height)
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:width => width, :height => height}</tt>
      #
      def to_h
        {:width => width, :height => height}
      end
    end

    ##
    # Wrapper for MKMapRect
    class MapRect

      ##
      # Attribute reader
      #
      attr_reader :origin, :size

      ##
      # Initializer for MapRect
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    MapRect.new(x, y, width, height)
      #    MapRect.new([x, y], [width, height])
      #    MapRect.new({:origin => {:x => 5.0, :y => 8.0}, :size => {:width => 6.0, :height => 9.0}})
      #    MapRect.new(MapPoint, MapSize)
      #    MapRect.new(MKMapPoint, MKMapSize)
      #    MapRect.new(MapRect)
      #    MapRect.new(MKMapRect)
      #
      def initialize(*args)
        self.origin, self.size =
            case args.size
              when 1
                arg = args[0]
                case arg
                  when Hash
                    [arg[:origin], arg[:size]]
                  else
                    [arg.origin, arg.size]
                end
              when 2
                [args[0], args[1]]
              when 4
                [[args[0], args[1]], [args[2], args[3]]]
            end
      end

      ##
      # Returns the wrapped iOS MKMapRect object
      #
      # * *Returns* :
      #   - A MKMapRect representation of self
      #
      def api
        MKMapRectMake(@origin.x, @origin.y, @size.width, @size.height)
      end

      ##
      # Assigns a MapKit::DataTypes::MapPoint to center.
      #
      # * *Args* :
      #   - +origin+ -> accepts a variety of argument types. See docs for the MapKit::DataTypes::MapPoint initializer
      #
      def origin=(origin)
        @origin = MapPoint.new(origin)
      end

      ##
      # Assigns a MapKit::DataTypes::MapSize to center.
      #
      # * *Args* :
      #   - +size+ -> accepts a variety of argument types. See docs for the MapKit::DataTypes::MapSize initializer
      #
      def size=(size)
        @size = MapSize.new(size)
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:origin => {:x => x, :y => y}, :size => {:width => width, :height => height}}</tt>
      #
      def to_h
        {:origin => @origin.to_h, :size => @size.to_h}
      end

      ##
      # Get self as a String
      #
      # * *Returns* :
      #   - <tt>"{:origin => {:x => x, :y => y}, :size => {:width => width, :height => height}}"</tt>
      #
      def to_s
        to_h.to_s
      end
    end
  end
end