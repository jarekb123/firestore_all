import 'dart:typed_data';

Firestore setupFirestore({
  String webApiKey,
  String webAuthDomain,
  String webDatabaseUrl,
  String webProjectId,
  String webStorageBucket,
}) {
  throw Exception('You cannot use Firestore in this environment');
}

class FirestoreApp {}

abstract class Firestore {
  const Firestore();

  CollectionReference collection(String path) => null;
  DocumentReference document(String path) => null;
  Future<void> settings({bool persistence}) => null;
}

class Query {
  /// Non-null [Firestore] for the Cloud Firestore database (useful for performing transactions, etc.).
  Firestore get firestore => null;

  /// Fetch the documents for this query
  Future<QuerySnapshot> getDocuments() => null;

  Stream<QuerySnapshot> snapshots({bool includeMetadataChanges = false}) =>
      null;

  Query limit(int length) => null;
  Query orderBy(String field, {bool descending = false}) => null;
  Query where(
    String field, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
  }) =>
      null;
}

class QuerySnapshot {
  List<DocumentChange> get documentChanges => null;
  List<DocumentSnapshot> get documents => null;
  SnapshotMetadata get metadata => null;
  bool get isEmpty => null;
  int get size => null;
}

class DocumentChange {
  DocumentSnapshot get document => null;
  int get newIndex => null;
  int get oldIndex => null;
  DocumentChangeType get type => null;
}

class DocumentSnapshot {
  String get id => null;
  bool get exists => null;
  SnapshotMetadata get metadata => null;
  DocumentReference get reference => null;
  Map<String, dynamic> get data => null;

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => null;
}

class DocumentReference {
  Firestore get firestore => null;
  String get id => null;
  CollectionReference get parent => null;
  String get path => null;

  CollectionReference collection(String collectionPath) => null;

  Future<DocumentSnapshot> get() => null;
  Future<void> delete() => null;
  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) => null;
  Future<void> updateData(Map<String, dynamic> data) => null;

  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) =>
      null;
}

class SnapshotMetadata {
  bool get isFromCache => null;
  bool get hasPendingWrites => null;
}

class CollectionReference extends Query {
  String get id => null;
  DocumentReference get parent => null;
  String get path => null;

  DocumentReference document([String path]) => null;
  Future<DocumentReference> add(Map<String, dynamic> data) => null;
}

enum DocumentChangeType { added, modified, removed }

class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final num latitude;
  final num longitude;
}

class Blob {
  const Blob(this.bytes);

  final Uint8List bytes;
}
