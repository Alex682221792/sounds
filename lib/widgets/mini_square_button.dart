import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/resources/values/dimens.dart';

class MiniSquareButton extends StatefulWidget {
  String? icon;
  Function() callback;
  double size;
  Widget? child;
  Color? colorBackground;

  MiniSquareButton(
      {this.icon,
      required this.callback,
      this.size = 50,
      this.child,
      this.colorBackground});

  @override
  State<MiniSquareButton> createState() => _MiniSquareButtonState();
}

class _MiniSquareButtonState extends State<MiniSquareButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.callback,
        style: TextButton.styleFrom(
            backgroundColor: widget.colorBackground ??
                Theme.of(context).colorScheme.secondary,
            padding: EdgeInsets.all(Dimens.smallPadding),
            minimumSize: Size(widget.size, widget.size),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center),
        child: _getChild());
  }

  Widget _getChild() {
    if (widget.child != null) {
      return Container(
          height: widget.size,
          width: widget.size,
          //color: Theme.of(context).colorScheme.secondary,
          child: Center(child: widget.child));
    }
    if (widget.icon != null) {
      return SizedBox(
          height: widget.size,
          width: widget.size,
          //color: Theme.of(context).colorScheme.secondary,
          child: Center(
              child: SizedBox(
                  height: widget.size * 0.5,
                  width: widget.size * 0.5,
                  child: SvgPicture.asset(widget.icon!,
                      color: Colors.white//ThemeUtils.getInvertedColor(context)
                  ))));
    }
    return const SizedBox();
  }
}
