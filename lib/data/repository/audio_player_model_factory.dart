import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:oktava/data/model/audio_player_model.dart';

class AudioPlayerModelFactory {
  static List<AudioPlayerModel> getAudioModels() {
    return [
      AudioPlayerModel(
        id: '1',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '1',
                title: 'Song 1',
                artist: "Joe Rog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '2',
        audio: Audio("assets/audios/country_2.mp3",
            metas: Metas(
                id: '2',
                title: 'Song 2',
                artist: "Joe Bog",
                album: "Country road, take me home",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
    ];
  }
}
