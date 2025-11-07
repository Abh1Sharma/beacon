import SwiftUI

struct MessageCard: View {
    let message: BeaconMessage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Anonymous avatar
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.8, green: 0.3, blue: 0.9),
                                Color(red: 0.5, green: 0.2, blue: 0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Anonymous")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(timeAgo(from: message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Proximity indicator
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                    Text("\(Int(message.proximityRadius))m")
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text(message.text)
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(nil)
            
            if !message.replies.isEmpty {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.caption)
                    Text("\(message.replies.count) \(message.replies.count == 1 ? "reply" : "replies")")
                        .font(.caption)
                }
                .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.9))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.2, blue: 0.9).opacity(0.5),
                                    Color(red: 0.4, green: 0.1, blue: 0.7).opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color(red: 0.6, green: 0.2, blue: 0.9).opacity(0.3), radius: 8)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


