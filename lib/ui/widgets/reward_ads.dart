import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAD extends StatefulWidget {
  const RewardAD({super.key});

  @override
  State<RewardAD> createState() => _RewardADState();
}

class _RewardADState extends State<RewardAD> with TickerProviderStateMixin{
  late final AnimationController controller = AnimationController(vsync: this,duration: const Duration(seconds: 3))..repeat(reverse: true);
  late final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

  RewardedAd? rewardedAd;
  bool isLoaded = false;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad){
          print('oke');
          rewardedAd =ad;
          setState(() {
            isLoaded =true;
          });
        },
        onAdFailedToLoad: (error){
          print('failed');
        }
        )
        );
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(onTap: (){
        rewardedAd!.show(onUserEarnedReward: (ad,reward){
          print("ads watched");
        });
      },
      child: RotationTransition(
        turns: controller,

        child: Container(
          
          height: SizeConfig.screenHeight / 7.56,
          width: SizeConfig.screenWidth / 3.6,
          decoration: const BoxDecoration(
            
            image: DecorationImage(image: AssetImage("assets/images/image_processing20200410-19251-6pz33t.png"),fit: BoxFit.cover)
          ),
        ),
      ),
       ),
    );
  }
}