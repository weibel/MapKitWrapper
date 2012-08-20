module MapKit
  class MapType
    def self.mkmap_to_rmap(map_type)
      case map_type
        when MKMapTypeStandard
          :standard
        when MKMapTypeSatellite
          :satellite
        when MKMapTypeHybrid
          :hybrid
      end
    end

    def self.rmap_to_mkmap(map_type)
      case map_type
        when :standard
          MKMapTypeStandard
        when :satellite
          MKMapTypeSatellite
        when :hybrid
          MKMapTypeHybrid
      end
    end
  end
end