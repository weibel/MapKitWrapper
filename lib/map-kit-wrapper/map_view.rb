#= require core_location_data_types
#= require map_kit_data_types
#= require zoom_level

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
    # Set the maps region
    #
    #    region = CoordinateRegion.new([56, 10.6], [3.1, 3.1])
    #    region = {:region => CoordinateRegion.new([56, 10.6], [3.1, 3.1]), :animated => false}
    def region=(args)
      case args
        when Hash
          self.setRegion(CoordinateRegion.new(args[:region]).api, animated: args[:animated])
        else
          self.setRegion(CoordinateRegion.new(args).api, animated: false)
      end
    end

    def set_region
      raise 'set_region has been deprecated. Please review the docs on region=()'
    end

    module OverriddenMethods
      include MapKit::DataTypes
      ##
      # Get the maps region
      def region
        CoordinateRegion.new(super)
      end
    end

    include OverriddenMethods
  end
end