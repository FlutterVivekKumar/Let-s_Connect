# Let's Connect Chat App

## Overview
Let's Connect is a simple chat application designed to connect users and facilitate communication through text messages. This application allows users to send and receive messages in real-time and receive notifications for new messages.

## Features
- **Real-time Messaging**: Users can send and receive messages in real-time, enabling seamless communication.
- **Notification**: Users receive notifications for new messages, ensuring they stay updated even when the app is not active.
- **Simple and Intuitive Interface**: The app provides a user-friendly interface, making it easy for users to navigate and interact with the chat features.

## Technologies Used
- **Flutter**: The front-end of the application is built using the Flutter framework, allowing for cross-platform compatibility.
- **Firebase Cloud Firestore**: Firestore is used as the backend database to store chat messages and user data.
- **Firebase Cloud Messaging (FCM)**: FCM is utilized for sending push notifications to users' devices.

## Screenshots
## Screenshots

|  SignUp Screen | Login Screen |  Splash Screen | Chat Screen  | Drawer  |
| --- | --- |  --- |  --- |  --- |  
| ![](https://github.com/FlutterVivekKumar/Let-s_Connect/blob/main/screenshots/Screenshot_20240412_124937.jpg) | ![](https://github.com/FlutterVivekKumar/Let-s_Connect/blob/main/screenshots/Screenshot_20240412_124933.jpg) | ![](https://github.com/FlutterVivekKumar/Let-s_Connect/blob/main/screenshots/Screenshot_20240412_124928.jpg) | ![](https://github.com/FlutterVivekKumar/Let-s_Connect/blob/main/screenshots/Screenshot_20240412_131551.jpg) | ![](https://github.com/FlutterVivekKumar/Let-s_Connect/blob/main/screenshots/Screenshot_20240412_124923.jpg) |


## Installation
To run the Let's Connect chat app on your local machine, follow these steps:

1. Clone the repository to your local machine:
   ```
   git clone https://github.com/FlutterVivekKumar/Let-s_Connect.git
   ```

2. Navigate to the project directory:
   ```
   cd lets_connect_app
   ```

3. Install dependencies using Flutter's package manager:
   ```
   flutter pub get
   ```

4. Set up Firebase for your project:
    - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
    - Follow the instructions to add your Android and iOS apps to the Firebase project.
    - Enable Firebase Cloud Firestore and Firebase Cloud Messaging services.
    - Download the `google-services.json` file for Android and `GoogleService-Info.plist` file for iOS, and place them in the respective directories of your Flutter project.
    - Configure your Firebase project settings according to your requirements.

5. Run the app on your desired device using Flutter:
   ```
   flutter run
   ```

## Usage
- Upon launching the app, users can sign in or create an account to access the chat features.
- Users can start new conversations by  sending messages in the chat interface.
- Notifications will be delivered to users' devices when they receive new messages, even if the app is in the background.

## Contributing
Contributions to the Let's Connect chat app are welcome! If you encounter any bugs, have feature requests, or would like to contribute code, please feel free to open an issue or submit a pull request on the GitHub repository.

## License
This project is licensed under the [MIT License](LICENSE). Feel free to use and modify the code for your own purposes.
