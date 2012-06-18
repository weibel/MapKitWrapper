module MapKit
  # Ruby conversion of http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/
  module ZoomLevel
    include Math
    MERCATOR_OFFSET = 268435456
    MERCATOR_RADIUS = 85445659.44705395

    module ClassMethods
      include Math
      # Map conversion methods

      def longitude_to_pixel_space_x(longitude)
        (MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * PI / 180.0).round
      end

      def latitude_to_pixel_space_y(latitude)
        if latitude == 90.0
          0
        elsif latitude == -90.0
          MERCATOR_OFFSET * 2
        else
          (MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * PI / 180.0)) / (1 - sin(latitude * PI / 180.0))) / 2.0).round
        end
      end

      def pixel_space_x_to_longitude(pixel_x)
        (((pixel_x).round - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / PI
      end

      def pixel_space_y_to_latitude(pixel_y)
        (PI / 2.0 - 2.0 * atan(exp(((pixel_y).round - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / PI
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # Helper methods

    def coordinate_span_with_map_view(map_view, center_coordinate, zoom_level)
      # convert center coordiate to pixel space
      center_pixel_x = self.class.longitude_to_pixel_space_x(center_coordinate.longitude)
      center_pixel_y = self.class.latitude_to_pixel_space_y(center_coordinate.latitude)

      # determine the scale value from the zoom level
      zoom_exponent = 20 - zoom_level
      zoom_scale = 2 ** zoom_exponent

      # scale the map’s size in pixel space
      map_size_in_pixels = map_view.bounds.size
      scaled_map_width = map_size_in_pixels.width * zoom_scale
      scaled_map_height = map_size_in_pixels.height * zoom_scale

      # figure out the position of the top-left pixel
      top_left_pixel_x = center_pixel_x - (scaled_map_width / 2)
      top_left_pixel_y = center_pixel_y - (scaled_map_height / 2)

      # find delta between left and right longitudes
      min_lng = self.class.pixel_space_x_to_longitude(top_left_pixel_x)
      max_lng = self.class.pixel_space_x_to_longitude(top_left_pixel_x + scaled_map_width)
      longitude_delta = max_lng - min_lng

      # find delta between top and bottom latitudes
      min_lat = self.class.pixel_space_y_to_latitude(top_left_pixel_y)
      max_lat = self.class.pixel_space_y_to_latitude(top_left_pixel_y + scaled_map_height)
      latitude_delta = -1 * (max_lat - min_lat)

      # create and return the lat/lng span
      MKCoordinateSpanMake(latitude_delta, longitude_delta)
    end

    # Public methods

    def set_center_coordinate(center_coordinate, zoom_level, animated)
      # clamp large numbers to 28
      zoom_level = min(zoom_level, 28)

      # use the zoom level to compute the region
      span = coordinate_span_with_map_view(self, center_coordinate, zoom_level)
      region = MKCoordinateRegionMake(center_coordinate, span)

      # set the region like normal
      self.setRegion(region, animated: animated)
    end

    def set_map_lat(latitude, longitude, zoom, animated)
      c = CLLocationCoordinate2DMake(0, 0)
      c.latitude = latitude
      c.longitude = longitude
      self.setCenterCoordinate(c, zoomLevel: zoom, animated: animated)
    end


    # KMapView cannot display tiles that cross the pole
    # This would involve wrapping the map from top to bottom, something that a Mercator projection just cannot do.
    def coordinate_region_with_map_view(map_view, center_coordinate, zoom_level)

      # clamp lat/long values to appropriate ranges
      center_coordinate.latitude = min(max(-90.0, center_coordinate.latitude), 90.0)
      center_coordinate.longitude = center_coordinate.longitude % 180.0

      # convert center coordiate to pixel space
      center_pixel_x = self.class.longitude_to_pixel_space_x(center_coordinate.longitude)
      center_pixel_y = self.class.latitude_to_pixel_space_y(center_coordinate.latitude)

      # determine the scale value from the zoom level
      zoom_exponent = 20 - zoom_level
      zoom_scale = 2 ** zoom_exponent

      # scale the map’s size in pixel space
      map_size_in_pixels = map_view.bounds.size
      scaled_map_width = map_size_in_pixels.width * zoom_scale
      scaled_map_height = map_size_in_pixels.height * zoom_scale

      # figure out the position of the left pixel
      top_left_pixel_x = center_pixel_x - (scaled_map_width / 2)

      # find delta between left and right longitudes
      min_lng = self.class.pixel_space_x_to_longitude(top_left_pixel_x)
      max_lng = self.class.pixel_space_x_to_longitude(top_left_pixel_x + scaled_map_width)
      longitude_delta = max_lng - min_lng

      # if we’re at a pole then calculate the distance from the pole towards the equator
      # as MKMapView doesn’t like drawing boxes over the poles
      top_pixel_y = center_pixel_y - (scaled_map_height / 2)
      bottom_pixel_y = center_pixel_y + (scaled_map_height / 2)
      adjusted_center_point = false
      if top_pixel_y > MERCATOR_OFFSET * 2
        top_pixel_y = center_pixel_y - scaled_map_height
        bottom_pixel_y = MERCATOR_OFFSET * 2
        adjusted_center_point = true
      end

      # find delta between top and bottom latitudes
      min_lat = self.class.pixel_space_y_to_latitude(top_pixel_y)
      max_lat = self.class.pixel_space_y_to_latitude(bottom_pixel_y)
      latitude_delta = -1 * (max_lat - min_lat)

      # create and return the lat/lng span
      span = MKCoordinateSpanMake(latitude_delta, longitude_delta)
      region = MKCoordinateRegionMake(center_coordinate, span)
      # once again, MKMapView doesn’t like drawing boxes over the poles
      # so adjust the center coordinate to the center of the resulting region
      if adjusted_center_point
        region.center.latitude = self.class.pixel_space_y_to_latitude((bottom_pixel_y + top_pixel_y) / 2.0)
      end

      region
    end

    def zoom_level
      region = self.region

      center_pixel_x = self.class.longitude_to_pixel_space_x(region.center.longitude)
      top_left_pixel_x = self.class.longitude_to_pixel_space_x(region.center.longitude - region.span.longitudeDelta / 2)

      scaled_map_width = (center_pixel_x - top_left_pixel_x) * 2
      map_size_in_pixels = self.bounds.size
      zoom_scale = scaled_map_width / map_size_in_pixels.width
      zoom_exponent = log(zoom_scale) / log(2)
      zoom_level = 20 - zoom_exponent
      zoom_level
    end

  end
end