##
# Wrappers for Core Location
#
module CoreLocation

  ##
  # Wrappers for the Core Location Data Types
  # http://developer.apple.com/library/mac/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html
  module DataTypes

    ##
    # Ruby wrapper for CLLocationCoordinate2D
    class LocationCoordinate

      ##
      # Attribute reader
      #
      attr_reader :latitude, :longitude

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
        CLLocationCoordinate2DMake(@latitude, @longitude)
      end

      ##
      # Setter for latitude
      #
      # * *Args*    :
      #   - +latitude+ -> Int or Float
      #
      def latitude=(latitude)
        @latitude = latitude.to_f
      end

      ##
      # Setter for longitude
      #
      # * *Args*    :
      #   - +longitude+ -> Int or Float
      #
      def longitude=(longitude)
        @longitude = longitude.to_f
      end

      ##
      # Get self as an Array
      #
      # * *Returns* :
      #   - <tt>[latitude, longitude]</tt>
      #
      def to_a
        [@latitude, @longitude]
      end

      ##
      # Get self as a Hash
      #
      # * *Returns* :
      #   - <tt>{:latitude => latitude, :longitude => longitude}</tt>
      #
      def to_h
        {:latitude => @latitude, :longitude => @longitude}
      end

      ##
      # Get self as a String
      #
      # * *Returns* :
      #   - <tt>"{:latitude => latitude, :longitude => longitude}"</tt>
      #
      def to_s
        to_h.to_s
      end
    end
  end
end