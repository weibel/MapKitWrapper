#= require base_data_types
#= require map_kit_data_types

##
# Wrappers for Core Location
#
module CoreLocation

  ##
  # Wrappers for the Core Location Data Types
  # http://developer.apple.com/library/mac/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html
  module DataTypes
    include BaseDataTypes

    ##
    # Ruby wrapper for CLLocationCoordinate2D
    class LocationCoordinate < Vector
      ##
      # Attribute aliases
      #
      alias :latitude :x
      alias :longitude :y
      alias :latitude= :x=
      alias :longitude= :y=

      ##
      # Initializer for LocationCoordinate
      #
      # * *Args*    :
      # The initializer takes a variety of arguments
      #
      #    LocationCoordinate.new(1,2)
      #    LocationCoordinate.new([1,2])
      #    LocationCoordinate.new({:latitude => 1, :longitude => 2})
      #    LocationCoordinate.new(LocationCoordinate)
      #    LocationCoordinate.new(CLLocationCoordinate2D)
      #
      def initialize(*args)
        args.flatten!
        self.latitude, self.longitude =
            case args.size
              when 1
                arg = args.first
                if arg.is_a? Hash
                  [arg[:latitude], arg[:longitude]]
                else
                  # For LocationCoordinate, CLLocationCoordinate2D
                  [arg.latitude, arg.longitude]
                end
              when 2
                [args[0], args[1]]
            end
      end

      ##
      # Returns the wrapped iOS CLLocationCoordinate2D object
      def api
        CLLocationCoordinate2DMake(latitude, longitude)
      end

      ##
      # Clamp coordinates to appropriate mercator values
      #
      # * *Returns* :
      #   - LocationCoordinate
      #
      def mercator_limit
        LocationCoordinate.new([[-90.0, latitude].max, 90.0].min, longitude % 180.0)
      end

      ##
      # Convert self to pixel space
      #
      # * *Returns* :
      #   - MapKit::DataTypes::MapPoint
      #
      def to_pixel_space
        MapKit::DataTypes::MapPoint.new(LocationCoordinate.longitude_to_pixel_space_x(longitude),
                                        LocationCoordinate.latitude_to_pixel_space_y(latitude))
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:latitude => latitude, :longitude => longitude}</tt>
      #
      def to_h
        {:latitude => latitude, :longitude => longitude}
      end

      private

      ##
      # Convert longitude to pixel space x
      #
      # * *Args*    :
      #   - +longitude+ -> Int or Float
      #
      # * *Returns* :
      #   - Pixel space x as Int
      #
      def self.longitude_to_pixel_space_x(longitude)
        (BaseDataTypes::Vector::MERCATOR_OFFSET + BaseDataTypes::Vector::MERCATOR_RADIUS * longitude * Math::PI / 180.0).round
      end

      ##
      # Convert latitude to pixel space y
      #
      # * *Args*    :
      #   - +latitude+ -> Int or Float
      #
      # * *Returns* :
      #   - Pixel space y as Int
      #
      def self.latitude_to_pixel_space_y(latitude)
        if latitude == 90.0
          0
        elsif latitude == -90.0
          BaseDataTypes::Vector::MERCATOR_OFFSET * 2
        else
          (BaseDataTypes::Vector::MERCATOR_OFFSET - BaseDataTypes::Vector::MERCATOR_RADIUS * Math.log((1 + Math.sin(latitude * Math::PI / 180.0)) / (1 - Math.sin(latitude * Math::PI / 180.0))) / 2.0).round
        end
      end
    end
  end
end