module CoreLocation
  ##
  # Wrappers for the Core Location Data Types
  # http://developer.apple.com/library/mac/#documentation/CoreLocation/Reference/CoreLocationDataTypesRef/Reference/reference.html
  module DataTypes
    ##
    # Ruby wrapper for CLLocationCoordinate2D
    class LocationCoordinate
      attr_accessor :latitude, :longitude

      ##
      # LocationCoordinate.new(1,2)
      # LocationCoordinate.new([1,2])
      # LocationCoordinate.new({:latitude => 1, :longitude => 2})
      # LocationCoordinate.new(LocationCoordinate)
      # LocationCoordinate.new(CLLocationCoordinate2D)
      def initialize(*args)
        args.flatten!
        case args.size
          when 1
            arg = args.first
            if arg.is_a? Hash
              latitude, longitude = arg[:latitude], arg[:longitude]
            else
              # For LocationCoordinate, CLLocationCoordinate2D
              latitude, longitude = arg.latitude, arg.longitude
            end
          when 2
            latitude, longitude = args[0], args[1]
        end
        @latitude, @longitude = latitude.to_f, longitude.to_f
        self
      end

      def sdk
        CLLocationCoordinate2DMake(@latitude, @longitude)
      end

      def to_a
        [@latitude, @longitude]
      end

      def to_h
        {:latitude => @latitude, :longitude => @longitude}
      end

      def to_s
        to_h.to_s
      end
    end
  end
end