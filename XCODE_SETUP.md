# Xcode Setup Guide for Beacon

## Creating the Xcode Project

1. **Open Xcode** and select "Create a new Xcode project"

2. **Choose Template:**
   - Select "iOS" → "App"
   - Click "Next"

3. **Project Configuration:**
   - Product Name: `Beacon`
   - Team: Select your development team
   - Organization Identifier: `com.yourname` (or your domain)
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None` (we'll handle storage in backend)
   - Click "Next"

4. **Save Location:**
   - Choose a location (or save in the workspace root)
   - Click "Create"

## Adding Files to Xcode

1. **Delete the default files:**
   - Delete `ContentView.swift` (we have our own)
   - Keep `BeaconApp.swift` but replace its contents

2. **Add files from the Beacon directory:**
   - Right-click on the project navigator
   - Select "Add Files to Beacon..."
   - Navigate to the `Beacon/` folder
   - Select all Swift files:
     - `BeaconApp.swift`
     - `ContentView.swift`
     - All files in `Models/`
     - All files in `Services/`
     - All files in `Views/`
   - Make sure "Copy items if needed" is checked
   - Click "Add"

3. **Add Info.plist entries (IMPORTANT - Use Xcode's Info tab, NOT a manual file):**
   - Select your project in the navigator (the blue icon at the top)
   - Select the "Beacon" target (under TARGETS, not PROJECTS)
   - Go to the **"Info"** tab
   - Click the **+** button to add new entries
   - Add these two keys:
     - Key: `Privacy - Location When In Use Usage Description`
       Value: `Beacon needs your location to show messages from people nearby.`
     - Key: `Privacy - Location Always And When In Use Usage Description`
       Value: `Beacon needs your location to show messages from people nearby.`
   
   **⚠️ DO NOT add the Info.plist file from the Beacon folder** - Modern Xcode projects handle this automatically through the Info tab. Adding a manual Info.plist will cause build errors.

## Configuring the API URL

1. **Update MessageService.swift:**
   - Open `Beacon/Services/MessageService.swift`
   - Find the line: `private let apiBaseURL = "http://localhost:3000/api"`
   - For simulator testing: Keep as `localhost:3000`
   - For device testing: Replace with your Mac's IP address (e.g., `http://10.0.0.109:3000/api`)
   - To find your Mac's IP: System Preferences → Network → Wi-Fi → IP Address

## Selecting a Simulator

1. **Find the Simulator Selector:**
   - Look at the top toolbar in Xcode (next to the Play/Stop buttons)
   - You'll see a dropdown that shows something like "iPhone 15 Pro" or "Any iOS Device"
   - This is the **scheme and destination selector**

2. **Choose a Simulator:**
   - Click on the dropdown menu
   - You'll see a list of available simulators organized by iOS version
   - Common options:
     - **iPhone 15 Pro** (recommended for testing)
     - **iPhone 14**
     - **iPhone SE**
     - **iPad Pro**
   - Click on any simulator to select it

3. **Add More Simulators (if needed):**
   - In the simulator dropdown, click **"Add Additional Simulators..."**
   - Or go to: **Xcode → Settings → Platforms** (or **Xcode → Preferences → Components**)
   - Download iOS simulators for different versions if needed
   - You can also manage simulators via: **Window → Devices and Simulators**

4. **For Beacon App - Recommended Simulators:**
   - **iPhone 15 Pro** - Best for modern features and testing
   - **iPhone 14** - Good for testing on slightly older hardware
   - **iPhone SE** - Smallest screen size, good for UI testing
   - Consider testing on multiple simulators to ensure your UI works on different screen sizes

## Running the App

1. **Start the backend server:**
   ```bash
   cd backend
   npm install
   npm start
   ```

2. **In Xcode:**
   - Select a simulator from the dropdown (see above)
   - Press **⌘R** (Command + R) to build and run
   - Or click the **Play button** (▶️) in the top-left
   - Grant location permissions when prompted

## Testing

1. **Test on Simulator:**
   - Once the app is running, you can simulate different locations:
   - In the simulator menu bar: **Features → Location → Custom Location...**
   - Or in Xcode: **Debug → Simulate Location → Custom Location...**
   - Enter coordinates (e.g., `37.7749, -122.4194` for San Francisco)
   - Set different coordinates to test proximity filtering
   - You can also use preset locations like "Apple Park" or "City Run"

2. **Test on Device:**
   - Connect your iPhone via USB
   - Select your device in Xcode
   - Build and run
   - Make sure your Mac and iPhone are on the same network
   - Update the API URL to your Mac's IP address

## Troubleshooting

### Build Error: "Multiple commands produce Info.plist"

**This happens if you added the manual Info.plist file. Here's how to fix it:**

1. **Remove the Info.plist file from your project:**
   - In Xcode's project navigator, find `Info.plist` (if it exists)
   - Right-click on it → **Delete** → Choose **"Remove Reference"** (don't move to trash)
   - Or select it and press Delete, then choose "Remove Reference"

2. **Make sure you're using Xcode's Info tab instead:**
   - Select your project → Select "Beacon" target → Go to "Info" tab
   - Add the location permission keys there (see step 3 above)

3. **Clean the build folder:**
   - Press **⌘ShiftK** (Command + Shift + K) to clean
   - Or go to **Product → Clean Build Folder**

4. **Try building again:**
   - Press **⌘R** to build and run

### Other Common Issues

- **Location not working:** Make sure you've added the Info.plist entries via Xcode's Info tab (not a manual file)
- **API calls failing:** Check that the backend server is running and the URL is correct
- **Build errors:** Make sure all Swift files are added to the target (check Target Membership in File Inspector)
- **Files not found:** Make sure "Copy items if needed" was checked when adding files

