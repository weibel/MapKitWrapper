module CoreLocation
  # Wrappers for the Core Location Data Types
  # http://developer.apple.com/library/mac/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html
  module DataTypes

    # Ruby wrapper for CLLocationCoordinate2D
    class LocationCoordinate
      attr_reader :sdk

      # LocationCoordinate.new(1,2)
      # LocationCoordinate.new([1,2])
      # CoordinateSpan.new(CLLocationCoordinate2D)
      def initialize(*args)
        args.flatten!
        if args.first.is_a?(CLLocationCoordinate2D)
          @sdk = args.first
        else
          @sdk = CLLocationCoordinate2DMake(args[0], args[1])
        end
      end

      def latitude
        @sdk.latitude
      end

      def longitude
        @sdk.longitude
      end

      def to_array
        [latitude, longitude]
      end
    end
  end
end