// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BuildAdsBanner extends StatelessWidget {
//   const BuildAdsBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final adSize = AdSize.banner;
//     final bannerAds = BannerAd(
//       size: adSize,
//       adUnitId: 'ca-app-pub-5859898098878852/9210807199',
//       listener: const BannerAdListener(),
//       request: const AdRequest()
//       );
//       bannerAds.load();
//     return Container(
//       alignment: Alignment.center,
//       child: AdWidget(ad: bannerAds),
//       width: bannerAds.size.width.toDouble(),
//       height: bannerAds.size.height.toDouble(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAD extends StatefulWidget {
  const BannerAD({super.key});

  @override
  State<BannerAD> createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
  late BannerAd bannerAd;
  bool isLoaded = false;
  initBannerAD(){
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (ad){
          setState(() {
            isLoaded =  true;
          });
        },
        onAdFailedToLoad: (ad,error){
          ad.dispose();
          // print(error);
        }
      ),
      request: const AdRequest()
      );
      bannerAd.load();
  }
  @override
  void initState(){
    super.initState();
    initBannerAD();
  }
  @override
  Widget build(BuildContext context) {
    return isLoaded ?  SizedBox(
         height: bannerAd.size.height.toDouble()/2,
         width: bannerAd.size.width.toDouble(),
         child: AdWidget(ad: bannerAd),
    ) : const SizedBox();
  }
}