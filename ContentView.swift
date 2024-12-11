//
//  ContentView.swift
//  MapKitProject
//
//  Created by Adam R. Brown on 12/2/24.
//

import SwiftUI
import MapKit
import WeatherKit



struct ContentView: View {
    let GVSU = CLLocationCoordinate2D(latitude: 42.96_346,longitude: -85.88_868)
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 42.96_346,longitude: -85.88_868),
        span: .init(latitudeDelta: 4.5,longitudeDelta: 4.5)
    )
    
    var cameraPosition: MapCameraPosition { MapCameraPosition.region(region)
    }
    
    @StateObject var weatherManager = WeatherManager()
    
    let weatherService = WeatherService()
    
    @State var selectedLocal: CLLocationCoordinate2D? = nil
    
    class MapPin: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }
    
    
    var body: some View {
        VStack {
            MapReader { readMap in
                Map (position: .constant(cameraPosition), bounds: nil) {
                    Marker("GVSU", monogram: Text("GV"), coordinate: GVSU)
                    if let tappedLocation = selectedLocal {
                        Marker("\(tappedLocation.latitude), \(tappedLocation.longitude)", coordinate: tappedLocation)
                    }          
                }.edgesIgnoringSafeArea(.all).mapControls {
                        MapCompass()
                        MapScaleView()
                        MapUserLocationButton()
                    }.onTapGesture { position in
                        if let tappedLocation = readMap.convert(position, from: .local) {
                            print(tappedLocation)
                            selectedLocal = tappedLocation
                            let markerPlacement = MapPin(title: "Current Placement", coordinate: tappedLocation)
                            //MapView.addAnnotations([markerPlacement])
                            
                            Task {
                                await weatherManager.findWeather(location: tappedLocation)
                            }
                        }
                    }
            }
            
            Text("Current Weather:").font(.title)
            Image(systemName: weatherManager.symbol).shadow(radius: 2).padding()
            Text("It's \(weatherManager.condition)!")
            Text("\(weatherManager.temp)°")
            Text("\(weatherManager.humidity)% Humidity")
        }.onAppear {
            Task {
                await weatherManager.findWeather(location: GVSU)
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}

