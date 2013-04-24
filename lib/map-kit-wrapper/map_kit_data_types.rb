#= require core_location_data_types

module MapKit
  ##
  # Wrappers for the Map Kit Data Types
  # http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
  module DataTypes
    ##
    # Wrapper for MKCoordinateSpan
    class CoordinateSpan
      attr_reader :latitude_delta, :longitude_delta
      ##
      # CoordinateSpan.new(1,2)
      # CoordinateSpan.new([1,2])
      # CoordinateSpan.new({:latitude_delta => 1, :longitude_delta => 2})
      # CoordinateSpan.new(CoordinateSpan)
      # CoordinateSpan.new(MKCoordinateSpan)
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

      def sdk
        MKCoordinateSpanMake(@latitude_delta, @longitude_delta)
      end

      def latitude_delta=(delta)
        @latitude_delta = delta.to_f
      end

      def longitude_delta=(delta)
        @longitude_delta = delta.to_f
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

      def sdk
        MKCoordinateRegionMake(@center.sdk, @span.sdk)
      end

      def center=(center)
        @center = LocationCoordinate.new(center)
      end

      def span=(span)
        @span = CoordinateSpan.new(span)
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
      attr_reader :x, :y
      ##
      # MapPoint.new(50,45)
      # MapPoint.new([50,45])
      # MapPoint.new({:x => 50, :y => 45})
      # MapPoint.new(MKMapPoint)
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

      def sdk
        MKMapPointMake(@x, @y)
      end

      def x=(x)
        @x = x.to_f
      end

      def y=(y)
        @y = y.to_f
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
      attr_reader :width, :height
      ##
      # MapSize.new(10,12)
      # MapSize.new([10,12])
      # MapSize.new({:width => 10, :height => 12})
      # MapSize.new(MKMapSize)
      # MapSize.new(MapSize)
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

      def sdk
        MKMapSizeMake(@width, @height)
      end

      def width=(width)
        @width = width.to_f
      end

      def height=(height)
        @height = height.to_f
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
      # MapRect.new(MapRect)
      # MapRect.new(MKMapRect)
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