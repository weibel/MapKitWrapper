describe 'ZoomLevel' do
  before do
    @map = MapKit::MapView.new
    @map.delegate = self
    @map.frame = UIScreen.mainScreen.bounds
    @map.region = MapKit::CoordinateRegion.new([56, 10.6], [3.1, 3.1])
  end

  it 'should return coordinate_span_with_map_view' do
    span = MapKit::MapView.coordinate_span_with_map_view(@map, CLLocationCoordinate2DMake(56, 10), 2)
    span.latitudeDelta.should.equal 48.4522247314453
    span.longitudeDelta.should.equal 56.2499694824219
  end

  it 'should return set_center_coordinates' do
    @map.set_center_coordinates(CLLocationCoordinate2DMake(56, 10), 2, false)
    center = CoreLocation::DataTypes::LocationCoordinate.new(@map.region.center)
    span = MapKit::DataTypes::CoordinateSpan.new(@map.region.span)
    span.latitude_delta.should.equal 48.4522247314453
    span.longitude_delta.should.equal 56.25
    center.latitude.should.equal 56.0
    center.longitude.should.equal 10.0
    @map.set_center_coordinates(CLLocationCoordinate2DMake(0, 0), 50, false)
    @map.zoom_level.should.equal 18
  end

  it 'should return set_map_lat_lon' do
    @map.set_map_lat_lon(56, 10, 2, false)
    center = CoreLocation::DataTypes::LocationCoordinate.new(@map.region.center)
    span = MapKit::DataTypes::CoordinateSpan.new(@map.region.span)
    span.latitude_delta.should.equal 48.4522247314453
    span.longitude_delta.should.equal 56.25
    center.latitude.should.equal 56.0
    center.longitude.should.equal 10.0
  end

  it 'should return coordinate_region_with_map_view' do
    view = MKMapView.alloc.init
    view.frame = @map.frame
    center = CLLocationCoordinate2DMake(56, 10)
    region = MapKit::MapView.coordinate_region_with_map_view(view, center, 2)
    center = CoreLocation::DataTypes::LocationCoordinate.new(region.center)
    span = MapKit::DataTypes::CoordinateSpan.new(region.span)
    span.latitude_delta.should.equal 48.4522247314453
    span.longitude_delta.should.equal 56.2499694824219
    center.latitude.should.equal 56.0
    center.longitude.should.equal 10.0
  end

  it 'should have a zoom_level' do
    @map.zoom_level.should.equal 5.00000381469727
  end

  it 'should set a zoom_level' do
    @map.set_zoom_level(15, false)
    @map.zoom_level.should.equal 15
  end
end