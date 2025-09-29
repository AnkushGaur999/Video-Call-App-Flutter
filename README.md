# Video Call App

A Flutter application that enables users one-to-one video call, with features like screen sharing, camera and microphone controls.

## Features

*   **Video Calling:** High-quality video and audio communication.
*   **Screen Sharing:** Share your device screen during a call.
*   **Camera Control:** Toggle your camera on/off and switch between front and rear cameras.
*   **Microphone Control:** Mute and unmute your microphone.
*   **Real-time Notifications:** Get notified for incoming calls.
*   **Connection Status:** Monitor your connection state during calls.

## Technologies Used

*   **Flutter:** For building the cross-platform mobile application.
*   **Agora RTC SDK:** To power the real-time communication features.

## Getting Started

This project is a starting point for a Flutter application.

To get started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Prerequisites

*   Required Flutter SDK (version >= 3.35): [Installation Guide](https://docs.flutter.dev/get-started/install)
*   An IDE like Android Studio or VS Code with the Flutter plugin.
*   An Agora developer account and App ID.

### Setup

1.  **Clone the repository:**
    ```bash
    git clone [Repository](https://github.com/AnkushGaur999/Video-Call-App-Flutter.git)
    cd video_call_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Agora:**
    *   Open `lib/src/config/services/call_service.dart`.
    *   Replace the placeholder `_appId` and `_token` with your actual Agora App ID and a valid token.
        ```dart
        static const String _appId = "YOUR_AGORA_APP_ID"; // Replace with your App ID
        static const String _token = "YOUR_AGORA_TOKEN"; // Replace with a valid token
        static const String _channel = "test"; // Or your desired channel name
        ```

### Running the Application

1.  Ensure you have a connected device or an emulator running.
2.  Run the app using the Flutter CLI:
    ```bash
    flutter run
    ```

## Login Credentials

For testing purposes, you can use the following credentials:

*   **Email:** john@gmail.com
*   **Password:** 123456

## Project Structure (lib/src)

*   **config:** Contains application-level configurations like routing (`app_routes.dart`), services (`call_service.dart`, `notification_service.dart`), and data state management (`data_state.dart`).
*   **core:** Core utilities and constants, like application colors (`app_colors.dart`).
*   **data:** Data layer, including models (`login_response.dart`, `video_call_data.dart`).
*   **domain:** Domain layer, with repositories (`auth_repository.dart`) and use cases (`login_use_case.dart`).
*   **presentation:** UI layer (details would be added as UI is built).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
