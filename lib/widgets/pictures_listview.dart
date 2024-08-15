import 'package:flutter/material.dart';
import 'package:google_maps/models/autocomplete_conversion.dart';

import '../services/const.dart';

class PicturesListview extends StatelessWidget {
  final List<Photo> photos;
  const PicturesListview({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 205,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (index % 3 != 2)
                Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 15 : 8,
                    right: index == photos.length - 1 ? 15 : 8,
                  ),
                  height: index % 3 == 0 ? 205 : 100,
                  width: index % 3 == 0 ? 205 : 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      fit: BoxFit.cover,
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=${photos[index].width.toInt().toString()}&photoreference=${photos[index].photoReference}&key=$GOOGLE_MAPS_API_KEY',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (index % 3 == 1)
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          fit: BoxFit.cover,
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=${photos[index + 1].width.toInt().toString()}&photoreference=${photos[index + 1].photoReference}&key=$GOOGLE_MAPS_API_KEY',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
