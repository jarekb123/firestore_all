import 'dart:typed_data';

typedef FirestoreInterface SetupFirestore({
  String webApiKey,
  String webAuthDomain,
  String webDatabaseUrl,
  String webProjectId,
  String webStorageBucket,
});

abstract class FirestoreApp {}

abstract class FirestoreInterface {
  const FirestoreInterface();

  CollectionReference collection(String path);
  DocumentReference document(String path);
  Future<void> settings({bool persistence});
}

abstract class Query {
  /// Non-null [FirestoreInterface] for the Cloud Firestore database (useful for performing transactions, etc.).
  FirestoreInterface get firestore;

  /// Fetch the documents for this query
  Future<QuerySnapshot> getDocuments();

  Stream<QuerySnapshot> snapshots({bool includeMetadataChanges = false});

  Query limit(int length);
  Query orderBy(String field, {bool descending = false});
  Query where(
    String field, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
  });
}

abstract class QuerySnapshot {
  List<DocumentChange> get documentChanges;
  List<DocumentSnapshot> get documents;
  SnapshotMetadata get metadata;
  bool get isEmpty;
  int get size;
}

abstract class DocumentChange {
  DocumentSnapshot get document;
  int get newIndex;
  int get oldIndex;
  DocumentChangeType get type;
}

enum DocumentChangeType { added, modified, removed }

abstract class DocumentSnapshot {
  String get id;
  bool get exists;
  SnapshotMetadata get metadata;
  DocumentReference get reference;
  Map<String, dynamic> get data;

  /// Reads individual values from the snapshot
  dynamic operator [](String key);
}

abstract class DocumentReference {
  FirestoreInterface get firestore;
  String get id;
  CollectionReference get parent;
  String get path;

  CollectionReference collection(String collectionPath);

  Future<DocumentSnapshot> get();
  Future<void> delete();
  Future<void> setData(Map<String, dynamic> data, {bool merge = false});
  Future<void> updateData(Map<String, dynamic> data);

  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false});
}

abstract class SnapshotMetadata {
  bool get isFromCache;
  bool get hasPendingWrites;
}

abstract class CollectionReference extends Query {
  String get id;
  DocumentReference get parent;
  String get path;

  DocumentReference document([String path]);
  Future<DocumentReference> add(Map<String, dynamic> data);
}

// --------- DATA TYPES ---------
/*
  Timestamp is converted to DateTime
*/
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final num latitude;
  final num longitude;
}

class Blob {
  const Blob(this.bytes);

  final Uint8List bytes;
}
