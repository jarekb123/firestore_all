export 'src/firestore_interface.dart'
    if (dart.library.html) 'src/firestore_web.dart'
    if (dart.library.io) 'src/firestore_mobile.dart';

export 'src/firestore_interface.dart' show Blob, DocumentChangeType, GeoPoint;
