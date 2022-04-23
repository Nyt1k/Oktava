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
      AudioPlayerModel(
        id: '3',
        audio: Audio("assets/audios/country_2.mp3",
            metas: Metas(
                id: '3',
                title: 'Song 3',
                artist: "Joe Pog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '4',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '4',
                title: 'Song 4',
                artist: "Joe Gog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '5',
        audio: Audio("assets/audios/country_2.mp3",
            metas: Metas(
                id: '5',
                title: 'Song 5',
                artist: "Joe Log",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '6',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '6',
                title: 'Song 6',
                artist: "Joe Cog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '7',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '7',
                title: 'Song 7',
                artist: "Joe Cog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '8',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '8',
                title: 'Song 8',
                artist: "Joe Cog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '9',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '9',
                title: 'Song 9',
                artist: "Joe Cog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
      AudioPlayerModel(
        id: '10',
        audio: Audio("assets/audios/country.mp3",
            metas: Metas(
                id: '10',
                title: 'Song 10',
                artist: "Joe Cog",
                album: "Country road",
                image: const MetasImage.asset("assets/images/country.jpg"))),
        isPlaying: false,
      ),
    ];
  }
}
