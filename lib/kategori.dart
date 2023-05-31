import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:kuis_123200160/jenis.dart';

class Run extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kategori',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CategoryPage(),
    );
  }
}
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<dynamic> categories;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response =
    await http.get(Uri.parse('http://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = data['categories'];
      });
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void navigateToMealTypes(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealTypePage(categoryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: categories != null
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              navigateToMealTypes(category['strCategory']);
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category['strCategoryThumb'],
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 8),
                  Text(
                    category['strCategory'],
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
