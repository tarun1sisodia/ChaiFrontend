# API Integration Documentation

This document describes how the ChaiFrontend integrates with the ChaiBackend API.

## Base Configuration

The API configuration is defined in `lib/utils/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';
}
```

## Authentication Flow

### 1. Registration

**Endpoint:** `POST /api/v1/users/register`

**Request Type:** multipart/form-data

**Fields:**
- `username` (String, required)
- `email` (String, required)
- `password` (String, required)
- `fullName` (String, required)
- `avatar` (File, required)
- `coverImage` (File, optional)

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "user": {
      "_id": "...",
      "username": "john_doe",
      "email": "john@example.com",
      "fullName": "John Doe",
      "avatar": "https://cloudinary.com/...",
      "coverImage": "https://cloudinary.com/..."
    },
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

**Frontend Implementation:**
```dart
final success = await authProvider.register(
  username: username,
  email: email,
  password: password,
  fullName: fullName,
  avatar: avatarFile,
  coverImage: coverImageFile,
);
```

### 2. Login

**Endpoint:** `POST /api/v1/users/login`

**Request Type:** application/json

**Body:**
```json
{
  "username": "john_doe",
  "password": "password123"
}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "user": {
      "_id": "...",
      "username": "john_doe",
      "email": "john@example.com",
      "fullName": "John Doe",
      "avatar": "https://cloudinary.com/...",
      "coverImage": "https://cloudinary.com/..."
    },
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

**Frontend Implementation:**
```dart
final success = await authProvider.login(
  username: username,
  password: password,
);
```

### 3. Logout

**Endpoint:** `POST /api/v1/users/logout`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "User logged out successfully"
}
```

**Frontend Implementation:**
```dart
await authProvider.logout();
```

### 4. Refresh Token

**Endpoint:** `POST /api/v1/users/refresh-token`

**Body:**
```json
{
  "refreshToken": "eyJhbGc..."
}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

## User Profile Management

### 1. Get Current User

**Endpoint:** `GET /api/v1/users/current-user`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "_id": "...",
    "username": "john_doe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "avatar": "https://cloudinary.com/...",
    "coverImage": "https://cloudinary.com/...",
    "watchHistory": [],
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  }
}
```

### 2. Update Account Details

**Endpoint:** `PATCH /api/v1/users/update-account`

**Headers:**
```
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "fullName": "John Updated Doe",
  "email": "newemail@example.com"
}
```

**Frontend Implementation:**
```dart
final success = await authProvider.updateProfile(
  fullName: fullName,
  email: email,
);
```

### 3. Change Password

**Endpoint:** `POST /api/v1/users/change-password`

**Headers:**
```
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "oldPassword": "oldpass123",
  "newPassword": "newpass123"
}
```

**Frontend Implementation:**
```dart
final success = await authProvider.changePassword(
  oldPassword: oldPassword,
  newPassword: newPassword,
);
```

### 4. Update Avatar

**Endpoint:** `PATCH /api/v1/users/avatar-update`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Type:** multipart/form-data

**Fields:**
- `avatar` (File, required)

**Frontend Implementation:**
```dart
final success = await authProvider.updateAvatar(avatarFile);
```

### 5. Update Cover Image

**Endpoint:** `PATCH /api/v1/users/coverImage-update`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Type:** multipart/form-data

**Fields:**
- `coverImage` (File, required)

**Frontend Implementation:**
```dart
final success = await authProvider.updateCoverImage(coverImageFile);
```

### 6. Get Channel Profile

**Endpoint:** `GET /api/v1/users/c/:username`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "user": { ... },
    "subscribersCount": 0,
    "subscribedToCount": 0,
    "isSubscribed": false
  }
}
```

### 7. Get User History

**Endpoint:** `GET /api/v1/users/history`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": [
    {
      "_id": "...",
      "videoFile": "https://cloudinary.com/...",
      "thumbnail": "https://cloudinary.com/...",
      "title": "Video Title",
      "description": "Video Description",
      "time": 120,
      "views": 1000,
      "isPublished": true,
      "owner": "...",
      "createdAt": "2023-01-01T00:00:00.000Z"
    }
  ]
}
```

## Token Management

### Storage
Tokens are stored using `shared_preferences` package:
- Key: `accessToken`
- Key: `refreshToken`

### Automatic Refresh
The frontend automatically handles token refresh when:
- Access token expires (JWT exp check)
- API returns 401 Unauthorized

### Token Flow
1. User logs in → Tokens saved to SharedPreferences
2. API calls include `Authorization: Bearer {accessToken}` header
3. On 401 error → Refresh token is used to get new access token
4. New tokens are saved and request is retried
5. If refresh fails → User is logged out

## Error Handling

### Standard Error Response
```json
{
  "statusCode": 400,
  "message": "Error message",
  "errors": []
}
```

### Frontend Error Handling
```dart
try {
  final response = await apiService.someMethod();
  // Success handling
} catch (e) {
  // Error is displayed to user via SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
```

## API Service Layer

The `ApiService` class (`lib/services/api_service.dart`) provides:

1. **HTTP Client Management**
   - Singleton http.Client instance
   - Automatic header injection

2. **Token Management**
   - Token storage and retrieval
   - Automatic token refresh
   - Token expiry handling

3. **Request Methods**
   - GET, POST, PATCH, DELETE
   - Multipart file uploads
   - JSON request/response handling

4. **Error Handling**
   - Network errors
   - HTTP error codes
   - JSON parsing errors

## State Management

Authentication state is managed using Provider:

```dart
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  
  // Methods
  Future<bool> login(...) async { ... }
  Future<bool> register(...) async { ... }
  Future<void> logout() async { ... }
  Future<void> refreshUser() async { ... }
}
```

## Usage Example

```dart
// In a widget
final authProvider = Provider.of<AuthProvider>(context);

if (authProvider.isLoading) {
  return CircularProgressIndicator();
}

if (!authProvider.isAuthenticated) {
  return LoginScreen();
}

return HomeScreen();
```

## Future Enhancements

Planned API integrations:
- Video upload
- Video listing and search
- Comments and likes
- Subscriptions
- Notifications
- Real-time updates

## Testing the API

### Using cURL

```bash
# Register
curl -X POST http://localhost:8000/api/v1/users/register \
  -F "username=testuser" \
  -F "email=test@example.com" \
  -F "password=password123" \
  -F "fullName=Test User" \
  -F "avatar=@/path/to/avatar.jpg"

# Login
curl -X POST http://localhost:8000/api/v1/users/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123"}'

# Get current user
curl -X GET http://localhost:8000/api/v1/users/current-user \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Using Postman

1. Import the ChaiBackend API collection
2. Set up environment variables for baseUrl and tokens
3. Test each endpoint individually

## Security Considerations

1. **Tokens are stored securely** using SharedPreferences (encrypted on iOS)
2. **HTTPS should be used** in production
3. **Tokens are never logged** or exposed in UI
4. **Password is never stored** locally
5. **File uploads are validated** on backend

## Support

For API-related issues:
1. Check backend logs
2. Verify backend is running
3. Check network connectivity
4. Verify CORS configuration
5. Open an issue on GitHub
