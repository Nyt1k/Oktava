import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({
    Key? key,
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  }) : super(key: key);

  @override
  State<PositionSeekWidget> createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUser = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUser) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              width: 40,
              child: Text(
                durationToString(widget.currentPosition),
                style: const TextStyle(color: mainColor),
              ),
            ),
          ),
          Expanded(
            child: Slider(
              min: 0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: percent * widget.duration.inMilliseconds.toDouble(),
              activeColor: mainColor,
              onChanged: (newValue) {
                setState(() {
                  final to = Duration(milliseconds: newValue.floor());
                  _visibleValue = to;
                });
              },
              onChangeStart: (_) {
                setState(() {
                  listenOnlyUser = true;
                });
              },
              onChangeEnd: (newValue) {
                setState(() {
                  listenOnlyUser = false;
                  widget.seekTo(_visibleValue);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 40,
              child: Text(
                durationToString(widget.duration),
                style: const TextStyle(color: mainColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

  return '$twoDigitMinutes:$twoDigitSeconds';
}
