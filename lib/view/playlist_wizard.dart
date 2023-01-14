import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/messages_ui.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/utils/settings_utils.dart';
import 'package:music_player/utils/validators.dart';
import 'package:music_player/widgets/track_item_selectable.dart';

class PlaylistWizard extends StatefulWidget {
  PlaylistProvider? playlistProvider;
  PlaylistWizard({this.playlistProvider, Key? key}) : super(key: key);

  @override
  State<PlaylistWizard> createState() => _PlaylistWizardState();
}

class _PlaylistWizardState extends State<PlaylistWizard> {
  var currentStep = 0;
  Widget stepWidget = SizedBox();
  final _textController = TextEditingController();
  List<String> trackIDs = [];
  String playlistName = "";
  Playlist? _playlist;

  @override
  Widget build(BuildContext context) {
    updateStepWidget(context);
    var height = MediaQuery.of(context).size.height * 0.75;

    return FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom != 0 ? 0.9 : 0.7,
        child: Scaffold(
            body: SizedBox(
                height: height,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(gradient: Gradients.checkPointBg(context)),
                        height: Dimens.heightBottomBar,
                        child: Center(
                          child: Text("New playlist",
                              style: TextStyles.normalWhiteTextStyle),
                        )),
                    IconStepper(
                      icons: const [
                        Icon(Icons.star_border),
                        Icon(Icons.music_note_outlined),
                        Icon(Icons.check_circle_outline)
                      ],
                      lineColor: Theme.of(context).colorScheme.secondary,
                      activeStepBorderColor:
                          Theme.of(context).colorScheme.secondary,
                      activeStepColor: Theme.of(context).colorScheme.secondary,
                      stepColor:
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                      enableNextPreviousButtons: false,
                      enableStepTapping: true,

                      // activeStep property set to activeStep variable defined above.
                      activeStep: currentStep,

                      // This ensures step-tapping updates the activeStep.
                      onStepReached: (index) {
                        setState(() {
                          if (currentStep >= index) {
                            currentStep = index;
                            updateStepWidget(context);
                          } else {
                            MessagesUI.showSnackBar(
                                context, "Completa el paso actual");
                          }
                        });
                      },
                    ),
                    Expanded(child: stepWidget),
                    Container(
                        height: Dimens.heightBottomBar * 1.5,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: continueClick,
                                  style: ButtonStyles.accentTextButton(context),
                                  child: Text("Continue")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"))
                            ]))
                  ],
                ))));
  }

  void continueClick() async {
    switch (currentStep) {
      case 0:
        {
          if (_textController.text.isNotEmpty) {
            playlistName = _textController.text;
            nextStep();
          } else {
            MessagesUI.showSnackBar(context,
                "Type the name of your new playlist.");
          }
          break;
        }
      case 1:
        {
          if (trackIDs.isNotEmpty) {
            playlistName = _textController.text;
            PlaylistUtils.createPlaylist(playlistName, trackIDs).then((value) {
              _playlist = value;
              widget.playlistProvider?.updatePlaylistSubscribers();
              nextStep();
            });
          } else {
            MessagesUI.showSnackBar(context,
                "Selecciona los tracks para tu nueva lista de reproducción.");
          }
          break;
        }
      case 2:
        {
          Navigator.pop(context);
          break;
        }
    }
  }

  void nextStep() {
    setState(() {
      currentStep++;
      updateStepWidget(context);
    });
  }

  void updateStepWidget(BuildContext context) {
    switch (currentStep) {
      case 0:
        {
          stepWidget = playlistForm(context);
          break;
        }
      case 1:
        {
          stepWidget = trackList();
          break;
        }
      case 2:
        {
          stepWidget = completedSuccessful();
          break;
        }
    }
  }

  Widget playlistForm(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(Dimens.largePadding),
        child: ValueListenableBuilder(
            // Note: pass _controller to the animation argument
            valueListenable: _textController,
            builder: (context, TextEditingValue value, __) {
              return TextField(
                controller: _textController,
                maxLength: 30,
                decoration: InputDecoration(
                    errorText: Validators.minLength(_textController.text, 1),
                    hintText: 'Playlist name',
                    border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.all(Dimens.smallPadding)),
              );
            }));
  }

  Widget trackList() {
    return FutureBuilder<List<Track>>(
        future: PlaylistUtils.getAllTracks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var tracks = snapshot.data!;
          return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tracks.length,
                  itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(
                          top: 0,
                          bottom: 0),
                      child: TrackItemSelectable(tracks[index], trackIDs))));
        });
  }

  Widget completedSuccessful() {
    return Center(
        child: Column(
      children: [
        SvgPicture.asset("assets/icons/playlist.svg",
            color: Theme.of(context).colorScheme.secondary.withAlpha(70),
            height: Dimens.largeIcon * 2),
        SizedBox(height: Dimens.largePadding),
        Text("Congratulations, you have a new playlist!",
            style: TextStyles.normalTextStyle),
        TextButton(
            onPressed: () {
              if(_playlist!=null){
                Navigator.pop(context);
                SettingsUtils.updateCurrentPlayList(_playlist!.id)
                    .then((value) => openListView(context));
              }
            },
            child: Text("Listen now!",
                style: TextStyles.secondaryStrongTextStyle(context)))
      ],
    ));
  }

  void openListView(BuildContext context) {
    AppState.playlist = _playlist;
    Navigator.pushNamed(context, Routes.PLAYLIST_DETAILS);
  }
}
