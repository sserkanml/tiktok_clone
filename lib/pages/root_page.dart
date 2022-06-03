import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tiktok/pages/home_page.dart';
import 'package:tiktok/theme/colors.dart';
import 'package:tiktok/widgets/tik_tok_icons.dart';
import 'package:tiktok/widgets/upload_icon.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBottomNavigationBar(),
      body: GetBody(),
    );
  }

  Widget GetBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        HomePage(),
       
         Center(
          child: Container(child: const Text("Search",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
        ),
         Center(
          child: Container(child: const Text("Create",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
        ),
         Center(
          child: Container(child: const Text("Inbox",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
        ),
          Center(
          child: Container(child: const Text("Profile",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
        ),



      ],
    );
  }

  Widget GetBottomNavigationBar() {
    Size size = MediaQuery.of(context).size;
    List bottomItems = [
      {"icon": TikTokIcons.home, "label": "Home", "isIcon": true},
      {"icon": TikTokIcons.search, "label": "Search", "isIcon": true},
      {"icon": TikTokIcons.create, "label": "Create", "isIcon": false},
      {"icon": TikTokIcons.heart, "label": "Inbox", "isIcon": true},
      {"icon": TikTokIcons.profile, "label": "Profile", "isIcon": true},
    ];
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(color: appBgColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomItems.length, (index) {
              return bottomItems[index]["isIcon"]
                  ? InkWell(
                      onTap: () {
                        SelectedIndex(index);
                      },
                      child: Column(
                        children: [
                          Icon(
                            bottomItems[index]["icon"],
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            bottomItems[index]["label"],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        SelectedIndex(index);
                      },
                      child: const UploadIcon());
            })),
      ),
    );
  }

  void SelectedIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
