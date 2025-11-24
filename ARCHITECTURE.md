# Architecture Documentation

This document describes the architecture and design decisions of the ChaiFrontend application.

## Overview

ChaiFrontend is a Flutter-based mobile application that serves as the frontend for the ChaiBackend video platform. It follows a clean architecture pattern with clear separation of concerns.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│          Presentation Layer              │
│  (Screens, Widgets, UI Components)       │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Provider Layer                   │
│    (State Management, Business Logic)    │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│          Service Layer                   │
│    (API Calls, Data Operations)          │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│          Model Layer                     │
│    (Data Models, DTOs)                   │
└─────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── main.dart                   # Application entry point
├── models/                     # Data models
│   ├── user.dart              # User entity
│   └── video.dart             # Video entity
├── providers/                  # State management
│   └── auth_provider.dart     # Authentication state
├── screens/                    # UI screens
│   ├── login_screen.dart      # Login interface
│   ├── register_screen.dart   # Registration interface
│   ├── home_screen.dart       # Main dashboard
│   └── profile_screen.dart    # User profile
├── services/                   # Business logic
│   └── api_service.dart       # API communication
├── utils/                      # Utilities
│   └── api_constants.dart     # API endpoints
└── widgets/                    # Reusable components
```

## Design Patterns

### 1. Provider Pattern (State Management)

**Why Provider?**
- Simple and lightweight
- Built-in Flutter support
- Good for apps of this scale
- Easy to understand and maintain

**Implementation:**
```dart
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  
  void updateUser(User user) {
    _currentUser = user;
    notifyListeners(); // Notify UI to rebuild
  }
}
```

**Usage in UI:**
```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.currentUser?.name ?? 'Guest');
  },
)
```

### 2. Repository Pattern

**Service Layer as Repository:**
The `ApiService` class acts as a repository, abstracting the API communication details from the rest of the application.

```dart
class ApiService {
  Future<User> getCurrentUser() async {
    // HTTP call details hidden from caller
    final response = await _client.get(url);
    return User.fromJson(response);
  }
}
```

### 3. Singleton Pattern

**API Service:**
Uses a single HTTP client instance for all requests to optimize resource usage.

```dart
class ApiService {
  final http.Client _client = http.Client(); // Singleton instance
}
```

### 4. Factory Pattern

**Model Creation:**
Models use factory constructors for creating instances from JSON.

```dart
class User {
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      // ...
    );
  }
}
```

## State Management Flow

### Authentication Flow

```
User Action (Login Button)
        ↓
AuthProvider.login()
        ↓
ApiService.login()
        ↓
HTTP Request to Backend
        ↓
Save Tokens (SharedPreferences)
        ↓
Update AuthProvider State
        ↓
notifyListeners()
        ↓
UI Rebuilds (Navigate to Home)
```

### Data Flow

```
UI Widget Request
        ↓
Provider Method Call
        ↓
Service Layer (API Call)
        ↓
Backend Response
        ↓
Model Parsing (fromJson)
        ↓
Provider State Update
        ↓
UI Automatic Rebuild
```

## Component Communication

### Widget to Provider
```dart
// In widget
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.login(username, password);
```

### Provider to Service
```dart
// In AuthProvider
class AuthProvider {
  final ApiService _apiService = ApiService();
  
  Future<bool> login() async {
    final response = await _apiService.login(...);
    _currentUser = User.fromJson(response['data']);
    notifyListeners();
    return true;
  }
}
```

### Service to API
```dart
// In ApiService
Future<Map<String, dynamic>> login() async {
  final response = await _client.post(
    Uri.parse('$baseUrl/login'),
    body: json.encode({...}),
  );
  return json.decode(response.body);
}
```

## Key Components

### 1. Main App (main.dart)

**Responsibilities:**
- Initialize app
- Set up providers
- Configure theme
- Determine initial route

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
}
```

### 2. Auth Wrapper

**Responsibilities:**
- Check authentication state
- Show appropriate screen
- Handle loading states

```dart
class AuthWrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) return LoadingScreen();
        if (auth.isAuthenticated) return HomeScreen();
        return LoginScreen();
      },
    );
  }
}
```

### 3. AuthProvider

**Responsibilities:**
- Manage authentication state
- Handle login/logout/register
- Token management
- User data management
- Notify UI of changes

### 4. ApiService

**Responsibilities:**
- HTTP communication
- Request/response handling
- Token injection
- Error handling
- File uploads

### 5. Models

**Responsibilities:**
- Data structure definition
- JSON serialization/deserialization
- Type safety
- Data validation

## Security Architecture

