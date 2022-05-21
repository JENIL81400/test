
import 'package:ads_demo/ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp( MaterialApp(home: ads_demo(),));
}

class ads_demo extends StatefulWidget {


  @override
  State<ads_demo> createState() => _ads_demoState();
}

class _ads_demoState extends State<ads_demo> {


  @override
  void initState(){
    super.initState();
    //ads_demo();
    ads.bannerad();
    ads.myBanner!.load();
    ads.loodinterad();
    ads.showInterstitialAd();
    ads.createRewardeAd();
    ads.showRewardedAd();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            ads.loodinterad();
            ads.showInterstitialAd();
          }, child: Text("SHOW ADD")),
          ElevatedButton(onPressed: () {
            ads.createRewardeAd();
            ads.showRewardedAd();
          }, child: Text("SHOW VIDEO ADD")),
          Container(
            alignment: Alignment.center,
            child: AdWidget(ad: ads.myBanner!),
            // width: myBanner.size.width.toDouble(),
            // height: myBanner.size.height.toDouble(),
          )       ],
      )
    );
  }
}
