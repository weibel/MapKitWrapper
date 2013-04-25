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

    ##
    # Initializer for MapView
    #
    def initialize
      self.alloc.init
    end

    ##
    # Is zoom enabled
    #
    # * *Returns* :
    #   - Bool
    #
    def zoom_enabled?
      self.isZoomEnabled
    end

    ##
    # Set zoom on/off
    #
    # * *Args*    :
    #   - +enabled+ -> Bool
    #
    def zoom_enabled=(enabled)
      self.setZoomEnabled(enabled)
    end

    ##
    # Is scroll enbabled?
    #
    # * *Returns* :
    #   - Bool
    #
    def scroll_enabled?
      self.isScrollEnabled
    end

    ##
    # Set scroll on/off
    #
    # * *Args*    :
    #   - +enabled+ -> Bool
    #
    def scroll_enabled=(enabled)
      self.setScrollEnabled(enabled)
    end

    ##
    # Is the users location shown on the map
    #
    # * *Returns* :
    #   - Bool
    #
    def shows_user_location?
      self.showsUserLocation
    end

    ##
    # Set visible user location on/off
    #
    # * *Args*    :
    #   - +enabled+ -> Bool
    #
    def shows_user_location=(enabled)
      self.showsUserLocation = enabled
    end

    ##
    # Has the user been located yet?
    #
    # * *Returns* :
    #   - Bool
    #
    def user_located?
      self.shows_user_location? && self.userLocation.location ? true : false
    end

    ##
    # Show the users coordinates. Defaults to nil if the functionality is turned off or the location has not yet been found
    #
    # * *Returns* :
    #   - LocationCoordinate
    #
    def user_coordinates
      self.user_located? ? LocationCoordinate.new(self.userLocation.location.coordinate) : nil
    end

    ##
    # Set the maps region
    #
    # * *Args*    :
    #    region = CoordinateRegion.new([56, 10.6], [3.1, 3.1])
    #    region = {:region => CoordinateRegion.new([56, 10.6], [3.1, 3.1]), :animated => false}
    #
    def region=(args)
      case args
        when Hash
          self.setRegion(CoordinateRegion.new(args[:region]).api, animated: args[:animated])
        else
          self.setRegion(CoordinateRegion.new(args).api, animated: false)
      end
    end

    ##
    # Deprecated
    #
    def set_region
      raise 'set_region has been deprecated. Please review the docs on region=()'
    end

    ##
    # Trick to override methods on the iOS APi and to get super on those methods
    #
    module OverriddenMethods
      include MapKit::DataTypes
      ##
      # Get the maps region
      #
      # * *Returns* :
      #   - CoordinateRegion
      #
      def region
        CoordinateRegion.new(super)
      end
    end

    include OverriddenMethods
  end
end