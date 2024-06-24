
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DoctorSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctors')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var results = snapshot.data!.docs.where((doc) {
          final name = (doc.data() as Map<String, dynamic>)['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        return ListView(
          children: results.map<Widget>((doc) => ListTile(
            title: Text((doc.data() as Map)['name']),
            subtitle: Text((doc.data() as Map)['specialization']),
            onTap: () {
            
            },
          )).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
