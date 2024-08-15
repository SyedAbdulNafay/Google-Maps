class AutocompleteConversion {
  String name;
  bool isOpen;
  double latitude;
  double longitude;
  List<Photo>? photos;
  String formattedAddress;
  String? formattedPhoneNumber;
  String compoundCode;
  double rating;
  int totalRatings;
  List<Review>? reviews;
  String? website;
  bool wheelchairAccessible;

  AutocompleteConversion({
    required this.latitude,
    required this.longitude,
    this.photos,
    required this.name,
    required this.compoundCode,
    required this.formattedAddress,
    this.formattedPhoneNumber,
    required this.isOpen,
    required this.rating,
    this.reviews,
    required this.totalRatings,
    this.website,
    required this.wheelchairAccessible,
  });

  factory AutocompleteConversion.fromJson(Map<String, dynamic> json) {
    List<Photo> photoslist = [];
    if (json['result']['photos'] != null) {
      photoslist = json['result']['photos']
          .map((photo) => Photo.fromJson(photo))
          .toList()
          .cast<Photo>();
    }

    List<Review> reviews = [];
    if (json['result']['reviews'] != null) {
      reviews = json['result']['reviews']
          .map((review) => Review.fromJson(review))
          .toList()
          .cast<Review>();
    }

    return AutocompleteConversion(
      name: json['result']['name'],
      latitude: json['result']['geometry']['location']['lat'],
      longitude: json['result']['geometry']['location']['lng'],
      photos: photoslist,
      formattedAddress: json['result']["formatted_address"],
      formattedPhoneNumber: json['result']["formatted_phone_number"],
      isOpen: json['result']['current_opening_hours']['open_now'],
      compoundCode: json['result']['plus_code']['compound_code'],
      rating: json['result']['rating'],
      reviews: reviews,
      website: json['result']['website'],
      totalRatings: json['result']['user_ratings_total'],
      wheelchairAccessible: json['result']['wheelchair_accessible_entrance'],
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

class Review {
  String authorName;
  String authorUrl;
  String profilePhotoUrl;
  int rating;
  String relativeTimeDescription;
  String text;

  Review({
    required this.authorName,
    required this.authorUrl,
    required this.profilePhotoUrl,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'],
      authorUrl: json['author_url'],
      profilePhotoUrl: json['profile_photo_url'],
      rating: json['rating'],
      relativeTimeDescription: json['relative_time_description'],
      text: json['text'],
    );
  }
}
