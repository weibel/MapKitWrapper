module CoreLocation
  # Wrappers for the Core Location Data Types
  # http://developer.apple.com/library/mac/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html
  module DataTypes

    # Ruby wrapper for CLLocationCoordinate2D
    class LocationCoordinate
      attr_reader :sdk

      # LocationCoordinate.new(1,2)
      # LocationCoordinate.new([1,2])
      # LocationCoordinate.new(LocationCoordinate)
      # LocationCoordinate.new(CLLocationCoordinate2D)
      def initialize(*args)
        latitude, longitude = nil, nil
        args.flatten!
        if args.size == 1
          arg = args.first
          if arg.is_a?(CLLocationCoordinate2D)
            latitude, longitude = arg.latitude, arg.longitude
          elsif arg.is_a?(LocationCoordinate)
            latitude, longitude = arg.sdk.latitude, arg.sdk.longitude
          end
        elsif args.size == 2
          latitude, longitude = args[0], args[1]
        end
        @sdk = CLLocationCoordinate2DMake(latitude, longitude)
      end

      def latitude
        @sdk.latitude
      end

      def latitude=(latitude)
        @sdk.latitude = latitude
      end

      def longitude
        @sdk.longitude
      end

      def longitude=(longitude)
        @sdk.longitude = longitude
      end

      def to_array
        [latitude, longitude]
      end
    end
  end
end