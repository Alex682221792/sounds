import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/confirm_bottom_sheet.dart';
import 'package:music_player/utils/themes_utils.dart';
import 'package:music_player/view/playlist_wizard.dart';
import 'package:music_player/widgets/custom_nav_bar.dart';
import 'package:music_player/widgets/mini_square_button.dart';
import 'package:music_player/widgets/playlist_card.dart';
import 'package:provider/provider.dart';

class PlaylistSummary extends StatefulWidget {
  PlaylistSummary({Key? key}) : super(key: key);
  PlaylistProvider? _playlistProvider;

  @override
  State<PlaylistSummary> createState() => _PlaylistSummaryState();
}

class _PlaylistSummaryState extends State<PlaylistSummary> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializePlayerProvider(context);
      widget._playlistProvider?.updatePlaylistSubscribers();
    });

    return Scaffold(
        appBar: CustomNavBar.getBar(
            "Playlist Gallery", null, context),
        body: Column(
          children: [
            header(context),
            searchBox(context),
            Expanded(child: playlistGrid(context))
          ],
        ));
  }

  Widget header(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, playlistPrvdr, child) {
      if (playlistPrvdr.playlistChosen.isEmpty) {
        return summaryHeader(context, playlistPrvdr);
      } else {
        return chosenListOptions(context, playlistPrvdr);
      }
    });
  }

  Widget chosenListOptions(
      BuildContext context, PlaylistProvider playlistProvider) {
    var playlistCounter = playlistProvider.playlistChosen.length;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("$playlistCounter selected playlists")),
              MiniSquareButton(
                callback: () {
                  ConfirmBottomSheet(
                      message: "¿Are you sure to proceed with the removal?",
                      callbackOk: () {
                        widget._playlistProvider?.cleanUpChosenPlaylist();
                      }).showDialog(context);
                },
                size: 30,
                colorBackground: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete_forever_rounded,
                    color: Colors.white),
              ),
              SizedBox(width: Dimens.normalPadding),
              MiniSquareButton(
                callback: () {
                  widget._playlistProvider?.clearChosenList();
                },
                size: 30,
                colorBackground: Colors.transparent,
                child: const Icon(Icons.cancel_outlined, color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: Dimens.smallPadding),
          Divider(height: 1, color: ThemeUtils.getInvertedColor(context))
        ],
      ),
    );
  }

  Widget summaryHeader(
      BuildContext context, PlaylistProvider playlistProvider) {
    var playlistCounter = playlistProvider.playlist.length;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("$playlistCounter playlists")),
              MiniSquareButton(
                icon: "assets/icons/plus.svg",
                callback: () {
                  showModalBottomSheet<void>(
                      elevation: 3,
                      isScrollControlled: true,
                      barrierColor: Colors.white12,
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return PlaylistWizard(
                            playlistProvider: widget._playlistProvider);
                      });
                },
                size: 30,
              )
            ],
          ),
          SizedBox(height: Dimens.smallPadding),
          Divider(height: 1, color: ThemeUtils.getInvertedColor(context))
        ],
      ),
    );
  }

  Widget searchBox(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextField(
            decoration: InputDecoration(
                hintText: "Search by name...",
                border: InputBorder.none,
                icon: SvgPicture.asset("assets/icons/search.svg",
                    width: Dimens.smallIcon,
                    color: ThemeUtils.getInvertedColor(context))),
            onChanged: (value) {
              widget._playlistProvider?.filterPlaylistByNameAndRefresh(value);
            }));
  }

  Widget playlistGrid(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, playlist, child) {
      return GridView.count(
        crossAxisCount: 3,
        children: (playlist.filtering
                ? playlist.filteredPlaylist
                : playlist.playlist)
            .map((playlist) => PlaylistCard(playlist,
                playlistProvider: widget._playlistProvider,
                resetState: widget._playlistProvider?.playlistChosen.isEmpty))
            .toList(),
      );
    });
  }

  void initializePlayerProvider(BuildContext context) {
    widget._playlistProvider = widget._playlistProvider ??
        Provider.of<PlaylistProvider>(context, listen: false);
  }
}
