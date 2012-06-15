module MapKit
  # Ruby conversion of http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/
  module ZoomLevel
    MERCATOR_OFFSET = 268435456
    MERCATOR_RADIUS = 85445659.44705395

    # Map conversion methods

    def self.longitude_to_pixel_space_x(longitude)
      round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * PI / 180.0)
    end

    def self.latitude_to_pixel_space_y(latitude)
      if latitude == 90.0
        0
      elsif latitude == -90.0
        MERCATOR_OFFSET * 2
      else
        round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * PI / 180.0)) / (1 - sin(latitude * PI / 180.0))) / 2.0)
      end
    end

    def self.pixel_space_x_to_longitude(pixel_x)
      ((round(pixel_x) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / PI
    end

    def self.pixel_space_y_to_latitude(pixel_y)
      (PI / 2.0 - 2.0 * atan(exp((round(pixel_y) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / PI
    end

    # Helper methods

    def coordinate_span_with_map_view(map_view, center_coordinate, zoom_level)
      # convert center coordiate to pixel space
      center_pixel_x = self.class.longitude_to_pixel_space_x(center_coordinate.longitude)
      center_pixel_y = self.class.latitude_to_pixel_space_y(center_coordinate.latitude)

      # determine the scale value from the zoom level
      zoom_exponent = 20 - zoom_level
      zoom_scale = 2^zoom_exponent

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

=begin
-(void)setMapLat:(CGFloat)latitude
             lon:(CGFloat)longitude
            zoom:(CGFloat)zoom
        animated:(BOOL)animated
{
    CLLocationCoordinate2D c;
    c.latitude =  latitude;
    c.longitude = longitude;
    [self setCenterCoordinate:c zoomLevel:zoom animated:animated];
}

//KMapView cannot display tiles that cross the pole (as these would involve wrapping the map from top to bottom, something that a Mercator projection just cannot do).
-(MKCoordinateRegion)coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                    andZoomLevel:(NSUInteger)zoomLevel
{
  // clamp lat/long values to appropriate ranges
  centerCoordinate.latitude = MIN(MAX(-90.0, centerCoordinate.latitude), 90.0);
  centerCoordinate.longitude = fmod(centerCoordinate.longitude, 180.0);

  // convert center coordiate to pixel space
  double centerPixelX = [MKMapView longitudeToPixelSpaceX:centerCoordinate.longitude];
  double centerPixelY = [MKMapView latitudeToPixelSpaceY:centerCoordinate.latitude];

  // determine the scale value from the zoom level
  NSInteger zoomExponent = 20 - zoomLevel;
  double zoomScale = pow(2, zoomExponent);

  // scale the map’s size in pixel space
  CGSize mapSizeInPixels = mapView.bounds.size;
  double scaledMapWidth = mapSizeInPixels.width * zoomScale;
  double scaledMapHeight = mapSizeInPixels.height * zoomScale;

  // figure out the position of the left pixel
  double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);

  // find delta between left and right longitudes
  CLLocationDegrees minLng = [MKMapView pixelSpaceXToLongitude:topLeftPixelX];
  CLLocationDegrees maxLng = [MKMapView pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
  CLLocationDegrees longitudeDelta = maxLng - minLng;

  // if we’re at a pole then calculate the distance from the pole towards the equator
  // as MKMapView doesn’t like drawing boxes over the poles
  double topPixelY = centerPixelY - (scaledMapHeight / 2);
  double bottomPixelY = centerPixelY + (scaledMapHeight / 2);
  BOOL adjustedCenterPoint = NO;
  if (topPixelY > MERCATOR_OFFSET * 2) {
    topPixelY = centerPixelY - scaledMapHeight;
    bottomPixelY = MERCATOR_OFFSET * 2;
    adjustedCenterPoint = YES;
  }

  // find delta between top and bottom latitudes
  CLLocationDegrees minLat = [MKMapView pixelSpaceYToLatitude:topPixelY];
  CLLocationDegrees maxLat = [MKMapView pixelSpaceYToLatitude:bottomPixelY];
  CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);

  // create and return the lat/lng span
  MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
  MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
  // once again, MKMapView doesn’t like drawing boxes over the poles
  // so adjust the center coordinate to the center of the resulting region
  if (adjustedCenterPoint) {
    region.center.latitude = [MKMapView pixelSpaceYToLatitude:((bottomPixelY + topPixelY) / 2.0)];
  }

  return region;
}

- (NSUInteger) zoomLevel {
    MKCoordinateRegion region = self.region;

    double centerPixelX = [MKMapView longitudeToPixelSpaceX: region.center.longitude];
    double topLeftPixelX = [MKMapView longitudeToPixelSpaceX: region.center.longitude - region.span.longitudeDelta / 2];

    double scaledMapWidth = (centerPixelX - topLeftPixelX) * 2;
    CGSize mapSizeInPixels = self.bounds.size;
    double zoomScale = scaledMapWidth / mapSizeInPixels.width;
    double zoomExponent = log(zoomScale) / log(2);
    double zoomLevel = 20 - zoomExponent;

    return zoomLevel;
}
=end

  end
end