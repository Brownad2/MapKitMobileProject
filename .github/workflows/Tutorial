# Overview:
My project focused on MapKit. I will be showing how to create an interactive map that places points where the user taps.

## Getting Started:
There were a few discerepancies I found when doing research for my app and what actually worked to implement. The main change that MapKit developers are pushing for currently is how you create your map. While there are many constructors that take variables that control the starting placement and zoom of the map as well as other options to create the map that fits your app, what is being pushed by the creators of MapKit is instead using MapCameraPositions to create the starting outline over a region. 

# Step-by-Step-Process
To start with, we want to create the variables that define our map initially. While all you need to make your map is just Map(), having the ability to tailor the starting locaton can be helpful for you and your users. To do this, I first defined the starting display region and subsiquent MapCameraPosition. For this example, my code centers around GVSU's coordinates. 

```
 @State var region = MKCoordinateRegion(
        center: .init(latitude: 42.96_346, longitude: -85.88_868),
        span: .init(latitudeDelta: 4.5,longitudeDelta: 4.5)
    )
    
  var cameraPosition: MapCameraPosition { 
    MapCameraPosition.region(region)
   }
```

With these basic parameters defined, we can make our map display.

```
 Map (position: .constant(cameraPosition), bounds: nil)
```

Created maps can have a lot of functionality added to them quite easily in MapKit. For instance, in my code, I wanted the map to expand to fill the space more so I added to the end of the map:

```
.edgesIgnoringSafeArea(.all)
```

Another great example of simple and intuitive functionality to add is with `mapControls`. Map controls encompass every espect that a user could want, from changing the pitch of the map, to adding a button that centers on the user's location, to adding a compass feature. Here are a few you can add as an example, (`MapZoomStepper` may be flagged to take out as it is only availible for Mac's running your app):

```
.mapControls {
  MapCompass
  MapPitchToggle 
  MapScaleView 
  MapUserLocationButton 
  MapZoomStepper
}
```

Further ways you can customize your map include the design itself, which you can change to make look realistic, account for realistic heights, and even toggle on and off road markers etc. All this can be done using the `.mapStyle` suffix:

```
// Imagery uses realistic textures and removes road icons
.mapStyle(.imagery(elevation: .realistic)
// Hybrid uses the realistic style but still keeps the road information
.mapStyle(.hybrid)
```

Enough with the map beautification, lets get some more information on our map by inserting a `Marker`. To do this, we just need the longitude and latitude coordinates of where we want to place our marker. To add a marker at GVSU, we make a `CLLocationCoordinate2D` at the place we want. Then all we have to do is add that `CLLocationCoordinate2D` as a marker:

```
let GVSU = CLLocationCoordinate2D(latitude: 42.96_346,longitude: -85.88_868)

Map() {
  Marker("GVSU", monogram: Text("GV"), coordinate: GVSU)
}
```

As you can see, markers have loads of customization options as well, being able to select things like the name, the image, or monogram if you want initials in the pin. Even the color can be changed with `.tint(.`*color*`)`

This stationary marker is neat, but we want one to appear when we press on the map. For that, we have to make sure the Map is in a MapReader. This will allow us to see where the user taps. 

```
MapReader { readMap in
                Map (position: .constant(cameraPosition), bounds: nil) 
          }
```

We also need to define our pin. For this case, we only care about the coordinate and a name for each point.

```
class MapPin: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }
```

Next, we'll add the actual funcinality to when a tap occurs. We do this by adding:

```
Map (position: .constant(cameraPosition), bounds: nil) {
        if let tappedLocation = selectedLocal {
            Marker("\(tappedLocation.latitude), \(tappedLocation.longitude)", coordinate: tappedLocation)
        }
    }.onTapGesture { position in
        if let tappedLocation = readMap.convert(position, from: .local) {
        print(tappedLocation) // prints out the coordinates of where they tapped
        selectedLocal = tappedLocation
        let markerPlacement = MapPin(title: "Current Placement", coordinate: tappedLocation)
        }
    }
```

To break this down. We detect the tap, grab the position of the tap and use our MapReader to find the coordinates of that place on screen. We then have a marker declared directly after the map is created that places the marker on the tapped location's coordinates everytime the tappedLocation is changed. With all the additions together, we get this:

```
class MapPin: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }

var body: some View {
        MapReader { readMap in
              Map (position: .constant(cameraPosition), bounds: nil) {
                    Marker("GVSU", monogram: Text("GV"), coordinate: GVSU)
                    if let tappedLocation = selectedLocal {
                        Marker("\(tappedLocation.latitude), \(tappedLocation.longitude)", coordinate: tappedLocation)
                    }          
              }.onTapGesture { position in
                    if let tappedLocation = readMap.convert(position, from: .local) {
                        print(tappedLocation)
                        selectedLocal = tappedLocation
                        let markerPlacement = MapPin(title: "Current Placement", coordinate: tappedLocation)
                    }
            }
  }
```

## Conclusion

Now we've occicially created a point that shows the coordinates for wherever the user taps on the map. With all the customization MapKit allows, there is still plenty you could do to make this your own, or expand on this idea. There are many ways to insert markers on tap like we did, this was just the way I found to work the best. Hopefully you have learned something and enjoyed a breif dip into MapKit!

# See Also

While doing my project, I mostly used the easily accessable man pages for to learn about MapKit's many functions, but there are so many great tutorials online for placing points on user input like I said above, as well as just basic map design.


Project Presentation Links:

Video - https://youtu.be/QIEqOVsI3PY

Slides - https://docs.google.com/presentation/d/1j-WdBZsOfCMTWXMwBab2cKBN9x-gCKkq-WWt9nYAsQI/edit?usp=sharing
