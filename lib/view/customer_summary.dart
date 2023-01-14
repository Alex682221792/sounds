import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/ad_helper.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/constant_app.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/ads_provider.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/services/audio_finder_service.dart';
import 'package:music_player/widgets/playlist_slim_card.dart';
import 'package:music_player/widgets/track_item.dart';
import 'package:provider/provider.dart';

class CustomerSummary extends StatelessWidget {
  CustomerSummary({Key? key}) : super(key: key);
  PlayerProvider? _playerProvider;
  PlaylistProvider? _playlistProvider;
  AdsProvider? _adsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: Dimens.heightAppBar),
        _getBanner(context),
        Expanded(flex: 1, child: _getHeader(context)),
        Expanded(flex: 3, child: itemList())
      ],
    );
  }

  Widget _getBanner(BuildContext context) {
    initializeAdsProvider(context);
    _adsProvider?.initBannerAd(AdHelper.bannerCustomSummaryScreen);
    return Consumer<AdsProvider>(builder: (context, adsPrvdr, child) {
      if (adsPrvdr.isCustomerSumBannerAdReady) {
        return adsPrvdr.getAdWidget(AdHelper.bannerCustomSummaryScreen);
      }
      return const SizedBox();
    });
  }

  Widget _getHeader(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_infoCard(context), Expanded(child: _getAllPlaylist())],
      ),
    );
  }

  Widget _getAllPlaylist() {
    return Consumer<PlaylistProvider>(builder: (context, playlistPrvdr, child) {
      initializePlaylistProvider(context);

      return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: playlistPrvdr.playlist.length,
          itemBuilder: (context, index) =>
              PlaylistSlimCard(playlistPrvdr.playlist[index]));
    });
  }

  Widget _infoCard(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.INFO_APP);
        },
        child: Container(
            //height: double.infinity,
            width: 60,
            margin: EdgeInsets.all(Dimens.smallPadding),
            padding: EdgeInsets.symmetric(
                vertical: Dimens.normalPadding,
                horizontal: Dimens.smallPadding * 0.5),
            decoration: BoxDecoration(
                gradient: Gradients.checkPointBg(context),
                borderRadius: BorderRadius.circular(Dimens.normalRadius)),
            child: Stack(
              children: [
                Center(
                    child: Hero(
                        tag: "logo_ico",
                        child: SvgPicture.asset("assets/icons/sound.svg",
                            color: Theme.of(context).colorScheme.primary))),
                Positioned(
                    bottom: 5,
                    left: -7,
                    child: SizedBox(
                      width: 70,
                      child: Opacity(
                          opacity: 0.35,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("Sounds",
                                  style: TextStyles.titleTextStyle(context))))
                    )),
                Positioned(
                    bottom: 20,
                    child: SizedBox(
                        width: 55,
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Sounds",
                                    style: TextStyles.normalTextStyle)))))
              ],
            )));
  }

  StreamBuilder<Map<String, dynamic>?> itemList() {
    return StreamBuilder<Map<String, dynamic>?>(
      stream:
          FlutterBackgroundService().on(AudioFinderService.UPDATE_STATE_KEY),
      builder: (context, snapshot) {
        List<Track> tracks = AppState.lastTrackList;
        if (tracks.isEmpty) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          List<dynamic> tracksDynamic = data[ConstantApp.ALL_TRACKS_KEYMAP];
          tracks = tracksDynamic.isNotEmpty
              ? tracksDynamic.map((e) => Track.fromJson(e)).toList()
              : AppState.lastTrackList;
          AppState.lastTrackList = tracks;
        }
        if (snapshot.hasData &&
            ((snapshot.data?[ConstantApp.SEARCHING_TRACKS_YET_KEYMAP]) ??
                false)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        initializePlayerProvider(context);

        Provider.of<PlaylistProvider>(context, listen: false)
            .updatePlaylistSubscribers();
        return Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tracks.length,
                      itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(
                              top: 0,
                              bottom: tracks.length - 1 == index
                                  ? Dimens.heightBottomBar * 1.8
                                  : 0),
                          child: TrackItem(tracks[index],
                              ConstantApp.ID_DEFAULT_PLAYLIST_KEYMAP,
                              playerProvider: _playerProvider)))),
            ),
            //Positioned(bottom: 0, child: searchingWidget(showSearching))
          ],
        );
      },
    );
  }

  Widget searchingWidget(bool isVisible) {
    if (isVisible) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text("Estás al día");
    }
  }

  void initializePlayerProvider(BuildContext context) {
    _playerProvider =
        _playerProvider ?? Provider.of<PlayerProvider>(context, listen: false);
  }

  void initializePlaylistProvider(BuildContext context) {
    _playlistProvider = _playlistProvider ??
        Provider.of<PlaylistProvider>(context, listen: false);
  }

  void initializeAdsProvider(BuildContext context) {
    _adsProvider =
        _adsProvider ?? Provider.of<AdsProvider>(context, listen: false);
  }
}
