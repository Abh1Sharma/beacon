# App Icon Setup Guide

## Icon Design Specifications

You need a **glassmorphism icon** featuring:
- **A bee** (main character)
- **A cone positioned like a microphone/loudspeaker** (representing the "beacon" broadcasting concept)
- **Glassmorphism style**: Translucent, blurred background, subtle borders, modern aesthetic

## Required Icon Sizes

iOS requires multiple icon sizes. Here's what you need:

### iPhone Icons
- **20x20** (2x) = 40x40 pixels - Notification icon
- **20x20** (3x) = 60x60 pixels - Notification icon (iPhone Plus)
- **29x29** (2x) = 58x58 pixels - Settings icon
- **29x29** (3x) = 87x87 pixels - Settings icon (iPhone Plus)
- **40x40** (2x) = 80x80 pixels - Spotlight icon
- **40x40** (3x) = 120x120 pixels - **App icon (iPhone)** ⭐ REQUIRED
- **60x60** (2x) = 120x120 pixels - App icon (legacy)
- **60x60** (3x) = 180x180 pixels - App icon (iPhone Plus)

### iPad Icons
- **20x20** (1x) = 20x20 pixels - Notification icon
- **20x20** (2x) = 40x40 pixels - Notification icon
- **29x29** (1x) = 29x29 pixels - Settings icon
- **29x29** (2x) = 58x58 pixels - Settings icon
- **40x40** (1x) = 40x40 pixels - Spotlight icon
- **40x40** (2x) = 80x80 pixels - Spotlight icon
- **76x76** (1x) = 76x76 pixels - App icon (legacy)
- **76x76** (2x) = 152x152 pixels - **App icon (iPad)** ⭐ REQUIRED
- **83.5x83.5** (2x) = 167x167 pixels - App icon (iPad Pro)

### App Store Icon
- **1024x1024** pixels - **Required for App Store** ⭐ REQUIRED

## Quick Solution: Generate One Large Icon

**Easiest approach**: Generate a **1024x1024** pixel icon, then Xcode will automatically resize it for all sizes.

## How to Create Your Icon

### Option 1: Use AI Image Generator (Recommended)

1. **Go to an AI image generator**:
   - [Midjourney](https://midjourney.com)
   - [DALL-E](https://openai.com/dall-e-2)
   - [Stable Diffusion](https://stability.ai)
   - [Canva AI](https://canva.com) (has icon templates)

2. **Use this prompt**:
   ```
   App icon, glassmorphism style, translucent bee with a cone positioned like a microphone/loudspeaker, 
   purple gradient background, modern iOS app icon design, clean minimalist, 1024x1024 pixels, 
   rounded corners, subtle glow effect, professional app store icon
   ```

3. **Refine if needed**:
   - Make sure the bee and cone are clearly visible
   - Purple gradient background (matching your app theme)
   - Glassmorphism effect (translucent, blurred, subtle borders)
   - Clean, modern design

### Option 2: Use Design Tools

1. **Figma** (free):
   - Create 1024x1024 canvas
   - Design your bee + cone icon
   - Apply glassmorphism effects
   - Export as PNG

2. **Canva** (free):
   - Search "app icon" templates
   - Customize with bee and cone
   - Export as PNG (1024x1024)

3. **Photoshop/Illustrator**:
   - Create 1024x1024 artboard
   - Design icon
   - Export as PNG

## Where to Add the Icon in Xcode

### Step 1: Open Assets Catalog

1. **In Xcode**, open your project
2. **Navigate to**: `Beacon/Assets.xcassets`
3. **Click on**: `AppIcon` (you should see empty icon slots)

### Step 2: Add Your Icon

1. **Drag and drop** your 1024x1024 icon image into the **App Store** slot (1024x1024)
2. **Xcode will automatically**:
   - Generate all required sizes
   - Fill in all the icon slots
   - Set up the Contents.json properly

**OR** if you have individual sizes:

1. **iPhone App** (120x120): Drag to the 60pt @2x slot
2. **iPhone App** (180x180): Drag to the 60pt @3x slot  
3. **iPad App** (152x152): Drag to the 76pt @2x slot
4. **App Store** (1024x1024): Drag to the App Store slot

### Step 3: Verify

1. **Check** that all required slots are filled (they'll show checkmarks)
2. **Build** your project (⌘B) to verify no errors
3. **Archive** again (Product → Archive)

## Quick Fix: Temporary Icon (For Testing)

If you want to archive quickly for testing, you can create a simple placeholder:

1. **Create a 1024x1024 image** with:
   - Purple gradient background
   - Text "B" or "Beacon" in the center
   - Rounded corners

2. **Add it to Xcode** as described above

3. **Replace later** with your final glassmorphism bee icon

## Icon Design Tips

- **Keep it simple**: Icons are small, details get lost
- **High contrast**: Make sure bee and cone stand out
- **No text**: Apple discourages text in app icons
- **Rounded corners**: iOS automatically rounds corners, design for square
- **Purple theme**: Match your app's purple gradient aesthetic
- **Glassmorphism**: Translucent layers, subtle blur, light borders

## Troubleshooting

### Error: "Missing required icon file"

**Fix**:
1. Make sure you added the icon to the **AppIcon** asset catalog
2. Check that the **1024x1024** App Store icon is filled
3. Clean build folder: Product → Clean Build Folder (⌘ShiftK)
4. Try archiving again

### Error: "CFBundleIconName missing"

**Fix**:
1. Xcode should set this automatically when you add icons
2. If not, go to **Info** tab in your target settings
3. Add key: `CFBundleIconName` with value: `AppIcon`

### Icons look blurry

**Fix**:
- Make sure you're using high-resolution images
- Use 1024x1024 for App Store icon
- Xcode will generate other sizes automatically

## After Adding Icon

1. **Clean build**: Product → Clean Build Folder (⌘ShiftK)
2. **Build**: Product → Build (⌘B)
3. **Archive**: Product → Archive
4. **Should work now!** ✅

