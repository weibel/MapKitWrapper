describe 'ZoomLevel' do
  before do
    @map = MapKit::MapView.new
    @map.delegate = self
    @map.frame = UIScreen.mainScreen.bounds
    @map.region = MapKit::CoordinateRegion.new([56, 10.6], [3.1, 3.1])
  end

  it 'should return longitude_to_pixel_space_x' do
    MapKit::MapView.longitude_to_pixel_space_x(30).should.equal 313174656
  end

  it 'should return latitude_to_pixel_space_y' do
    MapKit::MapView.latitude_to_pixel_space_y(90).should.equal 0
    MapKit::MapView.latitude_to_pixel_space_y(-90).should.equal 536870912
    MapKit::MapView.latitude_to_pixel_space_y(180).should.equal 268435392
  end
end