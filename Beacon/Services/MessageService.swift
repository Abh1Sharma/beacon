import Foundation
import CoreLocation
import Combine

class MessageService: ObservableObject {
    @Published var messages: [BeaconMessage] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Configuration
    // For local testing: "http://localhost:3000/api"
    // For device on same network: "http://YOUR_MAC_IP:3000/api" (e.g., "http://192.168.1.100:3000/api")
    // For deployed backend: "https://your-app-name.railway.app/api" (use HTTPS!)
    private let apiBaseURL = "https://beacon-backend-production.up.railway.app/api" // Deployed backend URL
    
    private var currentLocation: CLLocationCoordinate2D?
    private var currentRadius: Double = 1000
    
    func startListening(location: CLLocationCoordinate2D?, radius: Double) {
        guard let location = location else { return }
        currentLocation = location
        currentRadius = radius
        
        // Poll for new messages every 5 seconds
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchMessages()
            }
            .store(in: &cancellables)
        
        fetchMessages()
    }
    
    func updateRadius(_ radius: Double) {
        currentRadius = radius
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let location = currentLocation else {
            print("⚠️ [MessageService] Cannot fetch messages: No location available")
            return
        }
        
        let urlString = "\(apiBaseURL)/messages?lat=\(location.latitude)&lng=\(location.longitude)&radius=\(currentRadius)"
        guard let url = URL(string: urlString) else {
            print("❌ [MessageService] Invalid URL: \(urlString)")
            return
        }
        
        print("📡 [MessageService] Fetching messages from: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ [MessageService] Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [MessageService] Invalid response")
                return
            }
            
            print("📥 [MessageService] Response status: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ [MessageService] No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📦 [MessageService] Response data: \(responseString)")
            }
            
            do {
                let messages = try JSONDecoder().decode([BeaconMessage].self, from: data)
                print("✅ [MessageService] Decoded \(messages.count) messages")
                DispatchQueue.main.async {
                    self?.messages = messages.sorted { $0.timestamp > $1.timestamp }
                    print("✅ [MessageService] Updated UI with \(messages.count) messages")
                }
            } catch {
                print("❌ [MessageService] Error decoding messages: \(error)")
                if let decodingError = error as? DecodingError {
                    print("   Decoding error details: \(decodingError)")
                }
            }
        }.resume()
    }
    
    func sendMessage(text: String, location: CLLocationCoordinate2D, radius: Double, completion: @escaping (Bool) -> Void) {
        // Update current location so fetchMessages() can use it
        currentLocation = location
        currentRadius = radius
        
        let message = BeaconMessage(
            text: text,
            authorId: UUID().uuidString, // Anonymous ID
            location: location,
            proximityRadius: radius
        )
        
        guard let url = URL(string: "\(apiBaseURL)/messages") else {
            print("❌ [MessageService] Invalid URL for sending message")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(message)
            
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 [MessageService] Sending message: \(bodyString)")
            }
            print("📍 [MessageService] Location: lat=\(location.latitude), lng=\(location.longitude), radius=\(radius)")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("❌ [MessageService] Send error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ [MessageService] Invalid response when sending")
                    completion(false)
                    return
                }
                
                print("📥 [MessageService] Send response status: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 201 {
                    print("✅ [MessageService] Message sent successfully!")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("📦 [MessageService] Response: \(responseString)")
                    }
                    DispatchQueue.main.async {
                        print("🔄 [MessageService] Refreshing messages...")
                        self.fetchMessages()
                        completion(true)
                    }
                } else {
                    print("❌ [MessageService] Send failed with status: \(httpResponse.statusCode)")
                    if let data = data, let errorString = String(data: data, encoding: .utf8) {
                        print("📦 [MessageService] Error response: \(errorString)")
                    }
                    completion(false)
                }
            }.resume()
        } catch {
            print("❌ [MessageService] Encoding error: \(error)")
            completion(false)
        }
    }
    
    func sendReply(messageId: String, text: String, completion: @escaping (Bool) -> Void) {
        let reply = BeaconMessage.MessageReply(
            id: UUID().uuidString,
            text: text,
            authorId: UUID().uuidString,
            timestamp: Date()
        )
        
        guard let url = URL(string: "\(apiBaseURL)/messages/\(messageId)/replies") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(reply)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.fetchMessages()
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }.resume()
        } catch {
            completion(false)
        }
    }
}


