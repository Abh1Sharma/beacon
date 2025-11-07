# Beacon MVP - Quick Start

## 🎯 What You've Built

A fully functional MVP of Beacon - an anonymous, location-based messaging app for iOS!

## 🚀 Quick Start

### 1. Start the Backend Server

```bash
./start-backend.sh
```

Or manually:
```bash
cd backend
npm install
npm start
```

The server will run on `http://localhost:3000`

### 2. Set Up iOS App in Xcode

1. Open Xcode and create a new iOS App project named "Beacon"
2. Copy all files from the `Beacon/` folder into your Xcode project
3. Add location permissions to Info.plist (see `XCODE_SETUP.md`)
4. Update the API URL in `MessageService.swift`:
   - Simulator: `http://localhost:3000/api`
   - Device: `http://YOUR_MAC_IP:3000/api`

### 3. Run the App

- Select a simulator or device
- Press ⌘R to build and run
- Grant location permissions when prompted

## ✨ Features

✅ Send anonymous messages within customizable radius  
✅ View messages from people nearby  
✅ Reply to messages and build threads  
✅ Beautiful purple gradient UI  
✅ Sound effects for interactions  
✅ Proximity radius selector (50m - 1km+)  

## 📱 Testing Tips

- **Simulator**: Use Debug → Location → Custom Location to test different coordinates
- **Multiple Devices**: Use different simulators/devices with different locations to see proximity filtering
- **Backend**: Check `http://localhost:3000/health` to verify server is running

## 🎨 Customization

- **Colors**: Edit gradient colors in `ContentView.swift` and other view files
- **Sounds**: Add custom sound files and update `SoundManager.swift`
- **Radius Options**: Modify the menu in `HeaderView` in `ContentView.swift`

## 📚 Documentation

- `README.md` - Full documentation
- `XCODE_SETUP.md` - Detailed Xcode setup guide
- `CONCEPT.md` - Architecture and design philosophy
- `DEPLOYMENT.md` - **Deploy and test with friends!** 🚀

## 🔮 Next Steps

1. Add a database (PostgreSQL/MongoDB)
2. Implement WebSockets for real-time updates
3. Add push notifications
4. Deploy backend to cloud (see `DEPLOYMENT.md`)
5. Add message expiration and cleanup
6. Implement rate limiting

## 🚀 Ready to Share?

Check out `DEPLOYMENT.md` for step-by-step instructions on:
- Deploying the backend to cloud (Railway, Render, Heroku, etc.)
- Distributing the iOS app via TestFlight
- Testing with friends on the same network

Happy coding! 🎉


