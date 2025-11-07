# Xcode Code Signing & Archive Setup Guide

## Quick Fix: Enable Automatic Signing

The easiest way to fix provisioning profile issues is to use Xcode's automatic signing:

### Step 1: Configure Signing & Capabilities

1. **Open your project in Xcode**
2. **Select your project** in the navigator (the blue icon at the top)
3. **Select the "Beacon" target** (under TARGETS, not PROJECTS)
4. **Go to the "Signing & Capabilities" tab**
5. **Check "Automatically manage signing"**
6. **Select your Team** from the dropdown (should show your Apple Developer account)
7. **Bundle Identifier**: Make sure it's unique (e.g., `com.yourname.beacon` or `com.yourdomain.beacon`)

### Step 2: Register a Device (Optional but Recommended)

You have two options:

#### Option A: Register Your iPhone/iPad (Recommended)

1. **Connect your iPhone/iPad** to your Mac via USB
2. **Unlock your device** and trust the computer if prompted
3. **In Xcode**: Window → Devices and Simulators
4. Your device should appear automatically
5. Xcode will register it for you

#### Option B: Register Device Manually (If you can't connect)

1. **Get your device UDID**:
   - On iPhone/iPad: Settings → General → About → Scroll to find "Identifier" (UDID)
   - Or connect to Mac → Finder → Select device → Click "Serial Number" to see UDID
2. **Go to Apple Developer Portal**:
   - Visit [developer.apple.com/account](https://developer.apple.com/account)
   - Sign in with your Apple Developer account
   - Go to **Certificates, Identifiers & Profiles**
   - Click **Devices** → **+** button
   - Enter device name and UDID
   - Click **Continue** → **Register**

### Step 3: Create App Identifier (If Needed)

1. **In Apple Developer Portal**:
   - Go to **Certificates, Identifiers & Profiles**
   - Click **Identifiers** → **+** button
   - Select **App IDs** → **Continue**
   - Select **App** → **Continue**
   - **Description**: `Beacon App`
   - **Bundle ID**: Use "Explicit" and enter your bundle identifier (e.g., `com.yourname.beacon`)
   - Select capabilities if needed (for Beacon, you might need Location Services)
   - Click **Continue** → **Register**

### Step 4: Archive Your App

1. **In Xcode**:
   - Select **"Any iOS Device"** from the device dropdown (top toolbar)
   - **NOT** a simulator - must be "Any iOS Device"
2. **Archive**:
   - Go to **Product → Archive**
   - Wait for the build to complete
   - If you see errors, check the steps above

### Step 5: Upload to App Store Connect

1. **After archiving**, the Organizer window should open automatically
2. **Click "Distribute App"**
3. **Select "App Store Connect"**
4. **Follow the prompts**:
   - Choose "Upload"
   - Select your team
   - Review the app information
   - Click "Upload"
5. **Wait for upload to complete** (may take a few minutes)

## Troubleshooting Common Issues

### Error: "No profiles for 'cpp.Beacon' were found"

**Fix**:
1. Go to **Signing & Capabilities** tab
2. Make sure **"Automatically manage signing"** is checked
3. Select your **Team**
4. Change **Bundle Identifier** to something unique (e.g., `com.yourname.beacon`)
5. Xcode will automatically create the provisioning profile

### Error: "Your team has no devices"

**Fix**:
- **Option 1**: Connect your iPhone/iPad and let Xcode register it automatically
- **Option 2**: Register device manually in Apple Developer Portal (see Option B above)
- **Note**: For TestFlight, you don't necessarily need a device registered - Xcode can create profiles without one, but it's recommended

### Error: "Bundle identifier is already in use"

**Fix**:
- Change your Bundle Identifier to something unique
- In **Signing & Capabilities** → **Bundle Identifier**
- Use format: `com.yourname.beacon` or `com.yourdomain.beacon`
- Make sure it's unique to you

### Error: "No signing certificate found"

**Fix**:
1. Xcode should automatically create certificates when you enable "Automatically manage signing"
2. If not, go to **Xcode → Settings → Accounts**
3. Select your Apple ID
4. Click **Download Manual Profiles**
5. Or click **Manage Certificates** → **+** → **iOS Development**

### Archive Button is Grayed Out

**Fix**:
- Make sure you've selected **"Any iOS Device"** (not a simulator)
- Check that your project builds successfully (⌘B)
- Fix any build errors first

## Setting Up App Store Connect

Before uploading, you need to create your app in App Store Connect:

1. **Go to** [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. **Sign in** with your Apple Developer account
3. **Click "My Apps"** → **+** → **New App**
4. **Fill in the details**:
   - Platform: iOS
   - Name: Beacon (or your app name)
   - Primary Language: English
   - Bundle ID: Select the one you created (or create new)
   - SKU: A unique identifier (e.g., `beacon-app-001`)
5. **Click "Create"**
6. **Now you can upload** your archive from Xcode

## After Upload

1. **Wait for processing** (usually 10-30 minutes)
2. **Go to App Store Connect** → Your App → **TestFlight**
3. **Add testers**:
   - Internal testers: People in your App Store Connect team
   - External testers: Anyone you invite (requires Beta App Review)
4. **For external testers**: Submit for Beta App Review (usually approved quickly)

## Quick Checklist

- [ ] Apple Developer Account active ($99/year)
- [ ] Xcode project has "Automatically manage signing" enabled
- [ ] Team selected in Signing & Capabilities
- [ ] Bundle Identifier is unique
- [ ] App created in App Store Connect (optional, can do after upload)
- [ ] Selected "Any iOS Device" (not simulator)
- [ ] Archive successful
- [ ] Uploaded to App Store Connect

## Need More Help?

- **Apple Developer Support**: [developer.apple.com/support](https://developer.apple.com/support)
- **Xcode Help**: Help → Xcode Help in Xcode
- **App Store Connect Help**: [help.apple.com/app-store-connect](https://help.apple.com/app-store-connect)

