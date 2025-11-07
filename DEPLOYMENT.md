# Beacon Deployment Guide

This guide will help you deploy Beacon so you can test it with friends!

## 🎯 Overview

To deploy Beacon, you need to:
1. **Deploy the backend** to a cloud service (so it's accessible from anywhere)
2. **Update the iOS app** to use the deployed backend URL
3. **Distribute the iOS app** to your friends (via TestFlight or ad-hoc distribution)

---

## Part 1: Deploy Backend to Cloud

Choose one of these options:

### Option A: Railway (Recommended - Easiest & Free Tier)

1. **Sign up**: Go to [railway.app](https://railway.app) and sign up with GitHub

2. **Create new project**:
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect your repository (or create a new one and push your code)

3. **Configure deployment**:
   - Railway will auto-detect Node.js
   - Set root directory to `backend` (if deploying from repo root)
   - Or deploy just the `backend` folder

4. **Set environment variables** (if needed):
   - `PORT` - Railway sets this automatically
   - Your backend will be available at: `https://your-app-name.railway.app`

5. **Get your backend URL**:
   - After deployment, copy your app URL
   - Your API will be at: `https://your-app-name.railway.app/api`
   - Test it: `https://your-app-name.railway.app/health`

### Option B: Render (Free Tier Available)

1. **Sign up**: Go to [render.com](https://render.com) and sign up

2. **Create new Web Service**:
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Or use "Public Git repository" and paste your repo URL

3. **Configure**:
   - **Name**: `beacon-backend` (or any name)
   - **Environment**: `Node`
   - **Build Command**: `cd backend && npm install`
   - **Start Command**: `cd backend && npm start`
   - **Root Directory**: Leave empty (or set to `backend` if deploying from repo root)

4. **Deploy**:
   - Click "Create Web Service"
   - Wait for deployment (usually 2-3 minutes)
   - Your API will be at: `https://beacon-backend.onrender.com/api`

### Option C: Heroku (Free Tier Discontinued, Paid Only)

1. **Install Heroku CLI**: `brew install heroku/brew/heroku`

2. **Login**: `heroku login`

3. **Create app**: `heroku create beacon-backend`

4. **Deploy**:
   ```bash
   cd backend
   git init
   git add .
   git commit -m "Initial commit"
   heroku git:remote -a beacon-backend
   git push heroku main
   ```

5. **Your API will be at**: `https://beacon-backend.herokuapp.com/api`

### Option D: Fly.io (Free Tier Available)

1. **Install Fly CLI**: `brew install flyctl`

2. **Login**: `flyctl auth login`

3. **Initialize**: `cd backend && flyctl launch`

4. **Deploy**: `flyctl deploy`

5. **Your API will be at**: `https://your-app-name.fly.dev/api`

---

## Part 2: Update iOS App to Use Deployed Backend

1. **Open** `Beacon/Services/MessageService.swift` in Xcode

2. **Update the API URL**:
   ```swift
   // Replace this line:
   private let apiBaseURL = "http://localhost:3000/api"
   
   // With your deployed backend URL (use HTTPS!):
   private let apiBaseURL = "https://your-app-name.railway.app/api"
   // OR
   private let apiBaseURL = "https://beacon-backend.onrender.com/api"
   ```

3. **Important**: 
   - Use `https://` (not `http://`) for deployed backends
   - Make sure your backend URL ends with `/api`
   - Test the URL in a browser first: `https://your-backend-url/health`

---

## Part 3: Distribute iOS App to Friends

### Option A: TestFlight (Recommended - Easiest for Friends)

**Requirements**: Apple Developer Account ($99/year)

1. **Archive your app**:
   - In Xcode, select "Any iOS Device" (not simulator)
   - Go to **Product → Archive**
   - Wait for archive to complete

2. **Upload to App Store Connect**:
   - In the Organizer window, click "Distribute App"
   - Select "App Store Connect"
   - Follow the prompts to upload

3. **Set up TestFlight**:
   - Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Navigate to your app → TestFlight
   - Add internal testers (your Apple ID) or external testers
   - For external testers: Submit for Beta App Review (usually approved quickly)

4. **Invite friends**:
   - Add friends as external testers (they need to accept email invite)
   - They'll install TestFlight app, then install your app
   - Updates are automatic!

### Option B: Ad-Hoc Distribution (Free, but Limited)

**Requirements**: Apple Developer Account ($99/year)

1. **Register devices**:
   - Go to [developer.apple.com](https://developer.apple.com)
   - Certificates, Identifiers & Profiles → Devices
   - Add your friends' device UDIDs (they can find this in Settings → General → About)

2. **Create Ad-Hoc Provisioning Profile**:
   - In Xcode: Preferences → Accounts → Your Apple ID
   - Download Manual Profiles
   - Or create profile in developer portal

3. **Archive and export**:
   - Product → Archive
   - Distribute App → Ad Hoc
   - Select the provisioning profile
   - Export and share the `.ipa` file

4. **Friends install**:
   - They need to install via iTunes/Finder or a tool like AltStore
   - More complicated than TestFlight

### Option C: Development Build (Quick Testing, Limited)

**Requirements**: Apple Developer Account ($99/year)

1. **Connect friend's iPhone**:
   - Plug their iPhone into your Mac
   - Trust the computer on iPhone

2. **Build and run**:
   - Select their device in Xcode
   - Press ⌘R to build and install
   - App will work for 7 days (or until you revoke certificate)

**Limitation**: App expires after 7 days, need to reinstall

---

## Part 4: Testing Checklist

Before sharing with friends:

- [ ] Backend is deployed and accessible (test `/health` endpoint)
- [ ] iOS app URL is updated to deployed backend
- [ ] Test sending a message from your device
- [ ] Test receiving messages
- [ ] Verify location permissions work
- [ ] Test on different proximity radii
- [ ] Make sure friends are on same network or have internet access

---

## Quick Test Setup (Local Network)

If you just want to test quickly on the same WiFi network:

1. **Keep backend running locally**:
   ```bash
   cd backend
   npm start
   ```

2. **Find your Mac's IP address**:
   - System Settings → Network → Wi-Fi → Details → IP Address
   - Or run: `ipconfig getifaddr en0` (or `en1`)

3. **Update iOS app**:
   ```swift
   private let apiBaseURL = "http://YOUR_MAC_IP:3000/api"
   // Example: "http://192.168.1.100:3000/api"
   ```

4. **Make sure firewall allows connections**:
   - System Settings → Network → Firewall → Options
   - Allow incoming connections for Node

5. **Friends connect**:
   - They need to be on the same WiFi network
   - Update their app with your Mac's IP address
   - Works great for quick testing!

---

## Troubleshooting

### Backend Issues

**"Cannot connect to backend"**:
- Check backend is running: `curl https://your-backend-url/health`
- Verify URL uses `https://` (not `http://`)
- Check CORS is enabled (should be in `server.js`)

**"Messages not appearing"**:
- Check backend logs
- Verify location coordinates are being sent
- Test API directly: `curl "https://your-backend-url/api/messages?lat=37.7749&lng=-122.4194&radius=1000"`

### iOS App Issues

**"App won't install"**:
- Check device UDID is registered (for ad-hoc)
- Verify provisioning profile matches device
- Check certificate hasn't expired

**"Can't connect to backend"**:
- Verify URL is correct in `MessageService.swift`
- Check Info.plist allows arbitrary loads (if using HTTP):
  - Add `NSAppTransportSecurity` → `NSAllowsArbitraryLoads` = `YES`
  - **Note**: Use HTTPS in production instead!

**"Location not working"**:
- Check Info.plist has location permission description
- Verify location permissions are granted in Settings

---

## Production Considerations

Before going fully public:

1. **Add a database** (PostgreSQL, MongoDB) - current backend uses in-memory storage
2. **Add authentication** (if needed)
3. **Implement rate limiting** to prevent spam
4. **Add message expiration** (auto-delete old messages)
5. **Set up monitoring** (error tracking, analytics)
6. **Use HTTPS everywhere** (most cloud providers do this automatically)
7. **Add proper error handling** in iOS app
8. **Consider WebSockets** for real-time updates instead of polling

---

## Need Help?

- Check backend logs in your cloud provider's dashboard
- Test API endpoints with `curl` or Postman
- Check Xcode console for iOS app errors
- Verify network connectivity

Happy testing! 🚀

