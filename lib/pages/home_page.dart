import 'package:flutter/material.dart';

import 'package:tiktok/theme/colors.dart';
import 'package:tiktok/widgets/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';

import '../constant/data_json.dart';

class HomePage extends StatefulWidget  {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
   TabController? _tabController;
  @override
  void initState() {
    _tabController=TabController(length: items.length, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
  Widget getBody(){
  var size=MediaQuery.of(context).size;

  return RotatedBox(
     quarterTurns: 1,
    child: TabBarView(controller: _tabController,children: List.generate(items.length, ((index) {
      return RotatedBox(
        quarterTurns: -1,
        child: VideoPlayerItem(size: size,videoUrl:items[index]["videoUrl"],
        name: items[index]["name"],songName: items[index]["songName"],albumImg: items[index]["albumImg"],likes: items[index]["likes"],shares: items[index]["shares"],comments: items[index]["comments"],caption: items[index]["caption"],profileImg: items[index]["profileImg"],),
      );
    }),)),
  );
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return getBody();
  }
}


class VideoPlayerItem extends StatefulWidget {
  final String name;
  final String shares;
  final String likes;
  final String comments;
  final String songName;
  final String caption;
  final String albumImg;
  final String profileImg;
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,required this.videoUrl,
    required this.size, required this.name, required this.shares, required this.likes, required this.comments, required this.songName, required this.caption, required this.albumImg, required this.profileImg,
  }) : super(key: key);

  final Size size;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> with SingleTickerProviderStateMixin {

  late VideoPlayerController _videoPlayerController;
  bool isShowing=false;
  @override
  void initState() {
    _videoPlayerController=VideoPlayerController.asset(widget.videoUrl)..initialize().then((value) {
     _videoPlayerController.play();
     setState(() {
       isShowing=false;
     });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
           _videoPlayerController.value.isPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();
        });
       
      },
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: const BoxDecoration(color: black),
        child: Stack(children: [
          Container(width: widget.size.width,height: widget.size.height,child: Stack(children: [
            VideoPlayer(_videoPlayerController),
            _videoPlayerController.value.isPlaying ? Container() :
            Center(child: Icon(Icons.play_arrow,size: 80,color: white.withOpacity(.5),),) 
          ]),),
          Container(
            height: widget.size.height,
            width: widget.size.width,
          
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 15, left: 15),
                child: Column(
                  children: [
                    const header(),
                    Flexible(
                      child: Row(
                        children: [
                          LeftPanel(size: widget.size,name: widget.name,caption: widget.caption,songname: widget.songName,),
                          RightPanel(size: widget.size,likes:widget.likes,comments: widget.comments,shares:widget.shares,profileImg: widget.profileImg,albumImg: widget.albumImg,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  String profileImg;
  String likes;
  String comments;
  String shares;
  String albumImg;

   RightPanel({
    Key? key,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.albumImg,
    required this.size,
    required this.profileImg
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: Column(children: [
        Container(
          height: size.height * .3,
        ),
        Expanded(
            child: Container(
          child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                 getProfile(profileImg: profileImg,),
                GetIcon(TikTokIcons.chat_bubble, 35,comments),
                GetIcon(TikTokIcons.heart, 35, likes),
                GetIcon(TikTokIcons.reply, 35, shares),
                getAllAlbum(albumImg)
              ]),
        ))
      ]),
    ));
  }
}
Widget getAllAlbum(albumImg){
  return Container(
    height: 55,
    width: 55,
    child: Stack(children: [
     Container(height: 50,width: 50,
     decoration: BoxDecoration(shape: BoxShape.circle),) ,
     Center(
       child: Container(
         height: 30,
         width: 30,
         decoration: BoxDecoration(shape: BoxShape.circle,image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(albumImg,),)),
       ),
     )
    ]),
  );
}
class getProfile extends StatelessWidget {
  dynamic profileImg;
   getProfile({
    Key? key,
    required this.profileImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 55,
      child: Stack(children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(profileImg))),
        ),
        Positioned(
            bottom: 0,
            left: 28,
            child: Container(
              width: 20,
              height: 20,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: primary),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 15,
                  color: white,
                ),
              ),
            ))
      ]),
    );
  }
}

Widget GetIcon(IconData icon, double size, String count) {
  return Column(
    children: [
      Icon(
        icon,
        color: white,
        size: size,
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        count,
        style: const TextStyle(color: white, fontWeight: FontWeight.w500),
      )
    ],
  );
}

class LeftPanel extends StatelessWidget {
  String name;
  String caption;
  String songname;
   LeftPanel({
    Key? key,
    required this.size,
    required this.caption,
    required this.name,
    required this.songname
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * .78,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(color: white.withOpacity(.8), fontSize: 17),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            caption,
            style: TextStyle(color: white.withOpacity(.7), fontSize: 13),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.music_note,
                size: 15,
                color: white,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
               songname,
                style: TextStyle(
                  color: white.withOpacity(.8),
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class header extends StatelessWidget {
  const header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Following",
          style: TextStyle(fontSize: 16, color: white.withOpacity(.3)),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          " | ",
          style: TextStyle(fontSize: 16, color: white.withOpacity(.6)),
        ),
        const SizedBox(
          width: 5,
        ),
        const Text(
          "For u",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
