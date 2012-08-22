# require core_location_data_types
# require map_kit_data_types
# require zoom_level

module MapKit
  include CoreLocation::DataTypes
  include MapKit::DataTypes

  # Wrapper for MKMapView
  class MapView < MKMapView
    include CoreLocation::DataTypes
    include MapKit::DataTypes
    include MapKit::ZoomLevel

    def initialize
      self.alloc.init
    end

    # zoom methods

    def zoom_enabled?
      self.isZoomEnabled
    end

    def zoom_enabled=(enabled)
      self.setZoomEnabled(enabled)
    end

    # scroll methods

    def scroll_enabled?
      self.isScrollEnabled
    end

    def scroll_enabled=(enabled)
      self.setScrollEnabled(enabled)
    end

    # user location methods

    def shows_user_location?
      self.showsUserLocation
    end

    def shows_user_location=(enabled)
      self.showsUserLocation = enabled
    end

    def user_located?
      self.shows_user_location? && self.userLocation.location ? true : false
    end

    def user_coordinates
      self.user_located? ? LocationCoordinate.new(self.userLocation.location.coordinate) : nil
    end

    # region methods

    def get_region
      CoordinateRegion.new(self.region.center, self.region.span)
    end

    def region=(*args)
      self.set_region(CoordinateRegion.new(args.first), false)
    end

    def set_region(coordinate_region, *args)
      opts = {:animated => false}
      opts.merge!(args.first) if args.first
      self.setRegion(coordinate_region.sdk, animated:opts[:animated])
    end
  end
end