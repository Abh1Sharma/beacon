import Foundation
import AVFoundation
import AudioToolbox

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    enum SoundType {
        case compose
        case receive
        case send
        case tap
        
        var fileName: String {
            switch self {
            case .compose: return "compose"
            case .receive: return "receive"
            case .send: return "send"
            case .tap: return "tap"
            }
        }
    }
    
    private init() {}
    
    func playSound(_ type: SoundType) {
        // For MVP, we'll use system sounds
        // In production, you'd add custom sound files
        let systemSoundID: SystemSoundID
        
        switch type {
        case .compose:
            systemSoundID = 1104 // Mail sent sound
        case .receive:
            systemSoundID = 1000 // New mail sound
        case .send:
            systemSoundID = 1054 // Sent mail sound
        case .tap:
            systemSoundID = 1103 // Tink sound
        }
        
        AudioServicesPlaySystemSound(systemSoundID)
    }
}

