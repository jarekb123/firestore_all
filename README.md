# firestore_all

Plugin that wraps Firestore from `firebase` and `cloud_firestore` packages and expose them as a single API.

## Getting Started

To get the Firestore instance use `setupFirestore` function.

```dart
  var firestore = setupFirestore(
    webApiKey: 'apiKey',
    webAuthDomain: 'authDomain',
    webDatabaseUrl: 'databaseUrl',
    webProjectId: 'projectId',
    webStorageBucket: 'storageBucket',
  );
```

## TODO
* [x] Wrap Firestore from `firebase` package (for Flutter web) 
* [x] Wrap Firestore from `cloud_firestore` (for Flutter Android/iOS)
* [x] Test: Check if it's working on web
* [x] Test: Check if it's working on Android
* [ ] Test: Check if it's working on iOS
* [ ] Integrate with Firebase Auth