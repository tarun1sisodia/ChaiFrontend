# Setup Guide

This guide will help you set up the ChaiFrontend application on different platforms.

## Prerequisites

### Required
- Flutter SDK (>=3.0.0)
- Dart SDK (comes with Flutter)
- Git

### Platform-Specific Requirements

#### Android Development
- Android Studio or VS Code with Flutter extension
- Android SDK
- Java Development Kit (JDK)
- Android emulator or physical device

#### iOS Development (macOS only)
- Xcode
- CocoaPods
- iOS Simulator or physical device

#### Web Development
- Chrome browser (recommended for development)

## Installation Steps

### 1. Install Flutter

#### macOS
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Linux
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Install dependencies
sudo apt-get install curl git unzip xz-utils zip libglu1-mesa

# Verify installation
flutter doctor
```

#### Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Run `flutter doctor`

### 2. Clone the Repository

```bash
git clone https://github.com/tarun1sisodia/ChaiFrontend.git
cd ChaiFrontend
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Backend URL

Edit `lib/utils/api_constants.dart`:

```dart
class ApiConstants {
  // For local development
  static const String baseUrl = 'http://localhost:8000';
  
  // For physical device testing (use your computer's IP)
  // static const String baseUrl = 'http://192.168.1.100:8000';
  
  // For production
  // static const String baseUrl = 'https://your-backend-url.com';
  
  static const String apiVersion = '/api/v1';
  // ... rest of the file
}
```

**Important Notes:**
- For Android emulator: Use `http://10.0.2.2:8000` instead of `localhost`
- For iOS simulator: Use `http://localhost:8000`
- For physical devices: Use your computer's IP address on the same network

### 5. Configure Backend CORS

Make sure your ChaiBackend has CORS configured to accept requests from the frontend.

In your backend's `.env` file:
```
CORS_ORIGIN=*
# Or specify: http://localhost:3000,http://192.168.1.100:3000
```

## Running the App

### Android

```bash
# List available devices
flutter devices

# Run on Android emulator/device
flutter run

# Or specify device
flutter run -d <device-id>
```

### iOS (macOS only)

```bash
# Open iOS simulator
open -a Simulator

# Run on iOS simulator
flutter run

# For first run, you may need to
cd ios
pod install
cd ..
flutter run
```

### Web

```bash
# Run on Chrome
flutter run -d chrome

# Or build for production
flutter build web
```

### Desktop (Experimental)

```bash
# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Windows
flutter run -d windows
```

## Troubleshooting

### Common Issues

#### 1. "flutter: command not found"
- Make sure Flutter bin directory is in your PATH
- Restart your terminal after adding to PATH

#### 2. Android license issues
```bash
flutter doctor --android-licenses
```

#### 3. iOS CocoaPods issues
```bash
cd ios
pod deintegrate
pod install
cd ..
```

#### 4. Build failures
```bash
# Clean build cache
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

#### 5. Network errors in Android emulator
- Use `http://10.0.2.2:8000` instead of `localhost:8000`
- Or check your backend's CORS configuration

#### 6. "Cannot connect to backend"
- Verify backend is running: `curl http://localhost:8000/api/v1/healthcheck`
- Check firewall settings
- For physical devices, ensure both are on the same network
- Verify the IP address in `api_constants.dart`

### Getting Backend IP Address

#### macOS/Linux
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

#### Windows
```bash
ipconfig
```

Look for IPv4 Address under your active network adapter.

## Development Tips

### Hot Reload
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

### Debug Mode
```bash
# Run with verbose logging
flutter run -v

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release
```

### Device-Specific Testing

#### Testing on Physical Android Device
1. Enable Developer Options on your device
2. Enable USB Debugging
3. Connect via USB
4. Trust the computer when prompted
5. Run `flutter devices` to verify
6. Run `flutter run`

#### Testing on Physical iOS Device (macOS only)
1. Connect your iPhone/iPad
2. Trust the computer
3. Open Xcode and configure signing
4. Run `flutter run`

## Next Steps

After successful setup:
1. Create a user account
2. Upload profile images
3. Explore the app features
4. Check the [README.md](README.md) for more information
5. See [CONTRIBUTING.md](CONTRIBUTING.md) if you want to contribute

## Need Help?

- Check [Flutter Documentation](https://docs.flutter.dev)
- Visit [Flutter Community](https://flutter.dev/community)
- Open an issue on GitHub
- Contact the project maintainers
