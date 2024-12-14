import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        _searchResults = querySnapshot.docs
            .map((doc) => {
                  'title': doc['title'],
                  'imageUrl': doc['imageUrl'],
                })
            .toList();
      });
    } catch (e) {
      print("Error fetching search results: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching search results: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Search for Products',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onChanged: _search,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20.0),
                  child: Text(
                    'Search Results',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_searchResults.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Start typing to search for products'
                          : 'The product that you are looking for is not available',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Column(
                    children: _searchResults.map((product) {
                      return ListTile(
                        leading: Container(
                          height: 56.0,
                          width: 56.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.0),
                            border: Border.all(width: 0.3, color: Colors.grey),
                            image: DecorationImage(
                              image: NetworkImage(product['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          product['title'],
                          style: const TextStyle(
                            fontFamily: 'Jost',
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
