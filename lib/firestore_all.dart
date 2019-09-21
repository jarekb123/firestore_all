export 'src/firestore_interface.dart'
  if (dart.library.io) 'src/firestore_mobile.dart'
  if (dart.library.html) 'src/firestore_web.dart';