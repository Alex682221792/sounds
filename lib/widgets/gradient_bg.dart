import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/utils/HexColor.dart';

class GradientBg extends StatefulWidget {
  @override
  _GradientBgState createState() => _GradientBgState();
}

class _GradientBgState extends State<GradientBg> {
  List<Color> colorList = [
    HexColor("#2B6399"),
    HexColor("#613F9E"),
    HexColor("#E0AB54"),
    HexColor("#51488E"),
    Colors.redAccent.shade100
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.purpleAccent.shade100;
  Color topColor = Colors.purple.shade700;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5), () {
      setState(() {
        bottomColor = colorList[0];
      });
    });
    return AnimatedContainer(
        duration: Duration(seconds: 10),
        onEnd: () {
          setState(() {
            index = index + 1;
            // animate the color
            bottomColor = colorList[index % colorList.length];
            topColor = colorList[(index + 1) % colorList.length];

            //// animate the alignment
            begin = alignmentList[index % alignmentList.length];
            end = alignmentList[(index + 2) % alignmentList.length];

            if (index % (colorList.length * 2) == 0) {
              Random random = Random();
              index = random.nextInt(colorList.length);
            }
          });
        },
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: begin, end: end, colors: [bottomColor, topColor])));
  }
}
