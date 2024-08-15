import 'package:flutter/material.dart';

class PicturesListview extends StatefulWidget {
  const PicturesListview({super.key});

  @override
  State<PicturesListview> createState() => _PicturesListviewState();
}

class _PicturesListviewState extends State<PicturesListview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 205,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          debugPrint(index.toString());
          return Column(
            children: [
              if (index % 3 != 2)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: index % 3 == 0 ? 205 : 100,
                  width: index % 3 == 0 ? 205 : 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      index.toString(),
                      style: const TextStyle(color: Colors.white),
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
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          index.toString(),
                          style: const TextStyle(color: Colors.white),
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
