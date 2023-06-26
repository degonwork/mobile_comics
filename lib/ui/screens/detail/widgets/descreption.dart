import 'package:flutter/material.dart';


class Descreption extends StatefulWidget {
  const Descreption({super.key,required this.maxLines, required this.text});
final String text;
final int maxLines;
  @override
  State<Descreption> createState() => _DescreptionState();
}

class _DescreptionState extends State<Descreption> {
  
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: isExpanded ? null : 3,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        if (textPainter.didExceedMaxLines && !isExpanded) {
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text,maxLines: 3,overflow: TextOverflow.ellipsis,),
              TextButton(onPressed: (){
                setState(() {
                  isExpanded = true;
                });
              }, child: const Center(child:  Text( "Xem thêm",style: TextStyle(color: Colors.yellow),)),
              ),
            ],
          );
        } else if(isExpanded){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text),
              TextButton(onPressed:(){
                setState(() {
                  isExpanded = false;
                });
              }, child:const  Center(child:  Text('Thu gọn',style: TextStyle(color: Colors.yellow),))
              )
            ],
          );
        }else{
          return Text(widget.text);
        }
      },
    );
  }
}