# firestore_all

Plugin that wraps Firestore from `firebase` and `cloud_firestore` packages and expose them as a single API.

## Getting Started

### Shared

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

### Web
Add following code to `index.html` in `web` directory.
```html
<script src="https://www.gstatic.com/firebasejs/5.10.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/5.10.1/firebase-firestore.js"></script>
```

## TODO
* [x] Wrap Firestore from `firebase` package (for Flutter web) 
* [x] Wrap Firestore from `cloud_firestore` (for Flutter Android/iOS)
* [ ] Test: Check if it's working on web
  * [x] snapshot streams
  * [ ] add, update, edit
  * [ ] get document
* [x] Test: Check if it's working on Android
* [ ] Test: Check if it's working on iOS
* [ ] Integrate with Firebase Auth
