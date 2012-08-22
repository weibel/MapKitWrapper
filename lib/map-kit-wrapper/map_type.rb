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
        else
          raise "Unknown map type: #{map_type.inspect}"
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
        else
          raise "Unknown map type: #{map_type.inspect}"
      end
    end
  end
end