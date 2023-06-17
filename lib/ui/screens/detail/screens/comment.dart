import 'package:flutter/material.dart';
import '../../../../config/size_config.dart';

class Comment extends StatelessWidget {
  const Comment({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(thickness: 0.5),
          const SizedBox(
            height: 25,
          ),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(
            height: 25,
          ),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          const Divider(thickness: 0.5),
          const SizedBox(height: 25),
          SizedBox(
            height: SizeConfig.screenHeight / 15.12,
            child: TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(Icons.pending_outlined),
                hintText: 'Bình luận ...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
