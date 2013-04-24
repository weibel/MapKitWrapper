describe 'MapKitDataTypes' do
  describe 'CoordinateSpan' do
    before do
      o_1 = MapKit::DataTypes::CoordinateSpan.new(5, 8)
      o_2 = MapKit::DataTypes::CoordinateSpan.new([5, 8])
      o_3 = MapKit::DataTypes::CoordinateSpan.new(MKCoordinateSpanMake(5, 8))
      o_4 = MapKit::DataTypes::CoordinateSpan.new(o_1)
      @array = [o_1, o_2, o_3, o_4]
    end

    it 'should return the latitude delta' do
      @array.each do |o|
        o.latitude_delta.should.equal 5
      end
    end

    it 'should return the longitude delta' do
      @array.each do |o|
        o.longitude_delta.should.equal 8
      end
    end

    it 'should return an array' do
      @array.each do |o|
        o.to_a.should.equal [5, 8]
      end
    end

    it 'should return a hash' do
      @array.each do |o|
        o.to_h.should.equal({:latitude_delta => 5.0, :longitude_delta => 8.0})
      end
    end

    it 'should contain a MKCoordinateSpan' do
      @array.each do |o|
        o.sdk.is_a?(MKCoordinateSpan).should.equal true
      end
    end
  end

  describe 'CoordinateRegion' do
    before do
      lc = CoreLocation::DataTypes::LocationCoordinate.new(5, 8)
      cs = MapKit::DataTypes::CoordinateSpan.new(6, 9)
      mkcr = MKCoordinateRegionMake(CLLocationCoordinate2DMake(5, 8), MKCoordinateSpanMake(6, 9))
      o_1 = MapKit::DataTypes::CoordinateRegion.new([5, 8], [6, 9])
      o_2 = MapKit::DataTypes::CoordinateRegion.new(lc, cs)
      o_3 = MapKit::DataTypes::CoordinateRegion.new(CLLocationCoordinate2DMake(5, 8), MKCoordinateSpanMake(6, 9))
      o_4 = MapKit::DataTypes::CoordinateRegion.new(mkcr)
      o_5 = MapKit::DataTypes::CoordinateRegion.new(o_1)
      @array = [o_1, o_2, o_3, o_4, o_5]
    end

    it 'should return the center' do
      @array.each do |o|
        o.center.is_a?(CoreLocation::DataTypes::LocationCoordinate).should.equal true
        o.center.latitude.should.equal 5
        o.center.longitude.should.equal 8
      end
    end

    it 'should return the span' do
      @array.each do |o|
        o.span.is_a?(MapKit::DataTypes::CoordinateSpan).should.equal true
        o.span.latitude_delta.should.equal 6
        o.span.longitude_delta.should.equal 9
      end
    end

    it 'should return a hash' do
      @array.each do |o|
        o.to_h.should.equal({:center => {:latitude => 5.0, :longitude => 8.0}, :span => {:latitude_delta => 6.0, :longitude_delta => 9.0}})
      end
    end

    it 'should contain a MKCoordinateRegion' do
      @array.each do |o|
        o.sdk.is_a?(MKCoordinateRegion).should.equal true
      end
    end
  end

  describe 'MapPoint' do
    before do
      o_1 = MapKit::DataTypes::MapPoint.new(5, 8)
      o_2 = MapKit::DataTypes::MapPoint.new([5, 8])
      o_3 = MapKit::DataTypes::MapPoint.new(MKMapPointMake(5, 8))
      @array = [o_1, o_2, o_3]
    end

    it 'should return the x' do
      @array.each do |o|
        o.x.should.equal 5
      end
    end

    it 'should return the y' do
      @array.each do |o|
        o.y.should.equal 8
      end
    end

    it 'should return an array' do
      @array.each do |o|
        o.to_a.should.equal [5, 8]
      end
    end

    it 'should return a hash' do
      @array.each do |o|
        o.to_h.should.equal({:x => 5.0, :y => 8.0})
      end
    end

    it 'should contain a MKMapPoint' do
      @array.each do |o|
        o.sdk.is_a?(MKMapPoint).should.equal true
      end
    end
  end

  describe 'MapSize' do
    before do
      o_1 = MapKit::DataTypes::MapSize.new(5, 8)
      o_2 = MapKit::DataTypes::MapSize.new([5, 8])
      o_3 = MapKit::DataTypes::MapSize.new(MKMapSizeMake(5, 8))
      @array = [o_1, o_2, o_3]
    end

    it 'should return the width' do
      @array.each do |o|
        o.width.should.equal 5
      end
    end

    it 'should return the height' do
      @array.each do |o|
        o.height.should.equal 8
      end
    end

    it 'should return an array' do
      @array.each do |o|
        o.to_a.should.equal [5, 8]
      end
    end

    it 'should return a hash' do
      @array.each do |o|
        o.to_h.should.equal({:width => 5.0, :height => 8.0})
      end
    end

    it 'should contain a MKMapSize' do
      @array.each do |o|
        o.sdk.is_a?(MKMapSize).should.equal true
      end
    end
  end

  describe 'MapRect' do
    before do
      mp = MapKit::DataTypes::MapPoint.new(5, 8)
      ms = MapKit::DataTypes::MapSize.new(6, 9)
      o_1 = MapKit::DataTypes::MapRect.new(5, 8, 6, 9)
      o_2 = MapKit::DataTypes::MapRect.new([5, 8], [6, 9])
      o_3 = MapKit::DataTypes::MapRect.new(mp, ms)
      o_4 = MapKit::DataTypes::MapRect.new(MKMapPointMake(5, 8), MKMapSizeMake(6, 9))
      @array = [o_1, o_2, o_3, o_4]
    end

    it 'should return the origin' do
      @array.each do |o|
        o.origin.is_a?(MapKit::DataTypes::MapPoint).should.equal true
        o.origin.x.should.equal 5
        o.origin.y.should.equal 8
      end
    end

    it 'should return the size' do
      @array.each do |o|
        o.size.is_a?(MapKit::DataTypes::MapSize).should.equal true
        o.size.width.should.equal 6
        o.size.height.should.equal 9
      end
    end

    it 'should return a hash' do
      @array.each do |o|
        o.to_h.should.equal({:origin => {:x => 5.0, :y => 8.0}, :size => {:width => 6.0, :height => 9.0}})
      end
    end

    it 'should contain a MKMapRect' do
      @array.each do |o|
        o.sdk.is_a?(MKMapRect).should.equal true
      end
    end
  end
end