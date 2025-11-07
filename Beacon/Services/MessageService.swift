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
    private let apiBaseURL = "http://localhost:3000/api" // Change to your server URL
    
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
        guard let location = currentLocation else { return }
        
        let url = URL(string: "\(apiBaseURL)/messages?lat=\(location.latitude)&lng=\(location.longitude)&radius=\(currentRadius)")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let messages = try JSONDecoder().decode([BeaconMessage].self, from: data)
                DispatchQueue.main.async {
                    self?.messages = messages.sorted { $0.timestamp > $1.timestamp }
                }
            } catch {
                print("Error decoding messages: \(error)")
            }
        }.resume()
    }
    
    func sendMessage(text: String, location: CLLocationCoordinate2D, radius: Double, completion: @escaping (Bool) -> Void) {
        let message = BeaconMessage(
            text: text,
            authorId: UUID().uuidString, // Anonymous ID
            location: location,
            proximityRadius: radius
        )
        
        guard let url = URL(string: "\(apiBaseURL)/messages") else {
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
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 201 {
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


