import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/widgets/track_item.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatelessWidget {
  PlaylistView({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          openPlaylistExplorer(context);
        },
        child: Container(
            padding: EdgeInsets.all(Dimens.normalPadding),
            decoration: _mainDecoration(context),
            child: Row(children: [
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/playlist.svg",
                          color: Theme.of(context).primaryColor,
                          height: Dimens.smallIcon),
                      Text(' ${playlist.name}',
                          style: TextStyles.titleTextStyle(context)),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Next: ',
                          style: TextStyles.subtitleTextStyle(context)),
                      Text('Me gustas tú...',
                          style: TextStyles.subtitleTextStyle(context))
                    ],
                  )
                ],
              )),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
                child: SvgPicture.asset("assets/icons/next.svg",
                    color: Colors.redAccent.shade100, height: Dimens.smallIcon),
              )
            ])));
  }

  void openPlaylistExplorer(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<PlayerProvider>(
                    create: (_) => PlayerProvider())
              ],
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(Dimens.normalPadding),
                        decoration: _mainDecoration(context),
                        // height: Dimens.heightBottomBar,
                        child: Row(children: [
                          Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/playlist.svg",
                                        color: Theme.of(context).primaryColor,
                                        height: Dimens.smallIcon),
                                    Text(' Playlist',
                                        style:
                                            TextStyles.titleTextStyle(context)),
                                  ],
                                ),
                                Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text('Next: ',
                                          style: TextStyles.subtitleTextStyle(
                                              context)),
                                      Text('Me gustas tú...',
                                          style: TextStyles.subtitleTextStyle(
                                              context))
                                    ])
                              ]))
                          //IconButton(onPressed: (){}, icon: ImageIcon(SvgPicture.asset("assets/icons/playlist.svg",
                          //    color: Theme.of(context).primaryColor, height: Dimens.smallIcon)))
                        ])),
                    Expanded(
                        child: FutureBuilder<List<Track>>(
                            future:
                                PlaylistUtils.getTrackByIdList(playlist.tracks),
                            initialData: const [],
                            builder: (context, snapshot) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) => TrackItem(
                                    snapshot.data![index], playlist.id))))
                  ],
                ),
              ));
        });
  }

  BoxDecoration _mainDecoration(BuildContext context) {
    return BoxDecoration(
        gradient: Gradients.playListGradient(context),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.normalRadius),
            topRight: Radius.circular(Dimens.normalRadius)));
  }
}
