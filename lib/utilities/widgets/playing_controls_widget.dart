import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class PlayingControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  const PlayingControlsWidget({
    Key? key,
    required this.isPlaying,
    this.loopMode,
    this.isPlaylist = false,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.toggleLoop,
    this.onStop,
  }) : super(key: key);

  Widget _loopIcon(BuildContext context) {
    const iconSize = 36.0;
    if (loopMode == LoopMode.none) {
      return const Icon(
        Icons.loop_rounded,
        size: iconSize,
        color: mainColor,
      );
    } else if (loopMode == LoopMode.playlist) {
      return const Icon(
        Icons.loop_rounded,
        size: iconSize,
        color: subColor,
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.loop_rounded,
            size: iconSize,
            color: mainColor,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: mainColor),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // const SizedBox(
        //   width: 48,
        // ),
        GestureDetector(
          onTap: () {
            if (toggleLoop != null) {
              toggleLoop!();
            }
          },
          child: _loopIcon(context),
        ),
        const SizedBox(
          width: 36,
        ),
        InkWell(
          customBorder: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          onTap: isPlaylist ? onPrevious : null,
          highlightColor: mainColor,
          child: const Icon(
            Icons.skip_previous_rounded,
            color: mainColor,
            size: 40,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(90),
          onTap: onPlay,
          highlightColor: mainColor,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withAlpha(60),
                    blurRadius: 9.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  ),
                ]),
            child: Icon(
              isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: mainColor,
              size: 70,
            ),
          ),
        ),

        const SizedBox(
          width: 16,
        ),
        InkWell(
          customBorder: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          onTap: isPlaylist ? onNext : null,
          highlightColor: mainColor,
          child: const Icon(
            Icons.skip_next_rounded,
            color: mainColor,
            size: 40,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        if (onStop != null)
          InkWell(
            customBorder: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: onStop,
            highlightColor: mainColor,
            child: const Icon(
              Icons.stop_circle_rounded,
              color: mainColor,
              size: 40,
            ),
          ),
      ],
    );
  }
}
