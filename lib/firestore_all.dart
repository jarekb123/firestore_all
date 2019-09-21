export 'src/firestore_unsupported.dart'
    if (dart.library.html) 'src/firestore_web.dart'
    if (dart.library.io) 'src/firestore_mobile.dart';
