export 'src/firestore_interface.dart'
    if (dart.library.html) 'src/firestore_web.dart'
    if (dart.library.io) 'src/firestore_mobile.dart';

export 'package:firebase/firestore.dart'
    if (dart.library.io) 'package:cloud_firestore/cloud_firestore.dart'
    if (dart.library.html) 'package:firebase/firestore.dart' show FieldValue;

export 'src/firestore_interface.dart' show Blob, DocumentChangeType, GeoPoint;
