import 'package:cloud_firestore/cloud_firestore.dart' as cf;

import 'firestore_interface.dart';

Firestore setupFirestore({
  String webApiKey,
  String webAuthDomain,
  String webDatabaseUrl,
  String webProjectId,
  String webStorageBucket,
}) {
  return Firestore._(cf.Firestore.instance);
}

class Firestore implements FirestoreInterface {
  final cf.Firestore _firestore;

  Firestore._(this._firestore);

  @override
  CollectionReference collection(String path) =>
      MobileCollectionReference._(_firestore.collection(path));

  @override
  DocumentReference document(String path) =>
      MobileDocumentReference._(_firestore.document(path));

  @override
  Future<void> settings({bool persistence = true}) =>
      _firestore.settings(persistenceEnabled: persistence);
}

class MobileCollectionReference extends MobileQuery
    implements CollectionReference {
  MobileCollectionReference._(this._collectionReference)
      : super._(_collectionReference);

  final cf.CollectionReference _collectionReference;

  @override
  Future<DocumentReference> add(Map<String, dynamic> data) {
    return _collectionReference
        .add(data.map(_mapToMobileType))
        .then((ref) => MobileDocumentReference._(ref));
  }

  @override
  DocumentReference document([String path]) {
    return MobileDocumentReference._(_collectionReference.document(path));
  }

  @override
  String get id => _collectionReference.id;

  @override
  DocumentReference get parent =>
      MobileDocumentReference._(_collectionReference.parent());

  @override
  String get path => _collectionReference.path;
}

class MobileQuery implements Query {
  final cf.Query _query;

  MobileQuery._(this._query);

  FirestoreInterface get firestore => Firestore._(_query.firestore);

  Future<QuerySnapshot> getDocuments() =>
      _query.getDocuments().then((snapshot) => MobileQuerySnapshot._(snapshot));

  Stream<QuerySnapshot> snapshots({bool includeMetadataChanges = false}) =>
      _query
          .snapshots(includeMetadataChanges: includeMetadataChanges)
          .map((snapshot) => MobileQuerySnapshot._(snapshot));

  Query limit(int length) => MobileQuery._(_query.limit(length));

  Query orderBy(String field, {bool descending = false}) =>
      MobileQuery._(_query.orderBy(field, descending: descending));

  Query where(
    String fieldPath, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
  }) {
    return MobileQuery._(_query.where(
      fieldPath,
      isEqualTo: isEqualTo,
      isLessThan: isLessThan,
      isLessThanOrEqualTo: isLessThanOrEqualTo,
      isGreaterThan: isGreaterThan,
      isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
    ));
  }
}

class MobileQuerySnapshot implements QuerySnapshot {
  final cf.QuerySnapshot _querySnapshot;

  MobileQuerySnapshot._(this._querySnapshot);

  List<DocumentChange> get documentChanges => _querySnapshot.documentChanges
      .map((docChange) => MobileDocumentChange._(docChange))
      .toList(growable: false);

  List<DocumentSnapshot> get documents => _querySnapshot.documents
      .map((docSnapshot) => MobileDocumentSnapshot._(docSnapshot))
      .toList(growable: false);

  SnapshotMetadata get metadata =>
      MobileSnapshotMetadata(_querySnapshot.metadata);

  bool get isEmpty => documents.isEmpty;

  int get size => documents.length;
}

class MobileDocumentChange implements DocumentChange {
  final cf.DocumentChange _documentChange;

  MobileDocumentChange._(this._documentChange);

  DocumentSnapshot get document =>
      MobileDocumentSnapshot._(_documentChange.document);
  int get newIndex => _documentChange.newIndex;
  int get oldIndex => _documentChange.oldIndex;
  DocumentChangeType get type =>
      DocumentChangeType.values[_documentChange.type.index];
}

class MobileDocumentSnapshot implements DocumentSnapshot {
  final cf.DocumentSnapshot _documentSnapshot;

  MobileDocumentSnapshot._(this._documentSnapshot);

  String get id => _documentSnapshot.documentID;

  bool get exists => _documentSnapshot.exists;

  SnapshotMetadata get metadata =>
      MobileSnapshotMetadata(_documentSnapshot.metadata);

  DocumentReference get reference =>
      MobileDocumentReference._(_documentSnapshot.reference);

  Map<String, dynamic> get data => _documentSnapshot.data.map(_mapToSharedType);

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => data[key];
}

class MobileDocumentReference implements DocumentReference {
  final cf.DocumentReference _documentReference;

  MobileDocumentReference._(this._documentReference);

  FirestoreInterface get firestore => Firestore._(_documentReference.firestore);

  String get id => _documentReference.documentID;

  CollectionReference get parent =>
      MobileCollectionReference._(_documentReference.parent());

  String get path => _documentReference.path;

  CollectionReference collection(String collectionPath) =>
      MobileCollectionReference._(
          _documentReference.collection(collectionPath));

  Future<DocumentSnapshot> get() => _documentReference
      .get()
      .then((snapshot) => MobileDocumentSnapshot._(snapshot));

  Future<void> delete() => _documentReference.delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) {
    return _documentReference.setData(data.map(_mapToMobileType), merge: merge);
  }

  Future<void> updateData(Map<String, dynamic> data) =>
      _documentReference.updateData(data.map(_mapToMobileType));

  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) =>
      _documentReference
          .snapshots(includeMetadataChanges: includeMetadataChanges)
          .map((snapshot) => MobileDocumentSnapshot._(snapshot));
}

class MobileSnapshotMetadata implements SnapshotMetadata {
  final cf.SnapshotMetadata _snapshotMetadata;

  MobileSnapshotMetadata(this._snapshotMetadata);

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
  if (value is cf.Blob) return MapEntry(key, Blob(value.bytes));

  return MapEntry(key, value);
}

MapEntry<String, dynamic> _mapToMobileType(String key, dynamic value) {
  if (value is GeoPoint) return MapEntry(key, _toRawGeoPoint(value));
  if (value is DateTime) return MapEntry(key, cf.Timestamp.fromDate(value));
  if (value is Blob) return MapEntry(key, cf.Blob(value.bytes));

  return MapEntry(key, value);
}

GeoPoint _fromRawGeoPoint(cf.GeoPoint geoPoint) =>
    GeoPoint(geoPoint.latitude, geoPoint.longitude);

cf.GeoPoint _toRawGeoPoint(GeoPoint geoPoint) =>
    cf.GeoPoint(geoPoint.latitude, geoPoint.longitude);
