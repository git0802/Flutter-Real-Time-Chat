# Chat With Me

This is a Flutter chat app that allows users to send and receive messages, images, and videos in real-time. The app uses Firebase as a backend service for storing messages and handling user authentication

## Features

- User authentication (sign up, sign in, sign out)
- Real-time messaging with other users
- Ability to send text messages, images, and videos
- Push notifications for new messages
- Active status of users
- Ability to change display picture
- Edit user profile
- View other user's profile
- Ability to send and receive images taken from the camera

## Prerequisites

- Flutter SDK
- Firebase account

## Firebase Authentication

The app uses Firebase Authentication to handle user sign up, sign in, and sign out. To enable Firebase Authentication for your project, follow these steps:

1. Create a new Firebase project in the Firebase console.
2. Add an Android app or an iOS app to your project.
3. Follow the setup instructions to download and add the configuration files to your app.
4. In the Firebase console, navigate to Authentication and enable the sign-in methods you want to use for your app (e.g. email and password, Google Sign-In, Facebook Login).

Once you have enabled Firebase Authentication, you can use the Firebase auth package in your Flutter code to implement authentication logic.

## Firebase Cloud Firestore

The app uses Firebase Cloud Firestore to store messages and user profiles. To enable Cloud Firestore for your project, follow these steps:

1. In the Firebase console, navigate to Firestore and create a new Cloud Firestore database.
2. Choose the test mode security rules for now.
3. Create a new collection for storing messages and a new collection for storing user profiles.
4. Add the necessary read and write rules for your collections.

Once you have set up Cloud Firestore, you can use the Firebase cloud_firestore package in your Flutter code to interact with the database.

## Additional Features

### Active Status

The app displays the active status of other users. To implement this feature, you can add a field to your user profiles collection that indicates the user's last active timestamp. You can then use Firebase Cloud Functions to update this field whenever a user opens or closes the app.

