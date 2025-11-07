# Beacon - Anonymous Proximity Messaging App

Beacon is an iOS app that allows users to send anonymous messages to people within a customizable radius (default 1km). Messages appear as notifications and can be replied to instantly, creating threaded conversations.

## Features

- 📍 **Location-based messaging** - Send messages visible to people within your proximity radius
- 🎯 **Customizable radius** - Choose from 50m to 1km+ 
- 💬 **Threaded conversations** - Reply to messages and build discussions
- 🎨 **Beautiful UI** - Unique purple gradient design with smooth animations
- 🔊 **Sound effects** - Engaging audio feedback for interactions
- 🔒 **Anonymous** - No accounts needed, completely anonymous messaging

## Project Structure

```
beacon/
├── Beacon/                    # iOS app (SwiftUI)
│   ├── BeaconApp.swift       # App entry point
│   ├── ContentView.swift     # Main feed view
│   ├── Models/
│   │   └── BeaconMessage.swift
│   ├── Services/
│   │   ├── LocationManager.swift
│   │   ├── MessageService.swift
│   │   └── SoundManager.swift
│   └── Views/
│       ├── MessageCard.swift
│       ├── ComposeView.swift
│       └── MessageDetailView.swift
├── backend/                   # Node.js/Express server
│   ├── server.js
│   └── package.json
└── README.md
```

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Start the server:
```bash
npm start
```

The server will run on `http://localhost:3000`

For development with auto-reload:
```bash
npm run dev
```

### iOS App Setup

1. Open Xcode and create a new iOS project:
   - Choose "App" template
   - Product Name: `Beacon`
   - Interface: `SwiftUI`
   - Language: `Swift`

2. Copy all files from the `Beacon/` directory into your Xcode project

3. Add the `Info.plist` entries to your project's Info.plist (or add them via Xcode's Info tab):
   - `NSLocationWhenInUseUsageDescription`: "Beacon needs your location to show messages from people nearby."

4. Update the API URL in `MessageService.swift`:
   - Change `apiBaseURL` to your server's URL (for local testing, use your Mac's IP address instead of `localhost`)

5. Build and run the app on a simulator or device

## MVP Features Implemented

✅ Location services with permission handling  
✅ Proximity-based message filtering  
✅ Customizable radius (50m, 100m, 250m, 500m, 1km)  
✅ Anonymous messaging  
✅ Threaded replies  
✅ Real-time message fetching (polling every 5 seconds)  
✅ Beautiful gradient UI with animations  
✅ Sound effects for interactions  
✅ Message cards with timestamps and proximity indicators  

## Future Enhancements

- 🔔 Push notifications for new messages
- 🔄 WebSocket support for real-time updates
- 💾 Persistent database (PostgreSQL/MongoDB)
- 🎯 Targeted messaging to specific users
- 📊 Message analytics and trending topics
- 🎨 Custom themes and color schemes
- 🔊 Custom sound library
- 🔍 Search and filter messages
- 📸 Image/media support
- ⭐ Message reactions

## API Endpoints

### GET `/api/messages`
Get messages within radius
- Query params: `lat`, `lng`, `radius`

### POST `/api/messages`
Create a new message
- Body: `{ text, authorId, location: { latitude, longitude }, proximityRadius, timestamp }`

### POST `/api/messages/:id/replies`
Add a reply to a message
- Body: `{ text, authorId, timestamp }`

## Notes

- The backend currently uses in-memory storage. For production, integrate a database (PostgreSQL, MongoDB, or Firebase)
- For real-time updates, consider implementing WebSockets or Server-Sent Events
- Update the `apiBaseURL` in `MessageService.swift` to point to your deployed backend
- Add proper error handling and loading states for production use
- Consider adding rate limiting to prevent spam

## License

MIT


