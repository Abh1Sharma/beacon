import Foundation
import CoreLocation

struct BeaconMessage: Identifiable, Codable {
    let id: String
    let text: String
    let authorId: String
    let location: LocationCoordinate
    let timestamp: Date
    let proximityRadius: Double // meters
    var replies: [MessageReply]
    
    struct LocationCoordinate: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    struct MessageReply: Identifiable, Codable {
        let id: String
        let text: String
        let authorId: String
        let timestamp: Date
    }
    
    init(id: String = UUID().uuidString,
         text: String,
         authorId: String,
         location: CLLocationCoordinate2D,
         proximityRadius: Double,
         timestamp: Date = Date(),
         replies: [MessageReply] = []) {
        self.id = id
        self.text = text
        self.authorId = authorId
        self.location = LocationCoordinate(latitude: location.latitude, longitude: location.longitude)
        self.proximityRadius = proximityRadius
        self.timestamp = timestamp
        self.replies = replies
    }
}