### Token Management

```
┌──────────────────────────────────────┐
│   Token Storage (SharedPreferences)   │
│   - accessToken                       │
│   - refreshToken                      │
└────────────┬─────────────────────────┘
             │
             ↓
┌────────────────────────────────────────┐
│   ApiService Token Injection           │
│   Headers['Authorization'] = 'Bearer...'│
└────────────┬───────────────────────────┘
             │
             ↓
┌────────────────────────────────────────┐
│   Automatic Token Refresh              │
│   On 401 → refreshAccessToken()        │
└────────────────────────────────────────┘
```

### Data Flow Security

1. **User Input** → Validated in UI
2. **API Request** → HTTPS in production
3. **Token** → Bearer token authentication
4. **Response** → Parsed and validated
5. **Storage** → Encrypted (iOS) / Sandboxed (Android)

## Error Handling Strategy

### Layered Error Handling

```
UI Layer (Screens)
    ↓ Show user-friendly messages
Provider Layer
    ↓ Catch and format errors
Service Layer
    ↓ Handle HTTP errors
API/Network Layer
    ↓ Throw exceptions
```

### Implementation

```dart
// Service Layer
Future<User> getCurrentUser() async {
  try {
    final response = await _client.get(...);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed: ${response.body}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}

// Provider Layer
Future<void> refreshUser() async {
  try {
    _currentUser = await _apiService.getCurrentUser();
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  }
}

// UI Layer
if (authProvider.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.error!)),
  );
}
```

## Navigation Architecture

### Navigation Stack

```
LoginScreen (Root)
    ↓ login successful
HomeScreen (Replace)
    ↓ bottom nav item selected
ProfileScreen (Within tabs)
    ↓ edit button
EditProfileDialog (Modal)
```

### Implementation
- Use `Navigator.pushReplacement` for auth transitions
- Use `BottomNavigationBar` for main navigation
- Use `showDialog` for modals and confirmations

## Performance Considerations

### 1. Image Optimization
- Use `CachedNetworkImage` for remote images
- Cache images to reduce network calls
- Lazy load images in lists

### 2. State Management
- Use `Consumer` for targeted rebuilds
- Avoid rebuilding entire tree
- Use `const` constructors where possible

### 3. API Calls
- Reuse HTTP client instance
- Implement request caching (future enhancement)
- Use pagination for lists (future enhancement)

### 4. Memory Management
- Dispose controllers and subscriptions
- Clear cached data when not needed
- Use weak references where appropriate

## Testing Strategy

### Unit Tests
- Test models (JSON parsing)
- Test provider logic
- Test service methods

### Widget Tests
- Test screen rendering
- Test user interactions
- Test navigation

### Integration Tests
- Test complete user flows
- Test API integration
- Test state persistence

## Future Architecture Enhancements

### 1. Dependency Injection
- Use GetIt or similar for service location
- Improve testability
- Better separation of concerns

### 2. Feature-based Structure
```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── videos/
│   └── profile/
```

### 3. Clean Architecture
- Separate domain, data, and presentation layers
- Use use cases for business logic
- Repository pattern with interfaces

### 4. Offline Support
- Local database (SQLite/Hive)
- Sync mechanism
- Offline queue for operations

### 5. Real-time Updates
- WebSocket integration
- Push notifications
- Live data synchronization

## Scalability Considerations

### Current Scale
- Suitable for: Small to medium apps
- User base: Up to 10,000 users
- Concurrent users: Up to 1,000

### Scaling Path
1. **Phase 1:** Add caching layer
2. **Phase 2:** Implement pagination
3. **Phase 3:** Add CDN for media
4. **Phase 4:** Implement microservices
5. **Phase 5:** Add load balancing

## Monitoring and Debugging

### Development
- Flutter DevTools for debugging
- Network inspector for API calls
- Provider.debugCheckInvalidValueType

### Production (Future)
- Firebase Crashlytics
- Analytics integration
- Error reporting (Sentry)
- Performance monitoring

## Best Practices Followed

1. **Single Responsibility:** Each class has one clear purpose
2. **DRY:** Reusable widgets and utilities
3. **SOLID Principles:** Applied where appropriate
4. **Type Safety:** Strong typing throughout
5. **Error Handling:** Comprehensive error management
6. **Documentation:** Code comments and docs
7. **Testing:** Test infrastructure in place
8. **Version Control:** Git with meaningful commits

## Contributing to Architecture

When making architectural changes:
1. Update this document
2. Follow existing patterns
3. Discuss major changes in issues
4. Consider backward compatibility
5. Update tests accordingly

## References

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
