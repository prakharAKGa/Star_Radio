import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_radio/model/radio.dart';
import 'package:star_radio/utils/ai_utl.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyRadio> radios = [];
  late MyRadio _selectedRadio;
  late Color _selectedColor;
  bool _isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  


  @override
  void initState() {
    super.initState();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        _isPlaying = true;
        
      }
      else{
        _isPlaying =false;
      }
      setState(() {
        
      });
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {});
  }

  _playMusic(String url , int index){

    _audioPlayer.play(UrlSource(radios[index].url));
  _selectedRadio = radios[index];
    print(_selectedRadio.name);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                colors: [AIColors.primaryColor1, AIColors.primaryColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ))
              .make(),
          AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: "Star Radio".text.xl4.bold.white.make().shimmer(
                  primaryColor: Vx.purple300,
                  secondaryColor: Colors.white,
                ),
          ).h(100).p16(),
          if (radios.isNotEmpty)
            VxSwiper.builder(
                itemCount: radios.length,
                aspectRatio: 1.0,
                enlargeCenterPage: true,
                itemBuilder: (context, index) {
                  final red = radios[index];

                  return VxBox(child: ZStack(
                    
                    [

                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: VxBox(
                          child:red.category.text.uppercase.white.make().px16(),
                        ).height(40).black.alignCenter.withRounded(value: 15).make() ,
                      ),
Align(
  alignment: Alignment.bottomCenter,
  child: VStack([
    red.name.text.xl3.white.bold.make(),
    5.heightBox,
    red.tagline.text.sm.white.semiBold.make(),
  ],
  crossAlignment: CrossAxisAlignment.center,),
),


Positioned(
  top: 150,
  left: 65,
  child: Align(
    alignment: Alignment.center,
    child:[ Icon(
      CupertinoIcons.play_circle,
      color: Colors.white,
      ),
      10.heightBox,
      "Double tap to play.".text.gray300.make(),
                      ].vStack(
                        crossAlignment: CrossAxisAlignment.center
                      )
  ),
)
                      
                    ]))
                    .clip(Clip.antiAlias)
                      .bgImage(DecorationImage(
                          image: NetworkImage(red.image), fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)))
.withRounded(value: 60.0)
.border(color: Colors.black,width: 5)

                      .make()
                      .onInkDoubleTap(() { 
                              _playMusic(red.url,index);
                      })
                      .p16();
                 
                }).centered(),
               
                Align(
                  alignment: Alignment.bottomCenter,
                  child: [
                    if(_isPlaying)
                      "Playing Now - ${_selectedRadio.name} FM".text.makeCentered(),

                    Icon(
                   _isPlaying? CupertinoIcons.stop_circle
                   :CupertinoIcons.play_circle ,
                    color: Colors.white,
                    size: 50.0,
                  )
                  .onInkTap(() {
                    if (_isPlaying) {
                      _audioPlayer.stop();
                      
                    }
                    else{
                      int selectedIndex = radios.indexWhere((element) => element == _selectedRadio);
    _playMusic(_selectedRadio.url, selectedIndex);
                    }
                  })
                  ].vStack()
                ).pOnly(top: 700)
        

        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
