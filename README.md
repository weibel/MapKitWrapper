MapKitWrapper
=============

This is a MapKit wrapper for RubyMotion. It's purpose is to make make dealing with MapKit less painful.

MapKitWrapper is work in progress. Right now there are wrappers for the Map Kit Data Types and the Core Location Data Types. Those will save you a lot of typing.

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

def loadView
  self.view = UIView.alloc.initWithFrame(tabBarController.view.bounds)
  map = MapView.new
  map.frame = self.view.frame
  map.delegate = self
  region = CoordinateRegion.new([56, 10.6], [3.1, 3.1])
  map.region = region
  # Alternatively use set_region
  # map.set_region(region, :animated => true)
  map.showsUserLocation = true
  self.view.addSubview(map)
  map.set_zoom_level = 3
end
```

## Wrappers for the Core Location Data Types

Include the classes
```ruby
include CoreLocation::DataTypes
```

### LocationCoordinate: The wrapper for CLLocationCoordinate2D

The `LocationCoordinate` initializer takes a variety of argument types
```ruby
LocationCoordinate.new(1,2)
LocationCoordinate.new([1,2])
LocationCoordinate.new(LocationCoordinate)
LocationCoordinate.new(CLLocationCoordinate2D)
```

Methods on `LocationCoordinate`
```ruby
>> lc = LocationCoordinate.new(1,2)
=> [1, 2]

>> lc.latitude
=> 1
>> lc.latitude = 10
=> 10

>> lc.longitude
=> 2
>> lc.longitude = 15
=> 15

>> lc.to_array
=> [10, 15]

>> lc.sdk
=> CLLocationCoordinate2D
```


Check if the users location has been found
```ruby
@map.user_located?
```    
Get the users coordinates
```ruby
@map.user_coordinates
```    

