MapKitWrapper
=============

This is a MapKit wrapper for RubyMotion. It's purpose is to make make dealing with MapKit less painfull

It is still work in progress, but right now there are wrappers for the Map Kit Data Types and the Core Location Data Types. Those will save you a lot of typing.

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
end
```    
Check if the users location has been found
```ruby
@map.user_located?
```    
Get the users coordinates
```ruby
@map.user_coordinates
```    
## Setup

Check out MapKitWrapper in the app folder and insert the following in your rakefile
```ruby
app.files =  Dir.glob(File.join(app.project_dir, 'app/MapKitWrapper/**/*.rb')) | Dir.glob(File.join(app.project_dir, 'app/**/*.rb'))
app.frameworks += ['CoreLocation', 'MapKit']
```
