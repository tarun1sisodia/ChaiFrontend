# ChaiFrontend

A Flutter-based mobile frontend for the [ChaiBackend](https://github.com/tarun1sisodia/ChaiBackend) video platform. This app provides a user-friendly interface for users to register, login, view videos, manage their profile, and interact with video content.

## Features

### Authentication
- User registration with avatar and cover image upload
- User login with JWT token management
- Automatic token refresh
- Secure logout

### User Profile
- View user profile with avatar and cover image
- Edit profile information (name, email)
- Change password
- Update avatar and cover image
- View watch history
- View subscriptions

### Video Platform
- Browse video feed
- Video playback (in development)
- Search functionality (coming soon)
- Video upload (coming soon)

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **Image Handling**: image_picker, cached_network_image
- **Video Player**: video_player

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/                    # Data models
│   ├── user.dart
│   └── video.dart
├── providers/                 # State management
│   └── auth_provider.dart
├── screens/                   # UI screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   └── profile_screen.dart
├── services/                  # API services
│   └── api_service.dart
├── utils/                     # Utilities
│   └── api_constants.dart
└── widgets/                   # Reusable widgets
```

## Setup Instructions

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode for mobile development
- A running instance of ChaiBackend

### Installation

1. Clone the repository:
```bash
git clone https://github.com/tarun1sisodia/ChaiFrontend.git
cd ChaiFrontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure the backend URL:
   - Open `lib/utils/api_constants.dart`
   - Update `baseUrl` with your ChaiBackend URL:
   ```dart
   static const String baseUrl = 'http://your-backend-url:8000';
   ```

4. Run the app:
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web (experimental)
flutter run -d chrome
```

## Configuration

### Backend Connection

Update the backend URL in `lib/utils/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'http://localhost:8000'; // Change this
  // ... rest of the file
}
```

For testing on a physical device:
- Replace `localhost` with your computer's IP address
- Ensure the backend is accessible from the device's network
- Make sure CORS is properly configured in the backend

## API Endpoints

The frontend connects to the following ChaiBackend endpoints:

- `POST /api/v1/users/register` - User registration
- `POST /api/v1/users/login` - User login
- `POST /api/v1/users/logout` - User logout
- `GET /api/v1/users/current-user` - Get current user
- `PATCH /api/v1/users/update-account` - Update account details
- `POST /api/v1/users/change-password` - Change password
- `PATCH /api/v1/users/avatar-update` - Update avatar
- `PATCH /api/v1/users/coverImage-update` - Update cover image
- `GET /api/v1/users/c/:username` - Get channel profile
- `GET /api/v1/users/history` - Get watch history
- `POST /api/v1/users/refresh-token` - Refresh access token

## Development

### Running Tests

```bash
flutter test
```

### Code Formatting

```bash
flutter format lib/
```

### Analyzing Code

```bash
flutter analyze
```

## Features in Development

- [ ] Video upload functionality
- [ ] Video playback with controls
- [ ] Comments and likes
- [ ] Channel subscriptions
- [ ] Search functionality
- [ ] Notifications
- [ ] Dark mode support

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Related Projects

- [ChaiBackend](https://github.com/tarun1sisodia/ChaiBackend) - The backend API for this frontend

## Support

For issues or questions, please open an issue on the GitHub repository.
