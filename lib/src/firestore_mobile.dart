import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'firestore_interface.dart' as i;

Firestore setupFirestore({
  String webApiKey,
  String webAuthDomain,
  String webDatabaseUrl,
  String webProjectId,
  String webStorageBucket,
}) {
  return Firestore._(cf.Firestore.instance);
}

class Firestore implements i.Firestore {
  final cf.Firestore _firestore;

  Firestore._(this._firestore);

  CollectionReference collection(String path) =>
      CollectionReference._(_firestore.collection(path));

  DocumentReference document(String path) =>
      DocumentReference._(_firestore.document(path));

  Future<void> settings({bool persistence = true}) =>
      _firestore.settings(persistenceEnabled: persistence);
}

class CollectionReference extends Query implements i.CollectionReference {
  CollectionReference._(this._collectionReference)
      : super._(_collectionReference);

  final cf.CollectionReference _collectionReference;

  Future<DocumentReference> add(Map<String, dynamic> data) {
    return _collectionReference
        .add(data.map(_mapToType))
        .then((ref) => DocumentReference._(ref));
  }

  DocumentReference document([String path]) {
    return DocumentReference._(_collectionReference.document(path));
  }

  String get id => _collectionReference.id;

  DocumentReference get parent =>
      DocumentReference._(_collectionReference.parent());

  String get path => _collectionReference.path;
}

class Query implements i.Query {
  final cf.Query _query;

  Query._(this._query);

  Firestore get firestore => Firestore._(_query.firestore);

  Future<QuerySnapshot> getDocuments() =>
      _query.getDocuments().then((snapshot) => QuerySnapshot._(snapshot));

  Stream<QuerySnapshot> snapshots({bool includeMetadataChanges = false}) =>
      _query
          .snapshots(includeMetadataChanges: includeMetadataChanges)
          .map((snapshot) => QuerySnapshot._(snapshot));

  Query limit(int length) => Query._(_query.limit(length));

  Query orderBy(String field, {bool descending = false}) =>
      Query._(_query.orderBy(field, descending: descending));

  Query where(
    String fieldPath, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
  }) {
    return Query._(_query.where(
      fieldPath,
      isEqualTo: isEqualTo,
      isLessThan: isLessThan,
      isLessThanOrEqualTo: isLessThanOrEqualTo,
      isGreaterThan: isGreaterThan,
      isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
    ));
  }
}

class QuerySnapshot implements i.QuerySnapshot {
  final cf.QuerySnapshot _querySnapshot;

  QuerySnapshot._(this._querySnapshot);

  List<DocumentChange> get documentChanges => _querySnapshot.documentChanges
      .map((docChange) => DocumentChange._(docChange))
      .toList(growable: false);

  List<DocumentSnapshot> get documents => _querySnapshot.documents
      .map((docSnapshot) => DocumentSnapshot._(docSnapshot))
      .toList(growable: false);

  SnapshotMetadata get metadata => SnapshotMetadata(_querySnapshot.metadata);

  bool get isEmpty => documents.isEmpty;

  int get size => documents.length;
}

class DocumentChange implements i.DocumentChange {
  final cf.DocumentChange _documentChange;

  DocumentChange._(this._documentChange);

  DocumentSnapshot get document => DocumentSnapshot._(_documentChange.document);
  int get newIndex => _documentChange.newIndex;
  int get oldIndex => _documentChange.oldIndex;

  i.DocumentChangeType get type =>
      i.DocumentChangeType.values[_documentChange.type.index];
}

class DocumentSnapshot implements i.DocumentSnapshot {
  final cf.DocumentSnapshot _documentSnapshot;

  DocumentSnapshot._(this._documentSnapshot);

  String get id => _documentSnapshot.documentID;

  bool get exists => _documentSnapshot.exists;

  SnapshotMetadata get metadata => SnapshotMetadata(_documentSnapshot.metadata);

  DocumentReference get reference =>
      DocumentReference._(_documentSnapshot.reference);

  Map<String, dynamic> get data => _documentSnapshot.data.map(_mapToSharedType);

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => data[key];
}

class DocumentReference implements i.DocumentReference {
  final cf.DocumentReference _documentReference;

  DocumentReference._(this._documentReference);

  Firestore get firestore => Firestore._(_documentReference.firestore);

  String get id => _documentReference.documentID;

  CollectionReference get parent =>
      CollectionReference._(_documentReference.parent());

  String get path => _documentReference.path;

  CollectionReference collection(String collectionPath) =>
      CollectionReference._(_documentReference.collection(collectionPath));

  Future<DocumentSnapshot> get() =>
      _documentReference.get().then((snapshot) => DocumentSnapshot._(snapshot));

  Future<void> delete() => _documentReference.delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) {
    return _documentReference.setData(data.map(_mapToType), merge: merge);
  }

  Future<void> updateData(Map<String, dynamic> data) =>
      _documentReference.updateData(data.map(_mapToType));

  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) =>
      _documentReference
          .snapshots(includeMetadataChanges: includeMetadataChanges)
          .map((snapshot) => DocumentSnapshot._(snapshot));
}

class SnapshotMetadata implements i.SnapshotMetadata {
  final cf.SnapshotMetadata _snapshotMetadata;

  SnapshotMetadata(this._snapshotMetadata);

  bool get isFromCache => _snapshotMetadata.isFromCache;
  bool get hasPendingWrites => _snapshotMetadata.hasPendingWrites;
}

// --------- DATA TYPES ---------
/*
  Timestamp is converted to DateTime
*/
MapEntry<String, dynamic> _mapToSharedType(String key, dynamic value) {
  if (value is cf.GeoPoint) return MapEntry(key, _fromRawGeoPoint(value));
  if (value is cf.Timestamp) return MapEntry(key, value.toDate());
  if (value is cf.Blob) return MapEntry(key, i.Blob(value.bytes));

  return MapEntry(key, value);
}

MapEntry<String, dynamic> _mapToType(String key, dynamic value) {
  if (value is i.GeoPoint) return MapEntry(key, _toRawGeoPoint(value));
  if (value is DateTime) return MapEntry(key, cf.Timestamp.fromDate(value));
  if (value is i.Blob) return MapEntry(key, cf.Blob(value.bytes));

  return MapEntry(key, value);
}

i.GeoPoint _fromRawGeoPoint(cf.GeoPoint geoPoint) =>
    i.GeoPoint(geoPoint.latitude, geoPoint.longitude);

cf.GeoPoint _toRawGeoPoint(i.GeoPoint geoPoint) =>
    cf.GeoPoint(geoPoint.latitude, geoPoint.longitude);
