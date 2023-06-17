// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/screens/search_screen/search_screen.dart';
import '../../../../config/size_config.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 15.12,
      padding: EdgeInsets.only(right: SizeConfig.screenWidth / 18),
      child: TextField(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchComicScreen()));
        },
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.withOpacity(0.2),
          hintText: "Tìm kiếm truyện , thể loại ...",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: SizeConfig.font16,
          ),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
