import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var messageService: MessageService
    @State private var showingCompose = false
    @State private var selectedMessage: BeaconMessage?
    @State private var proximityRadius: Double = 1000 // meters, default 1km
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.3),
                    Color(red: 0.2, green: 0.1, blue: 0.4),
                    Color(red: 0.15, green: 0.05, blue: 0.35)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HeaderView(proximityRadius: $proximityRadius)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Messages feed
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messageService.messages) { message in
                            MessageCard(message: message)
                                .onTapGesture {
                                    selectedMessage = message
                                }
                        }
                    }
                    .padding()
                }
                
                // Compose button
                Button(action: {
                    SoundManager.shared.playSound(.compose)
                    showingCompose = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Send Beacon")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.2, blue: 0.9),
                                Color(red: 0.4, green: 0.1, blue: 0.7)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0.6, green: 0.2, blue: 0.9).opacity(0.5), radius: 10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingCompose) {
            ComposeView(proximityRadius: proximityRadius)
                .environmentObject(messageService)
                .environmentObject(locationManager)
        }
        .sheet(item: $selectedMessage) { message in
            MessageDetailView(message: message)
                .environmentObject(messageService)
        }
        .onAppear {
            messageService.startListening(location: locationManager.currentLocation, radius: proximityRadius)
        }
        .onChange(of: proximityRadius) { newRadius in
            messageService.updateRadius(newRadius)
        }
    }
}

struct HeaderView: View {
    @Binding var proximityRadius: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("BEACON")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(Int(proximityRadius))m radius")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Menu {
                Button("50m") { proximityRadius = 50 }
                Button("100m") { proximityRadius = 100 }
                Button("250m") { proximityRadius = 250 }
                Button("500m") { proximityRadius = 500 }
                Button("1km") { proximityRadius = 1000 }
                Button("Custom") {
                    // Could add custom input here
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 12)
    }
}


