import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late ScrollController controller;
  bool visialbe = true;
  List<String> imageManga = [
    'assets/vo_luyen_dinh_phong/image(2).jpg',
    'assets/vo_luyen_dinh_phong/image(3).jpg',
    'assets/vo_luyen_dinh_phong/image(4).jpg',
    'assets/vo_luyen_dinh_phong/image(5).jpg',
    'assets/vo_luyen_dinh_phong/image(6).jpg',
    'assets/vo_luyen_dinh_phong/image(7).jpg',
    'assets/vo_luyen_dinh_phong/image(8).jpg',
    'assets/vo_luyen_dinh_phong/image(9).jpg',
    'assets/vo_luyen_dinh_phong/image(10).jpg',
    'assets/vo_luyen_dinh_phong/image(11).jpg',
    'assets/vo_luyen_dinh_phong/image(12).jpg',
  ];
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        visialbe =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  visialbe = !visialbe;
                });
              },
              child: ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: imageManga.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              imageManga[index],
                            ),
                            fit: BoxFit.fill),
                      ),
                    );
                  }),
            ),
            AnimatedOpacity(
              opacity: visialbe ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left,
                      size: 50,
                      color: Colors.amberAccent,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
