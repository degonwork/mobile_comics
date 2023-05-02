import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/size_config.dart';

class Infor extends StatelessWidget {
  const Infor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              height: SizeConfig.screenHeight / 15.12,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth / 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(Icons.remove_red_eye)),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Đã đọc'),
                              Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(Icons.favorite)),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Đánh giá'),
                              Row(
                                children: const [
                                  Text('1.1K'),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amberAccent,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(Icons.library_books)),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Chương'),
                              Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Container(
              padding: EdgeInsets.zero,
              height: SizeConfig.screenHeight / 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thể loại',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 80,
                  ),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 50,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemCount: 2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight / 40),
            const Divider(thickness: 1),
            Container(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tóm tắt',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 75.6,
                  ),
                  Text("state.detailComic!.description"),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight / 25.2),
            Center(
              child: Container(
                height: SizeConfig.screenHeight / 12.6,
                width: SizeConfig.screenWidth / 1.8,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     transitionDuration:
                      //         const Duration(milliseconds: 400),
                      //     transitionsBuilder:
                      //         (context, animation, secAnimation, child) {
                      //       return ScaleTransition(
                      //         scale: animation,
                      //         alignment: Alignment.center,
                      //         child: child,
                      //       );
                      //     },
                      //     pageBuilder:
                      //         (context, animation, secAnimation) {
                      //       return const ReadScreen();
                      //     },
                      //   ),
                      // );
                      // // navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => const ReadScreen()));
                    },
                    child: const Text(
                      'Đọc truyện',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
