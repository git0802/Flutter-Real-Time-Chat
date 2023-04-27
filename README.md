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

## Additional Features

### Active Status

The app displays the active status of other users. To implement this feature, you can add a field to your user profiles collection that indicates the user's last active timestamp. You can then use Firebase Cloud Functions to update this field whenever a user opens or closes the app.

### Display Picture

The app allows users to change their display picture. To implement this feature, you can use Firebase Storage to store user profile pictures. You can then use the Firebase storage package in your Flutter code to upload and download profile pictures.

### Edit User Profile

The app allows users to edit their user profiles. To implement this feature, you can use Cloud Firestore to store user profiles and the Firebase cloud_firestore package in your Flutter code to update user profile data.

### View Other User's Profile

The app allows users to view other user's profiles. To implement this feature, you can add a new screen to your app that displays the user's profile picture, name, and any other relevant information.

### Send and Receive Images and Camera Taken Photos

The app allows users to send and receive images and also send and receive images taken from the camera. To implement this feature, you can use Firebase Storage to store the images and the Firebase storage package in your Flutter code to upload and download the images.

You can add a new button to the chat screen that allows the user to select an image from their device or take a photo with the camera. Once the image is selected or taken, you can use the ImagePicker package to get the image file and upload it to Firebase Storage.

To receive images, you can listen to changes in the messages collection and download any image files that are sent as messages. You can then display the images in the chat screen.

## Contributions

Contributions are welcome! If you find any bugs or issues with the app, please submit a GitHub issue or pull request.

