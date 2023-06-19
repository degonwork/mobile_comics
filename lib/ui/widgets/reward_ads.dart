// import 'package:flutter/material.dart';
// import 'package:full_comics_frontend/config/size_config.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class RewardAD extends StatefulWidget {
//   const RewardAD({super.key});

//   @override
//   State<RewardAD> createState() => _RewardADState();
// }

// class _RewardADState extends State<RewardAD> {
//   // late final AnimationController controller = AnimationController(vsync: this,duration: const Duration(seconds: 3))..repeat(reverse: true);
//   // late final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

//   RewardedAd? rewardedAd;
//   bool isLoaded = false;
//   @override
//   void initState(){
//     super.initState();
//     RewardedAd.load(
//       adUnitId: "ca-app-pub-3940256099942544/5224354917",
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad){
//           rewardedAd =ad;
//           // setState(() {
//           //   isLoaded =true;
//           // });
//         },
//         onAdFailedToLoad: (error){
          
//         }
//         )
//         );
//   }
//   // @override
//   // void dispose(){
//   //   controller.dispose();
//   //   super.dispose();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(onTap: (){
//         rewardedAd!.show(onUserEarnedReward: (ad,reward){
//         });
//       },
//       child: Container(
//         height: SizeConfig.screenHeight / 7.56,
//         width: SizeConfig.screenWidth / 3.6,
//         decoration: const BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/banner_splash.png"),fit: BoxFit.cover)
//         ),
//       ),
//        ),
//     );
//   }
// }