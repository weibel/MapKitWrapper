describe 'LocationCoordinate' do
  before do
    lc_1 = CoreLocation::DataTypes::LocationCoordinate.new(5, 8)
    lc_2 = CoreLocation::DataTypes::LocationCoordinate.new([5, 8])
    lc_3 = CoreLocation::DataTypes::LocationCoordinate.new(CLLocationCoordinate2DMake(5, 8))
    lc_4 = CoreLocation::DataTypes::LocationCoordinate.new(lc_3)
    lc_5 = CoreLocation::DataTypes::LocationCoordinate.new({:latitude => 5, :longitude => 8})
    @array = [lc_1, lc_2, lc_3, lc_4, lc_5]
  end

  it 'should return the latitude' do
    @array.each do |lc|
      lc.latitude.should.equal 5
    end
  end

  it 'should assign the latitude' do
    @array.each do |lc|
      lc.latitude = 10
      lc.latitude.should.equal 10
    end
  end

  it 'should return the longitude' do
    @array.each do |lc|
      lc.longitude.should.equal 8
    end
  end

  it 'should assign the longitude' do
    @array.each do |lc|
      lc.longitude = 10
      lc.longitude.should.equal 10
    end
  end

  it 'should return an array' do
    @array.each do |lc|
      lc.to_a.should.equal [5, 8]
    end
  end

  it 'should return a hash' do
    @array.each do |lc|
      lc.to_h.should.equal({:latitude => 5, :longitude => 8})
    end
  end

  it 'should return a string' do
    @array.each do |lc|
      lc.to_s.should.equal '{:latitude=>5.0, :longitude=>8.0}'
    end
  end

  it 'should contain a CLLocationCoordinate2D' do
    @array.each do |lc|
      lc.api.is_a?(CLLocationCoordinate2D).should.equal true
    end
  end
end