import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MealDetailPage extends StatefulWidget {
  final String mealId;

  MealDetailPage(this.mealId);

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late Map<String, dynamic> mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final response =
    await http.get(Uri.parse('http://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'];
      if (meals != null && meals.isNotEmpty) {
        setState(() {
          mealDetails = meals[0];
        });
      }
    } else {
      throw Exception('Failed to fetch meal details');
    }
  }

  void _launchMealWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Makanan'),
      ),
      body: mealDetails != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                mealDetails['strMeal'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Image.network(
              mealDetails['strMealThumb'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                mealDetails['strInstructions'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (mealDetails['strSource'] != null &&
                mealDetails['strSource'] != 'null' &&
                mealDetails['strSource'] != '')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _launchMealWebsite(mealDetails['strSource']);
                  },
                  child: Text('Lihat Ke Website'),
                ),
              ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
