# require core_location_data_types
# require map_kit_data_types
# require zoom_level

module MapKit
  include CoreLocation::DataTypes
  include MapKit::DataTypes

  ##
  # Wrapper for MKMapView
  class MapView < MKMapView
    include CoreLocation::DataTypes
    include MapKit::DataTypes
    include MapKit::ZoomLevel

    def initialize
      self.alloc.init
    end

    ##
    # Show if zoom is enabled
    def zoom_enabled?
      self.isZoomEnabled
    end

    ##
    # Set zoom on/off
    def zoom_enabled=(enabled)
      self.setZoomEnabled(enabled)
    end

    ##
    # Show if scroll is enbaled
    def scroll_enabled?
      self.isScrollEnabled
    end

    ##
    # Set scroll on/off
    def scroll_enabled=(enabled)
      self.setScrollEnabled(enabled)
    end

    ##
    # Show if the users location is on the map
    def shows_user_location?
      self.showsUserLocation
    end

    ##
    # Set visible user location on/off
    def shows_user_location=(enabled)
      self.showsUserLocation = enabled
    end

    ##
    # Show if the users has been located yet
    def user_located?
      self.shows_user_location? && self.userLocation.location ? true : false
    end

    ##
    # Show the users coordinates
    # defaults to nil if the functionality is turned off
    # or the location has not yet been found
    def user_coordinates
      self.user_located? ? LocationCoordinate.new(self.userLocation.location.coordinate) : nil
    end

    ##
    # Get the maps region
    def get_region
      CoordinateRegion.new(self.region.center, self.region.span)
    end

    ##
    # Set the maps region
    def region=(*args)
      self.set_region(CoordinateRegion.new(args.first), false)
    end

    ##
    # Set the maps region including animation
    def set_region(coordinate_region, *args)
      opts = {:animated => false}
      opts.merge!(args.first) if args.first
      self.setRegion(coordinate_region.sdk, animated: opts[:animated])
    end
  end
end