import 'package:flutter/material.dart';
import 'package:google_maps/tabs/overview_tab.dart';
import 'package:google_maps/widgets/buttons_row.dart';
import 'package:google_maps/widgets/pictures_listview.dart';

import '../services/const.dart';

class SecondMapPage extends StatelessWidget {
  const SecondMapPage({super.key});

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
                    color: Colors.grey[300],
                  ),
                  height: 5,
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            "Place Title",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child:
                                    const Icon(Icons.share_outlined, size: 20),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: const Icon(Icons.close, size: 20),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Text(
                        "Subtitle",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        "Longer Subtitle",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const ButtonsRow(),
                // PicturesListview()
                DefaultTabController(
                    length: 6,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.blue[700],
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              text: "Overview",
                            ),
                            Tab(
                              text: "Directory",
                            ),
                            Tab(
                              text: "Reviews",
                            ),
                            Tab(
                              text: "Photos",
                            ),
                            Tab(
                              text: "Updates",
                            ),
                            Tab(
                              text: "About",
                            ),
                          ],
                        ),
                        Expanded(
                            child: TabBarView(
                          children: [
                            OverviewTab(text: 'text'),
                          ],
                        ))
                      ],
                    ))
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: bottomsheet,
        child: const Text("Show Bottom Sheet"),
      )),
    );
  }
}
