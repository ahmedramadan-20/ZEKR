# Azan Sound Setup Instructions

## 📢 IMPORTANT: You Need to Add the Azan Audio File

The notification system is **already fully configured** and ready to play the Azan at prayer times! 

However, **I cannot download or create audio files**. You need to provide the Azan sound.

---

## Quick Setup (3 Steps)

### 1. Get an Azan Audio File
Download a short Azan (30-60 seconds recommended) in `.mp3` format.

**Free Azan Sources:**
- [Pixabay](https://pixabay.com/sound-effects/search/azan/) - Free, no attribution
- [Freesound](https://freesound.org/search/?q=azan) - Free with attribution  
- Record your own from a trusted source

### 2. Add to Android

**File Location:**
```
d:\developments\projects\flutter projects\quran\android\app\src\main\res\raw\
```

**File Name:** MUST be exactly `azan.mp3` (lowercase, no spaces)

**Steps:**
1. I've already created the `raw` folder for you ✅
2. Copy your `azan.mp3` file into this folder
3. That's it! Android is done ✅

### 3. Add to iOS (Optional - for iOS devices)

**Convert to iOS Format:**
- iOS prefers `.aiff` or `.caf` format
- Use online converter or iTunes to convert `azan.mp3` → `azan.aiff`

**Add to Project:**
1. Place `azan.aiff` in `ios/Runner/`
2. Open Xcode: `ios/Runner.xcworkspace`
3. Right-click Runner → "Add Files to Runner"
4. Select `azan.aiff`, check "Copy items if needed"
5. Done! ✅

---

## ✅ Already Configured (No Action Needed)

**Notification Service** - Already set up:
- Custom sound configured (line 97-102)
- Android: `RawResourceAndroidNotificationSound('azan')`
- iOS: `sound: 'azan.aiff'`

**Prayer Times Integration** - Already working:
- Notifications scheduled automatically when prayer times load
- Permissions requested properly  
- Triggers at exact prayer time

**Android Manifest** - Already has:
- SCHEDULE_EXACT_ALARM permission
- POST_NOTIFICATIONS permission
- Notification receiver

---

## 🧪 Testing

After adding the audio file:

1. **Run the app**
2. **Open Prayer Times screen**
3. **Allow notification permission** (first time)
4. **Wait for next prayer time** OR:
   - For quick testing, temporarily modify `scheduledTime` in code to 1 minute from now
   - Check if notification appears with Azan sound

---

## 📁 File Structure After Setup

```
quran/
├── android/app/src/main/res/
│   └── raw/
│       └── azan.mp3          ← YOU ADD THIS
├── ios/Runner/
│   └── azan.aiff             ← OPTIONAL for iOS
```

---

## ❓ Troubleshooting

**No sound plays:**
- Verify file is named exactly `azan.mp3` (lowercase)
- Check file is in `raw` folder
- Ensure phone volume is up
- Test notification first appears correctly

**Permission issues:**
- Go to App Settings → Permissions
- Enable Notifications
- Enable Exact Alarms (Android 12+)

**Sound doesn't match expected:**
- Check audio file duration/quality
- Ensure it's not corrupted
- Try different audio file

---

**Status:** 🟢 Notification system is ready! Just add the audio file and test.
