import 'package:firestore_all/firestore_all.dart';
import 'package:flutter/material.dart';

Firestore firestore;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  firestore = setupFirestore();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Firestore All Example')),
        body: ArticlesList(),
      ),
    );
  }
}

class ArticlesList extends StatelessWidget {
  const ArticlesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: firestore
          .collection('articles')
          .snapshots()
          .map((snapshot) => snapshot.documents),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final data = snapshot.data[index];

              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['content']),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error :('));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
