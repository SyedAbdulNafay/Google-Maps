class AutocompleteConversion {
  double latitude;
  double longitude;
  List<Photo> photos;

  AutocompleteConversion({
    required this.latitude,
    required this.longitude,
    required this.photos,
  });

  factory AutocompleteConversion.fromJson(Map<String, dynamic> json) {
    List<Photo> photoslist = [];
    if (json['result']['photos'] != null) {
      photoslist = json['result']['photos']
          .map((photo) => Photo.fromJson(photo))
          .toList().cast<Photo>();
    }

    return AutocompleteConversion(
      latitude: json['result']['geometry']['location']['lat'],
      longitude: json['result']['geometry']['location']['lng'],
      photos: photoslist,
    );
  }
}

class Photo {
  double height;
  double width;
  List<String> htmlAttributions;
  String photoReference;

  Photo({
    required this.height,
    required this.width,
    required this.htmlAttributions,
    required this.photoReference,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'].toDouble(),
      width: json['width'].toDouble(),
      htmlAttributions: json['html_attributions'].cast<String>(),
      photoReference: json['photo_reference'],
    );
  }
}
