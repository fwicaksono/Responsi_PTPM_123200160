import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuis_123200160/detail.dart';


class MealTypePage extends StatefulWidget {
  final String categoryName;

  MealTypePage(this.categoryName);

  @override
  _MealTypePageState createState() => _MealTypePageState();
}

class _MealTypePageState extends State<MealTypePage> {
  late List<dynamic> mealTypes;

  @override
  void initState() {
    super.initState();
    fetchMealTypes();
  }

  Future<void> fetchMealTypes() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mealTypes = data['meals'];
      });
    } else {
      throw Exception('Failed to fetch meal types');
    }
  }

  void navigateToMealDetails(String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailPage(mealId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: mealTypes != null
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: mealTypes.length,
        itemBuilder: (context, index) {
          final mealType = mealTypes[index];
          return GestureDetector(
            onTap: () {
              navigateToMealDetails(mealType['idMeal']);
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    mealType['strMealThumb'],
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 8),
                  Text(
                    mealType['strMeal'],
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
