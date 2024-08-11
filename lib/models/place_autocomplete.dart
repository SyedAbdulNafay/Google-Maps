import 'dart:convert';
import '../models/autocomplete_predictions.dart';

class PlaceAutocompleteReponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteReponse({this.status, this.predictions});

  factory PlaceAutocompleteReponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteReponse(
        status: json['status'] as String?,
        predictions: json['predictions']
            ?.map<AutocompletePrediction>(
                (json) => AutocompletePrediction.fromJson(json))
            .toList());
  }

  static PlaceAutocompleteReponse parseAutocompleteResult(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteReponse.fromJson(parsed);
  }
}
