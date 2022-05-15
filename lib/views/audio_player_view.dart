import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';

class AudioPlayerView extends StatefulWidget {
  final AuthUser user;
  const AudioPlayerView({Key? key, required this.user}) : super(key: key);

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  TextEditingController editingController = TextEditingController();
  List<AudioPlayerModel> list = [];
  final sortList = ['By title', 'By artist', 'By album', 'By track number'];
  String dropDownValue = 'By track number';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: secondaryColor,
      child: RefreshIndicator(
        strokeWidth: 2,
        color: mainColor,
        backgroundColor: secondaryColor,
        onRefresh: _refresh,
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          builder: (context, state) {
            if (state is AudioPlayerInitialState) {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(const InitializeAudioPlayerEvent(null));
              return buildCircularProgress();
            } else if (state is AudioPlayerReadyState) {
              return buildReadyTrackList(state);
            } else if (state is AudioPlayerPlayingState) {
              return buildPlayingTrackList(state);
            } else if (state is AudioPlayerPausedState) {
              return buildPausedTrackList(state);
            } else {
              return buildUnknownStateError();
            }
          },
        ),
      ),
    );
  }

  bool isFavorite(AudioPlayerModel model) {
    if (widget.user.userFavorites != null) {
      if (widget.user.userFavorites!.contains(model.id)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget buildReadyTrackList(AudioPlayerReadyState state) {
    return Column(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: additionalColor.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (list.isEmpty) {
                          list.addAll(state.entityList);
                        }
                        state.entityList.clear();
                        List<AudioPlayerModel> dummySearchList = [];
                        dummySearchList.addAll(list);
                        if (value.isNotEmpty) {
                          List<AudioPlayerModel> dummyListData = [];
                          for (var item in dummySearchList) {
                            if (item.audio.metas.title!.contains(value) ||
                                item.songTags!.contains(value)) {
                              dummyListData.add(item);
                            }
                          }
                          setState(() {
                            state.entityList.clear();
                            state.entityList.addAll(dummyListData);
                          });
                        } else {
                          setState(() {
                            state.entityList.addAll(list);
                          });
                        }
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: mainColor,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: additionalColor, width: 2),
                      color: secondaryColor,
                    ),
                    child: Theme(
                      data: ThemeData(canvasColor: additionalColor),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            iconSize: 34,
                            icon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: mainColor,
                            ),
                            isExpanded: false,
                            items: sortList.map(buildMenuitem).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValue = value!;
                                List<AudioPlayerModel> newList = [];
                                newList.addAll(sortAllList(
                                    state.entityList, dropDownValue));
                                state.entityList.clear();
                                state.entityList.addAll(newList);
                              });
                            },
                            value: dropDownValue,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return AudioTrackWidget(
                  audioPlayerModel: state.entityList[index],
                  isFavorite: isFavorite(state.entityList[index]),
                  user: widget.user);
            },
            itemCount: state.entityList.length,
          ),
        ),
      ],
    );
  }

  Widget buildPlayingTrackList(AudioPlayerPlayingState state) {
    return Column(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: mainColor.withOpacity(0.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (list.isEmpty) {
                          list.addAll(state.entityList);
                        }
                        state.entityList.clear();
                        List<AudioPlayerModel> dummySearchList = [];
                        dummySearchList.addAll(list);
                        if (value.isNotEmpty) {
                          List<AudioPlayerModel> dummyListData = [];
                          for (var item in dummySearchList) {
                            if (item.audio.metas.title!.contains(value)) {
                              dummyListData.add(item);
                            }
                          }
                          setState(() {
                            state.entityList.clear();
                            state.entityList.addAll(dummyListData);
                          });
                        } else {
                          setState(() {
                            state.entityList.addAll(list);
                          });
                        }
                      },
                      cursorColor: mainColor,
                      controller: editingController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: mainColor,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: additionalColor, width: 2),
                      color: secondaryColor,
                    ),
                    child: Theme(
                      data: ThemeData(canvasColor: additionalColor),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            iconSize: 34,
                            icon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: mainColor,
                            ),
                            isExpanded: false,
                            items: sortList.map(buildMenuitem).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValue = value!;
                                List<AudioPlayerModel> newList = [];
                                newList.addAll(sortAllList(
                                    state.entityList, dropDownValue));
                                state.entityList.clear();
                                state.entityList.addAll(newList);
                              });
                            },
                            value: dropDownValue,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 124),
                  itemBuilder: (context, index) {
                    return AudioTrackWidget(
                        audioPlayerModel: state.entityList[index],
                        isFavorite: isFavorite(state.entityList[index]),
                        user: widget.user);
                  },
                  itemCount: state.entityList.length,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: const PlayerWidget(
                  backRoute: HomePage(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPausedTrackList(AudioPlayerPausedState state) {
    return Column(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: mainColor.withOpacity(0.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (list.isEmpty) {
                          list.addAll(state.entityList);
                        }
                        state.entityList.clear();
                        List<AudioPlayerModel> dummySearchList = [];
                        dummySearchList.addAll(list);
                        if (value.isNotEmpty) {
                          List<AudioPlayerModel> dummyListData = [];
                          for (var item in dummySearchList) {
                            if (item.audio.metas.title!.contains(value)) {
                              dummyListData.add(item);
                            }
                          }
                          setState(() {
                            state.entityList.clear();
                            state.entityList.addAll(dummyListData);
                          });
                        } else {
                          setState(() {
                            state.entityList.addAll(list);
                          });
                        }
                      },
                      cursorColor: mainColor,
                      controller: editingController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: mainColor,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: additionalColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: additionalColor, width: 2),
                      color: secondaryColor,
                    ),
                    child: Theme(
                      data: ThemeData(canvasColor: additionalColor),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            iconSize: 34,
                            icon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: mainColor,
                            ),
                            isExpanded: false,
                            items: sortList.map(buildMenuitem).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValue = value!;
                                List<AudioPlayerModel> newList = [];
                                newList.addAll(sortAllList(
                                    state.entityList, dropDownValue));
                                state.entityList.clear();
                                state.entityList.addAll(newList);
                              });
                            },
                            value: dropDownValue,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemBuilder: (context, index) {
                    return AudioTrackWidget(
                        audioPlayerModel: state.entityList[index],
                        isFavorite: isFavorite(state.entityList[index]),
                        user: widget.user);
                  },
                  itemCount: state.entityList.length,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: const PlayerWidget(
                  backRoute: HomePage(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuitem(String item) => DropdownMenuItem(
        value: item,
        child: Center(
          child: Container(
            width: 120,
            alignment: Alignment.center,
            child: Text(
              item,
              style: const TextStyle(color: mainColor),
            ),
          ),
        ),
      );

  List<AudioPlayerModel> sortAllList(
      List<AudioPlayerModel> list, String order) {
    if (order == 'By title') {
      list.sort((a, b) {
        return a.audio.metas.title!
            .toLowerCase()
            .compareTo(b.audio.metas.title!.toLowerCase());
      });
    } else if (order == 'By artist') {
      list.sort((a, b) {
        return a.audio.metas.artist!
            .toLowerCase()
            .compareTo(b.audio.metas.artist!.toLowerCase());
      });
    } else if (order == 'By album') {
      list.sort((a, b) {
        return a.audio.metas.album!
            .toLowerCase()
            .compareTo(b.audio.metas.album!.toLowerCase());
      });
    } else {
      list.sort((a, b) {
        return a.id.toLowerCase().compareTo(b.id.toLowerCase());
      });
    }
    return list;
  }

  Widget buildCircularProgress() {
    return customCircularIndicator();
  }

  Widget buildUnknownStateError() {
    return const Text("Unknown state error");
  }

  Future<void> _refresh() {
    BlocProvider.of<AudioPlayerBloc>(context)
        .add(const AudioItemsRefreshAudioPlayerEvent());
    return Future.delayed(const Duration(seconds: 1));
  }
}
