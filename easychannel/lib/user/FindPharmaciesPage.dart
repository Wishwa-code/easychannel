import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class FindPharmaciesPage extends StatelessWidget {
  Future<void> _launchGoogleMaps() async {
    const query = "pharmacies near me";
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Pharmacies Finder'),
        backgroundColor: Color(0xFF2596be),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.local_pharmacy,
              size: 100.0,
              color: Color(0xFF2596be),
            ),
            SizedBox(height: 20),
            Text(
              'Pharmacy Locator',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Find pharmacies nearby with just one tap. Press the button below, and you will be redirected to Google Maps showing you all the pharmacies in your vicinity.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _launchGoogleMaps,
              icon: Icon(Icons.map),
              label: Text('Open Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2596be),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
