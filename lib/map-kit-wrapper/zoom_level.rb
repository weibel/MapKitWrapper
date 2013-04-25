module MapKit

  ##
  # Ruby adaption of http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/
  #
  # More here http://troybrant.net/blog/2010/01/mkmapview-and-zoom-levels-a-visual-guide/
  #
  module ZoomLevel
    include Math
    include CoreLocation::DataTypes
    include MapKit::DataTypes

    ##
    # Map conversion methods
    #
    module ClassMethods
      include Math
      include CoreLocation::DataTypes
      include MapKit::DataTypes

      ##
      # Get the coordiante span for the given zoom level
      #
      # * *Args*    :
      #   - +map_view+ -> A MKMapView
      #   - +center_coordinates+ -> Coordinates as MKMapPoint
      #   - +zoom_level+ -> Zoom level as Int
      #
      # * *Returns* :
      #   - Span as MKCoordinateSpan
      #
      def coordinate_span_with_map_view(map_view, center_coordinate, zoom_level)
        # determine the scale value from the zoom level
        zoom_exponent = 20 - zoom_level
        zoom_scale = 2 ** zoom_exponent

        # scale the map’s size in pixel space
        scaled_map_size = MapSize.new(map_view.bounds.size) * zoom_scale

        # figure out the position of the top-left pixel
        top_left_pixel = LocationCoordinate.new(center_coordinate).to_pixel_space - (scaled_map_size / 2)

        # convert center coordinates to location space and find the span between them
        top_left_coordinate = top_left_pixel.to_location_space
        bottom_right_coordinate = (top_left_pixel + scaled_map_size).to_location_space
        span = bottom_right_coordinate.span_to(top_left_coordinate)

        # create and return the lat/lng span
        CoordinateSpan.new(span.y, span.x).api
      end

      ##
      # Get the coordiante region for the given zoom level
      #
      # * *Args*    :
      #   - +map_view+ -> A MKMapView
      #   - +center_coordinates+ -> Coordinates as MKMapPoint
      #   - +zoom_level+ -> Zoom level as Int
      #
      # * *Returns* :
      #   - Region as MKCoordinateRegion
      #
      def coordinate_region_with_map_view(map_view, center_coordinate, zoom_level)
        center_coordinate = LocationCoordinate.new(center_coordinate).mercator_limit
        center_pixel = center_coordinate.to_pixel_space

        # determine the scale value from the zoom level
        zoom_exponent = 20 - zoom_level
        zoom_scale = 2 ** zoom_exponent

        # scale the map’s size in pixel space
        scaled_map_size = (MapSize.new(map_view.bounds.size) * zoom_scale)

        # figure out the position of the corner pixels
        top_left_pixel = center_pixel - (scaled_map_size / 2)
        bottom_right_pixel = top_left_pixel + scaled_map_size

        # if we’re at a pole then calculate the distance from the pole towards the equator
        # as MKMapView doesn’t like drawing boxes over the poles
        adjusted_center_point = false
        if top_left_pixel.y > BaseDataTypes::Vector::MERCATOR_OFFSET * 2
          top_left_pixel.y = center_pixel.y - scaled_map_size.height
          bottom_right_pixel.y = BaseDataTypes::Vector::MERCATOR_OFFSET * 2
          adjusted_center_point = true
        end

        # find delta between left and right longitudes
        # convert center coordinates to location space and find the span between them
        top_left_coordinate = top_left_pixel.to_location_space
        bottom_right_coordinate = bottom_right_pixel.to_location_space
        span = bottom_right_coordinate.span_to(top_left_coordinate)

        # create and return the lat/lng span
        span = CoordinateSpan.new(span.y, span.x)

        # once again, MKMapView doesn’t like drawing boxes over the poles
        # so adjust the center coordinate to the center of the resulting region
        if adjusted_center_point
          center_coordinate.latitude = (top_left_coordinate + (span / 2)).latitude
        end

        CoordinateRegion.new(center_coordinate, span).api
      end
    end

    ##
    # Include class methods
    #
    def self.included(base)
      base.extend(ClassMethods)
    end

    ##
    # Set the views center coordinates with a given zoom level
    #
    # * *Args*    :
    #   - +center_coordinate+ -> A MKMapPoint
    #   - +zoom_level+ -> Zoom level as Int
    #   - +animated+ -> bool
    #
    def set_center_coordinates(center_coordinate, zoom_level, animated = false)
      # clamp large numbers to 18
      zoom_level = [zoom_level, 18].min

      # use the zoom level to compute the region
      span = self.class.coordinate_span_with_map_view(self, center_coordinate, zoom_level)
      region = CoordinateRegion.new(center_coordinate, span)

      # set the region like normal
      self.setRegion(region.api, animated: animated)
    end

    ##
    # Set the views latitude and longitude with a given zoom level
    #
    # * *Args*    :
    #   - +latitude+ -> Float
    #   - +longitude+ -> Float
    #   - +zoom_level+ -> Zoom level as Int
    #   - +animated+ -> bool
    #
    def set_map_lat_lon(latitude, longitude, zoom_level, animated = false)
      coordinate = LocationCoordinate.new(latitude, longitude)
      set_center_coordinates(coordinate, zoom_level, animated)
    end

    ##
    # Get the current zoom level
    #
    # * *Returns* :
    #   - Zoom level as a Float
    #
    def zoom_level
      region = self.region
      center_pixel = region.center.to_pixel_space
      top_left_pixel = (region.center - (region.span / 2)).to_pixel_space

      scaled_map_width = (center_pixel.x - top_left_pixel.x) * 2
      map_size_in_pixels = MapSize.new(self.bounds.size)

      zoom_scale = scaled_map_width / map_size_in_pixels.width
      zoom_exponent = log(zoom_scale) / log(2)
      20 - zoom_exponent
    end

    ##
    # Set the current zoom level
    #
    # * *Args*    :
    #   - +zoom_level+ -> Int or Float
    #   - +animated+ -> Bool
    #
    def set_zoom_level(zoom_level, animated = false)
      set_center_coordinates(self.region.center, zoom_level, animated)
    end

  end
end