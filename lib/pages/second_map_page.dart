import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps/const.dart';
import 'package:google_maps/models/network_utils.dart';
import 'package:google_maps/models/place_autocomplete.dart';

import '../models/autocomplete_predictions.dart';

class SecondMapPage extends StatefulWidget {
  const SecondMapPage({super.key});

  @override
  State<SecondMapPage> createState() => _SecondMapPageState();
}

class _SecondMapPageState extends State<SecondMapPage> {
  List<AutocompletePrediction> placePredictions = [];
  final _formKey = GlobalKey<FormState>();
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      '/maps/api/place/autocomplete/json', // unencoder path
      {
        "input": query,
        "key": GOOGLE_MAPS_API_KEY,
      },
    );

    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      print(response);
      PlaceAutocompleteReponse result =
          PlaceAutocompleteReponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Set Delivery Location"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: "Search your location",
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey,
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {},
                label: const Text(
                  "Use my current location",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              )),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  horizontalTitleGap: 0,
                  title: Text(
                    placePredictions[index].description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
