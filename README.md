> This repository is no longer being actively maintained.<br>
> Kasper

MapKitWrapper
=============

This is a MapKit wrapper for RubyMotion. It's purpose is to make dealing with MapKit less painful.

MapKitWrapper is work in progress. Right now there are wrappers for the Map Kit Data Types and the Core Location Data Types. Those will save you a lot of typing.

The full documentation is here http://rubydoc.info/gems/map-kit-wrapper/0.0.5/frames

## Installation
```ruby
gem install map-kit-wrapper
```

## Setup

Edit the `Rakefile` of your RubyMotion project and add the following require line.

```ruby

require 'map-kit-wrapper'
```

## Example
```ruby
class FooViewController < UIViewController
	include MapKit
	def viewDidLoad
      super

	  map = MapView.new
	  map.frame = self.view.frame
	  map.delegate = self
	  map.region = CoordinateRegion.new([56, 10.6], [3.1, 3.1])
	  map.shows_user_location = true
	  view.addSubview(map)
	end
	
	#...
end
  

```

## MapView: Convenient subclass of MKMapView

Include the module
```ruby
include MapKit
```

Initializer

```ruby
MapView.new
```

### Methods on MapView

Zoom methods

```ruby
>> map = MapView.new
=> MapView
>> map.zoom_enabled?
=> false
>> map.zoom_enabled = true
=> true
```

Scroll methods

```ruby
>> map = MapView.new
=> MapView
>> map.scroll_enabled?
=> false
>> map.scroll_enabled = true
=> true
```

Location methods

```ruby
>> map.user_located?
=> false
>> map.shows_user_location?
=> false
>> map.user_coordinates
=> nil
>> map.shows_user_location = true
=> true
# wait for a bit
>> map.user_located?
=> true
>> map.user_coordinates
=> LocationCoordinate
```

### MapView zoom level methods

MapView includes calculations to easily get and set the zoom level as seen on Google Maps.
It's a Ruby adaption of http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/

```ruby
>> map.zoom_level
=> 5
>> map.set_zoom_level(13)
=> 13
# set the zoom level with animation
>> map.set_zoom_level(13, true)
=> 13
```

## Wrappers for the CoreLocation data types

Include the module

```ruby
include CoreLocation::DataTypes
```

### LocationCoordinate: The wrapper for CLLocationCoordinate2D

The `LocationCoordinate` initializer takes a variety of argument types

```ruby
LocationCoordinate.new(1,2)
LocationCoordinate.new([1,2])
LocationCoordinate.new({:latitude => 1, :longitude => 2})
LocationCoordinate.new(LocationCoordinate)
LocationCoordinate.new(CLLocationCoordinate2D)
```

Methods on `LocationCoordinate`

```ruby
>> lc = LocationCoordinate.new(1, 2)
=> [1, 2]
>> lc.latitude
=> 1
>> lc.latitude = 10
=> 10
>> lc.longitude
=> 2
>> lc.longitude = 15
=> 15
>> lc.to_a
=> [10, 15]
>> lc.to_h
=> {:latitude => 10, :longitude => 15}
>> lc.api
=> CLLocationCoordinate2D
```

## Wrappers for the MapKit data types

Include the module

```ruby
include MapKit::DataTypes
```

### CoordinateSpan: The wrapper for MKCoordinateSpan

The `CoordinateSpan` initializer takes a variety of argument types

```ruby
CoordinateSpan.new(1, 2)
CoordinateSpan.new([1, 2])
CoordinateSpan.new({:latitude_delta => 1, :longitude_delta => 2})
CoordinateSpan.new(CoordinateSpan)
CoordinateSpan.new(MKCoordinateSpan)
```

Methods on `CoordinateSpan`

```ruby
>> cs = CoordinateSpan.new(1, 2)
=> [1, 2]
>> cs.latitude_delta
=> 1
>> cs.longitude_delta
=> 2
>> cs.to_a
=> [1, 2]
>> cs.to_h
=> {:latitude_delta => 1, :longitude_delta => 2}
>> cs.api
=> MKCoordinateSpan
```

### CoordinateRegion: The wrapper for MKCoordinateRegion

The `CoordinateRegion` initializer takes a variety of argument types

```ruby
CoordinateRegion.new(CoordinateRegion)
CoordinateRegion.new(MKCoordinateRegion)
CoordinateRegion.new([56, 10.6], [3.1, 3.1])
CoordinateRegion.new({:center => {:latitude => 56, :longitude => 10.6}, :span => {:latitude_delta => 3.1, :longitude_delta => 5.1}})
CoordinateRegion.new(CLLocationCoordinate2D, MKCoordinateSpan)
CoordinateRegion.new(LocationCoordinate, CoordinateSpan)
```

Methods on `CoordinateRegion`

```ruby
>> cr = CoordinateRegion.new([56, 10.6], [3.1, 5.1])
=> {:center => [56, 10.6], :span => [3.1, 5.1]}
>> cs.center
=> LocationCoordinate([56, 10.6])
>> cs.region
=> CoordinateSpan([3.1, 5.1])
>> cs.to_h
=> {:center => {:latitude => 56, :longitude => 10.6}, :span => {:latitude_delta => 3.1, :longitude_delta => 5.1}}
>> cs.api
=> MKCoordinateRegion
```

### MapPoint: The wrapper for MKMapPoint

The `MapPoint` initializer takes a variety of argument types

```ruby
MapPoint.new(50, 45)
MapPoint.new([50, 45])
MapPoint.new({:x => 50, :y => 45})
MapPoint.new(MKMapPoint)
MapPoint.new(MapPoint)
```

Methods on `MapPoint`

```ruby
>> mp = MapPoint.new(50, 45)
=> [50, 45]
>> mp.x
=> 50
>> mp.y
=> 45
>> mp.to_a
=> [50, 45]
>> mp.to_h
=> {:x => 50, :y => 45}
>> mp.api
=> MKMapPoint
```

### MapSize: The wrapper for MKMapSize

The `MapSize` initializer takes a variety of argument types

```ruby
MapSize.new(10, 12)
MapSize.new([10, 12])
MapSize.new({:width => 50, :height => 45})
MapSize.new(MKMapSize)
MapSize.new(MapSize)
```

Methods on `MapSize`

```ruby
>> ms = MapSize.new(10, 12)
=> [10, 12]
>> ms.width
=> 10
>> ms.height
=> 12
>> ms.to_a
=> [50, 45]
>> ms.to_h
=> {:width => 50, :height => 45}
>> ms.api
=> MKMapSize
```

### MapRect: The wrapper for MKMapRect

The `MapRect` initializer takes a variety of argument types

```ruby
MapRect.new(x, y, width, height)
MapRect.new([x, y], [width, height])
MapRect.new({:origin => {:x => 2, :y => 3}, :size => {:width => 10, :height => 12}})
MapRect.new(MapPoint, MapSize)
MapRect.new(MKMapPoint, MKMapSize)
MapRect.new(MapRect)
MapRect.new(MKMapRect)
```

Methods on `MapRect`

```ruby
>> mr = MapRect.new(2, 3, 10, 12)
=> {:origin => [2, 3], :size => [10, 12]}
>> mr.origin
=> MapRect([2, 3])
>> mr.size
=> MapSize([10, 12])
>> mr.to_h
=> {:origin => {:x => 2, :y => 3}, :size => {:width => 10, :height => 12}}
>> mr.api
=> MKMapRect
```

