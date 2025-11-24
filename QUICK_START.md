# Quick Start Guide

Get started with ChaiFrontend in 5 minutes!

## Prerequisites

- Flutter SDK (3.0+)
- Git
- ChaiBackend running

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/tarun1sisodia/ChaiFrontend.git
cd ChaiFrontend
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Backend URL

Edit `lib/utils/api_constants.dart`:

```dart
static const String baseUrl = 'http://YOUR_BACKEND_URL:8000';
```

**Examples:**
- Local: `http://localhost:8000`
- Android Emulator: `http://10.0.2.2:8000`
- Physical Device: `http://192.168.1.100:8000` (your computer's IP)

### 4. Run the App

```bash
# List available devices
flutter devices

# Run on default device
flutter run

# Or specify device
flutter run -d <device-id>
```

## First Use

### Register a New Account

1. Click "Register" on the login screen
2. Fill in:
   - Full Name
   - Username (min 3 characters)
   - Email
   - Password (min 6 characters)
   - Confirm Password
3. Select an Avatar (required)
4. Optionally select a Cover Image
5. Click "Register"

### Login

1. Enter your Username
2. Enter your Password
3. Click "Login"

You'll be automatically redirected to the home screen!

## Main Features

### Bottom Navigation

- **Home** - Video feed (coming soon)
- **Search** - Search videos (coming soon)
- **Upload** - Upload videos (coming soon)
- **Profile** - Your profile

### Profile Management

In the Profile tab, you can:
- View your profile information
- Edit your profile (name, email)
- Change your password
- Update your avatar
- Update your cover image
- View your videos (coming soon)
- View watch history (coming soon)
- Manage subscriptions (coming soon)

## Troubleshooting

### Can't connect to backend?

1. **Check backend is running:**
   ```bash
   curl http://localhost:8000/api/v1/healthcheck
   ```

2. **Check CORS configuration** in backend `.env`:
   ```
   CORS_ORIGIN=*
   ```

3. **For Android Emulator**, use:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8000';
   ```

4. **For Physical Device**, use your computer's IP:
   ```bash
   # Find your IP
   # macOS/Linux:
   ifconfig | grep "inet " | grep -v 127.0.0.1
   
   # Windows:
   ipconfig
   ```

### App crashes on image selection?

Make sure you've granted camera and storage permissions:
- Android: Go to Settings > Apps > Chai Frontend > Permissions
- iOS: Grant permissions when prompted

### "Failed to login"?

1. Check your username and password
2. Verify backend is running
3. Check backend logs for errors
4. Ensure user exists (or register first)

## Next Steps

- Read [SETUP.md](SETUP.md) for detailed setup instructions
- Check [API_INTEGRATION.md](API_INTEGRATION.md) for API details
- See [ARCHITECTURE.md](ARCHITECTURE.md) to understand the code structure
- Read [CONTRIBUTING.md](CONTRIBUTING.md) if you want to contribute

## Support

- 📖 [Full Documentation](README.md)
- 🐛 [Report Issues](https://github.com/tarun1sisodia/ChaiFrontend/issues)
- 💡 [Request Features](https://github.com/tarun1sisodia/ChaiFrontend/issues/new)

---

**Ready to build something awesome? Let's go! 🚀**
