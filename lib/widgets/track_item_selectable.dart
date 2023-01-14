import 'package:flutter/material.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/audio_finder_utils.dart';
import 'package:music_player/utils/themes_utils.dart';

class TrackItemSelectable extends StatefulWidget {
  final Track track;
  final List<String> trackIDs;

  TrackItemSelectable(this.track, this.trackIDs, {super.key});

  @override
  State<TrackItemSelectable> createState() => _TrackItemSelectableState();
}

class _TrackItemSelectableState extends State<TrackItemSelectable> {
  bool checkboxState = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: updateList,
        child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: Dimens.normalPadding,
                vertical: Dimens.smallPadding),
            padding: EdgeInsets.all(Dimens.normalPadding),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.normalRadius),
                color: ThemeUtils.getInvertedColor(context)
                    .withAlpha(Dimens.alphaOverlay)),
            child: Center(
                child: Row(children: [
              Container(
                  margin: EdgeInsets.only(right: Dimens.smallPadding),
                  height: Dimens.heightAudioItem,
                  child: button(context)),
              Expanded(
                child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: Dimens.smallPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.track.name),
                        Text(widget.track.artist,
                            style: TextStyles.authorTextStyle),
                      ],
                    )),
              ),
              Center(
                  child: Text(
                      AudioFinderUtils.getDuration(widget.track.duration),
                      style: TextStyles.durationTextStyle(context)))
            ]))));
  }

  Widget button(BuildContext context) {
    checkboxState = widget.trackIDs.contains(widget.track.id);
    return Checkbox(
        value: checkboxState,
        fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
        onChanged: (checked) {
          updateList();
        });
  }

  void updateList(){
    if(widget.trackIDs.contains(widget.track.id)){
      widget.trackIDs.remove(widget.track.id);
    } else {
      widget.trackIDs.add(widget.track.id);
    }
    setState(() {
      checkboxState = !checkboxState;
    });
  }

}
