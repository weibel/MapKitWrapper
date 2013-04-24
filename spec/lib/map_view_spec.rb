describe 'MapView' do
  before do
    @map = MapKit::MapView.new
    @map.delegate = self
    @map.frame = UIScreen.mainScreen.bounds
    @map.region = MapKit::CoordinateRegion.new([56, 10.6], [3.1, 3.1])
    @map.zoom_enabled = false
    @map.scroll_enabled = false
  end

  it 'should initialize' do
    @map.should.satisfy { |object| object.is_a? MapKit::MapView }
  end

  # zoom

  it 'should show zoom_enabled?' do
    @map.zoom_enabled?.should.equal false
  end

  it 'should set zoom_enabled' do
    @map.zoom_enabled = true
    @map.zoom_enabled?.should.equal true
  end

  # scroll

  it 'should show scroll_enabled?' do
    @map.scroll_enabled?.should.equal false
  end

  it 'should show zoom_enabled' do
    @map.scroll_enabled = true
    @map.scroll_enabled?.should.equal true
  end

  # user location

  it 'should show shows_user_location?' do
    @map.shows_user_location?.should.equal false
  end

  it 'should set shows_user_location' do
    @map.shows_user_location = true
    @map.shows_user_location?.should == true
  end

  it 'should show user_located?' do
    @map.user_located?.should.equal false
    @map.shows_user_location = true
    #wait 10 do
    #  @map.user_located?.should.equal true
    #end
  end

  it 'should show user_coordinates' do
    @map.user_coordinates.should.equal nil
    @map.shows_user_location = true
    #wait 10 do
    #  @map.user_coordinates.latitude.should.equal 56
    #end
  end

  # region

  it 'should show get_region' do
    @map.region.should.satisfy { |object| object.is_a? MapKit::DataTypes::CoordinateRegion }
  end

  it 'should set region=' do
    @map.region = MapKit::CoordinateRegion.new([56, 10.6], [3.1, 3.1])
    @map.region.should.satisfy { |object| object.is_a? MapKit::DataTypes::CoordinateRegion }
  end

  it 'should set region = (coordinate_region, *args)' do
    @map.region = {:region => MapKit::CoordinateRegion.new([56, 10.6], [3.1, 3.1]), :animated => false}
    @map.region.should.satisfy { |object| object.is_a? MapKit::DataTypes::CoordinateRegion }
  end

end