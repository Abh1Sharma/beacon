import SwiftUI
import CoreLocation

struct ComposeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var messageService: MessageService
    @EnvironmentObject var locationManager: LocationManager
    @State private var messageText = ""
    @State private var isSending = false
    let proximityRadius: Double
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.0, blue: 0.3),
                        Color(red: 0.2, green: 0.1, blue: 0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header info
                    VStack(spacing: 8) {
                        Text("Send a Beacon")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Visible to people within \(Int(proximityRadius))m")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top)
                    
                    // Text input
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 200)
                        
                        if messageText.isEmpty {
                            Text("What's on your mind?")
                                .foregroundColor(.white.opacity(0.5))
                                .padding()
                        }
                        
                        TextEditor(text: $messageText)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.6, green: 0.2, blue: 0.9),
                                        Color(red: 0.4, green: 0.1, blue: 0.7)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                    )
                    
                    Spacer()
                    
                    // Send button
                    Button(action: sendMessage) {
                        HStack {
                            if isSending {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "paperplane.fill")
                                    .font(.title3)
                            }
                            Text(isSending ? "Sending..." : "Send Beacon")
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
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                    .opacity(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func sendMessage() {
        guard let location = locationManager.currentLocation else {
            return
        }
        
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        isSending = true
        SoundManager.shared.playSound(.compose)
        
        messageService.sendMessage(text: text, location: location, radius: proximityRadius) { success in
            isSending = false
            if success {
                SoundManager.shared.playSound(.send)
                dismiss()
            }
        }
    }
}


