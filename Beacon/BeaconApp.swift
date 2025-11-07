import SwiftUI

@main
struct BeaconApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var messageService = MessageService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(messageService)
                .onAppear {
                    locationManager.requestLocationPermission()
                }
        }
    }
}


