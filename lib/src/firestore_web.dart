import 'dart:typed_data';

import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart' as js;

Firestore setupFirestore({
  String webApiKey,
  String webAuthDomain,
  String webDatabaseUrl,
  String webProjectId,
  String webStorageBucket,
}) {
  final app = firebase.initializeApp(
    apiKey: webApiKey,
    authDomain: webAuthDomain,
    databaseURL: webDatabaseUrl,
    projectId: webProjectId,
    storageBucket: webStorageBucket,
  );

  return Firestore._(firebase.firestore(app));
}

class Firestore {
  final js.Firestore _firestore;

  Firestore._(this._firestore);

  @override
  CollectionReference collection(String path) =>
      CollectionReference._(_firestore.collection(path));

  @override
  DocumentReference document(String path) =>
      DocumentReference._(_firestore.doc(path));

  @override
  Future<void> settings({bool persistence = true}) async {
    if (persistence) {
      await _firestore.enablePersistence();
    }
  }
}

class CollectionReference extends Query {
  CollectionReference._(this._collectionReference)
      : super._(_collectionReference);

  final js.CollectionReference _collectionReference;

  @override
  Future<DocumentReference> add(Map<String, dynamic> data) {
    return _collectionReference
        .add(data.map(_mapToType))
        .then((ref) => DocumentReference._(ref));
  }

  @override
  DocumentReference document([String path]) {
    return DocumentReference._(_collectionReference.doc(path));
  }

  @override
  String get id => _collectionReference.id;

  @override
  DocumentReference get parent =>
      DocumentReference._(_collectionReference.parent);

  @override
  String get path => _collectionReference.path;
}

class Query {
  final js.Query _query;

  Query._(this._query);

  Firestore get firestore => Firestore._(_query.firestore);

  Future<QuerySnapshot> getDocuments() =>
      _query.get().then((snapshot) => QuerySnapshot._(snapshot));

  Stream<QuerySnapshot> snapshots({bool includeMetadataChanges = false}) {
    if (includeMetadataChanges) {
      return _query.onSnapshotMetadata
          .map((snapshot) => QuerySnapshot._(snapshot));
    } else {
      return _query.onSnapshot.map((snapshot) => QuerySnapshot._(snapshot));
    }
  }

  Query limit(int length) => Query._(_query.limit(length));

  Query orderBy(String field, {bool descending = false}) {
    var order = descending ? 'desc' : 'asc';

    return Query._(_query.orderBy(field, order));
  }

  Query where(
    String fieldPath, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
  }) {
    js.Query query = this._query;
    if (isEqualTo != null) {
      query = query.where(fieldPath, '==', isEqualTo);
    }
    if (isLessThan != null) {
      query = query.where(fieldPath, '<', isLessThan);
    }
    if (isLessThanOrEqualTo != null) {
      query = query.where(fieldPath, '<=', isLessThanOrEqualTo);
    }
    if (isGreaterThan != null) {
      query = query.where(fieldPath, '>', isGreaterThan);
    }
    if (isGreaterThanOrEqualTo != null) {
      query = query.where(fieldPath, '>=', isGreaterThanOrEqualTo);
    }

    return Query._(query);
  }
}

class QuerySnapshot {
  final js.QuerySnapshot _querySnapshot;

  QuerySnapshot._(this._querySnapshot);

  List<DocumentChange> get documentChanges => _querySnapshot
      .docChanges()
      .map((docChange) => DocumentChange._(docChange))
      .toList(growable: false);

  List<DocumentSnapshot> get documents => _querySnapshot.docs
      .map((docSnapshot) => DocumentSnapshot._(docSnapshot))
      .toList(growable: false);

  SnapshotMetadata get metadata => SnapshotMetadata(_querySnapshot.metadata);

  bool get isEmpty => documents.isEmpty;

  int get size => documents.length;
}

class DocumentChange {
  final js.DocumentChange _documentChange;

  DocumentChange._(this._documentChange);

  DocumentSnapshot get document => DocumentSnapshot._(_documentChange.doc);
  int get newIndex => _documentChange.newIndex;
  int get oldIndex => _documentChange.oldIndex;
  DocumentChangeType get type => _changeTypeFromString(_documentChange.type);
}

DocumentChangeType _changeTypeFromString(String type) {
  if (type == 'added') {
    return DocumentChangeType.added;
  } else if (type == 'removed') {
    return DocumentChangeType.removed;
  } else if (type == 'modified') {
    return DocumentChangeType.modified;
  } else {
    return null;
  }
}

class DocumentSnapshot {
  final js.DocumentSnapshot _documentSnapshot;

  DocumentSnapshot._(this._documentSnapshot);

  String get id => _documentSnapshot.id;

  bool get exists => _documentSnapshot.exists;

  SnapshotMetadata get metadata => SnapshotMetadata(_documentSnapshot.metadata);

  DocumentReference get reference => DocumentReference._(_documentSnapshot.ref);

  Map<String, dynamic> get data =>
      _documentSnapshot.data().map(_mapToSharedType);

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => data[key];
}

class DocumentReference {
  final js.DocumentReference _documentReference;

  DocumentReference._(this._documentReference);

  Firestore get firestore => Firestore._(_documentReference.firestore);

  String get id => _documentReference.id;

  CollectionReference get parent =>
      CollectionReference._(_documentReference.parent);

  String get path => _documentReference.path;

  CollectionReference collection(String collectionPath) =>
      CollectionReference._(_documentReference.collection(collectionPath));

  Future<DocumentSnapshot> get() =>
      _documentReference.get().then((snapshot) => DocumentSnapshot._(snapshot));

  Future<void> delete() => _documentReference.delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) {
    final options = js.SetOptions(merge: merge);

    return _documentReference.set(data.map(_mapToType), options);
  }

  Future<void> updateData(Map<String, dynamic> data) =>
      _documentReference.update(data: data.map(_mapToType));

  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) {
    if (includeMetadataChanges) {
      return _documentReference.onMetadataChangesSnapshot
          .map((snapshot) => DocumentSnapshot._(snapshot));
    } else {
      return _documentReference.onSnapshot
          .map((snapshot) => DocumentSnapshot._(snapshot));
    }
  }
}

class SnapshotMetadata {
  final js.SnapshotMetadata _snapshotMetadata;

  SnapshotMetadata(this._snapshotMetadata);

  bool get isFromCache => _snapshotMetadata.fromCache;
  bool get hasPendingWrites => _snapshotMetadata.hasPendingWrites;
}

// --------- DATA TYPES ---------
MapEntry<String, dynamic> _mapToSharedType(String key, dynamic value) {
  if (value is js.GeoPoint) return MapEntry(key, _fromRawGeoPoint(value));
  if (value is js.Blob) return MapEntry(key, Blob(value.toUint8Array()));

  return MapEntry(key, value);
}

MapEntry<String, dynamic> _mapToType(String key, dynamic value) {
  if (value is GeoPoint) return MapEntry(key, _toRawGeoPoint(value));
  if (value is Blob) return MapEntry(key, js.Blob.fromUint8Array(value.bytes));

  return MapEntry(key, value);
}

GeoPoint _fromRawGeoPoint(js.GeoPoint geoPoint) =>
    GeoPoint(geoPoint.latitude, geoPoint.longitude);

js.GeoPoint _toRawGeoPoint(GeoPoint geoPoint) =>
    js.GeoPoint(geoPoint.latitude, geoPoint.longitude);

class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final num latitude;
  final num longitude;
}

class Blob {
  const Blob(this.bytes);

  final Uint8List bytes;
}

enum DocumentChangeType { added, modified, removed }
