#= require core_location_data_types

module MapKit
  ##
  # Wrappers for the Map Kit Data Types
  # http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
  module DataTypes
    ##
    # Wrapper for MKCoordinateSpan
    class CoordinateSpan
      attr_accessor :latitude_delta, :longitude_delta
      ##
      # CoordinateSpan.new(1,2)
      # CoordinateSpan.new([1,2])
      # CoordinateSpan.new({:latitude_delta => 1, :longitude_delta => 2})
      # CoordinateSpan.new(CoordinateSpan)
      # CoordinateSpan.new(MKCoordinateSpan)
      def initialize(*args)
        args.flatten!
        case args.size
          when 1
            arg = args.first
            case arg
              when MKCoordinateSpan
                latitude_delta, longitude_delta = arg.latitudeDelta, arg.longitudeDelta
              when CoordinateSpan
                latitude_delta, longitude_delta = arg.latitude_delta, arg.longitude_delta
              when Hash
                latitude_delta, longitude_delta = arg[:latitude_delta], arg[:longitude_delta]
            end
          when 2
            latitude_delta, longitude_delta = args[0], args[1]
        end
        @latitude_delta, @longitude_delta = latitude_delta.to_f, longitude_delta.to_f
        self
      end

      def sdk
        MKCoordinateSpanMake(@latitude_delta, @longitude_delta)
      end

      def to_a
        [@latitude_delta, @longitude_delta]
      end

      def to_h
        {:latitude_delta => @latitude_delta, :longitude_delta => @longitude_delta}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKCoordinateRegion
    class CoordinateRegion
      include CoreLocation::DataTypes
      attr_reader :center, :span
      ##
      # CoordinateRegion.new(CoordinateRegion)
      # CoordinateRegion.new(MKCoordinateRegion)
      # CoordinateRegion.new([56, 10.6], [3.1, 3.1])
      # CoordinateRegion.new({:center => {:latitude => 56, :longitude => 10.6}, :span => {:latitude_delta => 3.1, :longitude_delta => 3.1}}
      # CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
      # CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
      def initialize(*args)
        case args.size
          when 1
            arg = args[0]
            case arg
              when Hash
                center, span = arg[:center], arg[:span]
              else
                center, span = arg.center, arg.span
            end
          when 2
            center, span = args[0], args[1]
        end
        self.center, self.span = center, span
      end

      def center=(center)
        @center = LocationCoordinate.new(center)
      end

      def span=(span)
        @span = CoordinateSpan.new(span)
      end

      def sdk
        MKCoordinateRegionMake(@center.sdk, @span.sdk)
      end

      def to_h
        {:center => @center.to_h, :span => @span.to_h}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKMapPoint
    class MapPoint
      attr_accessor :x, :y
      ##
      # MapPoint.new(50,45)
      # MapPoint.new([50,45])
      # MapPoint.new({:x => 50, :y => 45})
      # MapPoint.new(MKMapPoint)
      def initialize(*args)
        args.flatten!
        case args.size
          when 1
            arg = args[0]
            case arg
              when Hash
                @x, @y = arg[:x], arg[:y]
              else
                @x, @y = arg.x, arg.y
            end
          when 2
            @x, @y = args[0], args[1]
        end
      end

      def sdk
        MKMapPointMake(@x, @y)
      end

      def to_a
        [@x, @y]
      end

      def to_h
        {:x => @x, :y => @y}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKMapSize
    class MapSize
      attr_accessor :width, :height
      ##
      # MapSize.new(10,12)
      # MapSize.new([10,12])
      # MapSize.new({:width => 10, :height => 12})
      # MapSize.new(MKMapSize)
      def initialize(*args)
        args.flatten!
        case args.size
          when 1
            arg = args[0]
            case arg
              when Hash
                @width, @height = arg[:width], arg[:height]
              else
                @width, @height = arg.width, arg.height
            end
          when 2
            @width, @height = args[0], args[1]
        end
      end

      def sdk
        MKMapSizeMake(@width, @height)
      end

      def to_a
        [@width, @height]
      end

      def to_h
        {:width => @width, :height => @height}
      end

      def to_s
        to_h.to_s
      end
    end
    ##
    # Wrapper for MKMapRect
    class MapRect
      attr_reader :origin, :size
      ##
      # MapRect.new(x, y, width, height)
      # MapRect.new([x, y], [width, height])
      # MapRect.new({:origin => {:x => 5.0, :y => 8.0}, :size => {:width => 6.0, :height => 9.0}})
      # MapRect.new(MapPoint, MapSize)
      # MapRect.new(MKMapPoint, MKMapSize)
      def initialize(*args)
        case args.size
          when 1
            origin, size = args[0][:origin], args[0][:size]
          when 2
            origin, size = args[0], args[1]
          when 4
            origin, size = [args[0], args[1]], [args[2], args[3]]
        end
        self.origin, self.size = origin, size
      end

      def sdk
        MKMapRectMake(@origin.x, @origin.y, @size.width, @size.height)
      end

      def origin=(origin)
        @origin = MapPoint.new(origin)
      end

      def size=(size)
        @size = MapSize.new(size)
      end

      def to_h
        {:origin => @origin.to_h, :size => @size.to_h}
      end

      def to_s
        to_h.to_s
      end
    end
  end
end