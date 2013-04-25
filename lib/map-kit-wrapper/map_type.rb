##
# Wrappers for MapKit
#
module MapKit

  ##
  # Class for dealing with MKMapView map type constants
  #
  class MapType

    ##
    # Convert from MKMapView to MapView
    #
    # * *Args*    :
    #   - +map_type+ -> Map type as MKMapView constant
    #
    # * *Returns* :
    #   - map type as symbol
    #
    def self.mkmap_to_rmap(map_type)
      case map_type
        when MKMapTypeStandard
          :standard
        when MKMapTypeSatellite
          :satellite
        when MKMapTypeHybrid
          :hybrid
        else
          raise "Unknown map type: #{map_type.inspect}"
      end
    end

    ##
    # Convert from MapView to MKMapView
    #
    # * *Args*    :
    #   - +map_type+ -> Map type as symbol
    #
    # * *Returns* :
    #   - Map type as MKMapView constant
    #
    def self.rmap_to_mkmap(map_type)
      case map_type
        when :standard
          MKMapTypeStandard
        when :satellite
          MKMapTypeSatellite
        when :hybrid
          MKMapTypeHybrid
        else
          raise "Unknown map type: #{map_type.inspect}"
      end
    end
  end
end