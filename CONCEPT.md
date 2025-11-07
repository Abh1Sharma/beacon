# Beacon - Concept & Architecture

## Concept Overview

Beacon is an anonymous, location-based messaging app that connects people within proximity. Think of it as a digital bulletin board that only shows messages from people nearby.

### Core Value Proposition

- **Anonymous Social Discovery**: Connect with people around you without revealing your identity
- **Hyperlocal Relevance**: Messages are only visible to people within your chosen radius
- **Instant Engagement**: Real-time messaging encourages spontaneous interactions
- **Context-Aware**: Perfect for finding activity partners, asking questions, or sharing thoughts with your immediate community

### Use Cases

1. **Activity Coordination**: "Anyone want to go to the sauna?" (50m radius around your building)
2. **Local Questions**: "Where's the best coffee nearby?" (250m radius)
3. **Event Discovery**: "Live music at the park tonight!" (500m radius)
4. **Community Building**: Share thoughts and connect with neighbors (1km radius)

## Technical Architecture

### iOS App (SwiftUI)

**Architecture Pattern**: MVVM with ObservableObject services

- **Models**: `BeaconMessage` - Core data structure for messages and replies
- **Services**:
  - `LocationManager`: Handles CoreLocation integration and permissions
  - `MessageService`: API communication and message management
  - `SoundManager`: Audio feedback for user interactions
- **Views**: SwiftUI components for feed, compose, and detail views

**Key Features**:
- Location-based filtering
- Real-time polling (every 5 seconds)
- Anonymous user IDs (UUID-based)
- Beautiful gradient UI with animations
- Sound effects for engagement

### Backend (Node.js/Express)

**Current Implementation**: In-memory storage (MVP)

**API Endpoints**:
- `GET /api/messages` - Fetch messages within radius (Haversine distance calculation)
- `POST /api/messages` - Create new message
- `POST /api/messages/:id/replies` - Add reply to message

**Distance Calculation**: Uses Haversine formula for accurate geospatial queries

## Design Philosophy

### Visual Design
- **Dark purple gradient theme** - Creates a unique, modern aesthetic
- **Glassmorphism effects** - Semi-transparent cards with blur effects
- **Smooth animations** - Subtle pulsing and scale effects for engagement
- **Anonymous avatars** - Question mark icons maintain privacy

### User Experience
- **One-tap messaging** - Minimal friction to send a beacon
- **Instant feedback** - Sound effects confirm actions
- **Proximity indicators** - Clear visibility of message radius
- **Threaded conversations** - Easy to follow discussions

## MVP Limitations & Future Enhancements

### Current MVP Limitations
- In-memory storage (data lost on server restart)
- Polling-based updates (not true real-time)
- No push notifications
- No user authentication or blocking
- No message moderation
- No media/image support

### Planned Enhancements

**Phase 2: Production Ready**
- Database integration (PostgreSQL/MongoDB)
- WebSocket support for real-time updates
- Push notifications (APNs)
- Rate limiting and spam prevention
- Message expiration (auto-delete old messages)

**Phase 3: Advanced Features**
- Targeted messaging to specific users
- Message reactions and upvoting
- Trending topics and hashtags
- Custom themes and color schemes
- Image/media attachments
- Search and filtering
- User blocking and reporting

**Phase 4: Scale**
- Geospatial indexing (PostGIS/MongoDB geospatial queries)
- Caching layer (Redis)
- Load balancing
- Analytics and insights
- Admin dashboard

## Privacy & Safety

### Current Implementation
- Completely anonymous (no user accounts)
- Location data only used for proximity matching
- Messages stored temporarily (can add expiration)

### Future Considerations
- Content moderation API integration
- Reporting and blocking mechanisms
- Privacy controls (opt-out of location sharing)
- GDPR compliance for data handling

## Monetization Ideas (Future)

- Premium features (custom themes, larger radius, priority visibility)
- Sponsored messages for local businesses
- Event promotion tools
- Analytics for businesses

## Technical Stack

**iOS**:
- SwiftUI for UI
- CoreLocation for GPS
- URLSession for networking
- AVFoundation for sounds

**Backend**:
- Node.js + Express
- In-memory storage (MVP)
- CORS enabled for cross-origin requests

**Future Stack**:
- PostgreSQL with PostGIS extension
- Redis for caching
- WebSocket (Socket.io)
- Firebase Cloud Messaging for push notifications

## Getting Started

See `README.md` and `XCODE_SETUP.md` for detailed setup instructions.

Quick start:
1. `cd backend && npm install && npm start`
2. Open Xcode project
3. Update API URL in `MessageService.swift`
4. Build and run!


