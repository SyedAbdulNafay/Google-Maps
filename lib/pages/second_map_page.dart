import 'package:flutter/material.dart';

import '../services/const.dart';

class SecondMapPage extends StatefulWidget {
  const SecondMapPage({super.key});

  @override
  State<SecondMapPage> createState() => _SecondMapPageState();
}

class _SecondMapPageState extends State<SecondMapPage> {
  @override
  Widget build(BuildContext context) {
    void bottomsheet() {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                  ),
                  height: 9,
                  width: 50,
                ),
                const Text(
                  textAlign: TextAlign.left,
                  "Place Title",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Center(
        child: Image.network(
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=720&photoreference=AelY_CtC1WSVD4CDgKd7wCpJf_yD-xiB_StVc_RRV8cpjmw95i1FYiOQXIBMFAo-U0sEmVSiBWz2z5ZNzO3f_VQ0ABIvQU9BF-3XG8kEs4QWIjwSe1ROLNNQ9zRUxiPUa0fTAisE5IXHJXGsSL_9RyoLuSpua6FVv5pYg-otceZIC6Wkg9x7&key=$GOOGLE_MAPS_API_KEY',
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
    );
  }
}
