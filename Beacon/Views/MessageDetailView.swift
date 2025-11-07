import SwiftUI

struct MessageDetailView: View {
    let message: BeaconMessage
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var messageService: MessageService
    @State private var replyText = ""
    @State private var isSendingReply = false
    
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Original message
                        MessageCard(message: message)
                            .padding(.horizontal)
                        
                        // Replies section
                        if !message.replies.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Replies")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ForEach(message.replies) { reply in
                                    ReplyCard(reply: reply)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Reply input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add a reply")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack(spacing: 12) {
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 80)
                                    
                                    if replyText.isEmpty {
                                        Text("Type your reply...")
                                            .foregroundColor(.white.opacity(0.5))
                                            .padding()
                                    }
                                    
                                    TextEditor(text: $replyText)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.clear)
                                        .scrollContentBackground(.hidden)
                                }
                                
                                Button(action: sendReply) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title)
                                        .foregroundColor(
                                            replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                            ? Color.white.opacity(0.3)
                                            : Color(red: 0.6, green: 0.2, blue: 0.9)
                                        )
                                }
                                .disabled(replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSendingReply)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func sendReply() {
        let text = replyText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        isSendingReply = true
        SoundManager.shared.playSound(.send)
        
        messageService.sendReply(messageId: message.id, text: text) { success in
            isSendingReply = false
            if success {
                replyText = ""
                SoundManager.shared.playSound(.receive)
            }
        }
    }
}

struct ReplyCard: View {
    let reply: BeaconMessage.MessageReply
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.5, green: 0.2, blue: 0.8),
                            Color(red: 0.3, green: 0.1, blue: 0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .overlay(
                    Text("?")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Anonymous")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(reply.text)
                    .font(.body)
                    .foregroundColor(.white)
                
                Text(timeAgo(from: reply.timestamp))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


