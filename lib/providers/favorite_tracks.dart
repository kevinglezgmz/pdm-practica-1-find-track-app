import 'package:flutter/cupertino.dart';
import 'package:practica_1_kevin_gonzalez/blocs/bloc/recorder_bloc.dart';

class FavoriteTracks with ChangeNotifier {
  final Map<String, SongTrack> _favoriteTracks = {};
  List<dynamic> get favoriteTracks => List.from(_favoriteTracks.values);

  bool addFavoriteTrack(SongTrack track) {
    if (track.name == null || _favoriteTracks[track.name] != null) {
      return false;
    }
    _favoriteTracks[track.name!] = track;
    notifyListeners();
    return true;
  }

  bool removeFavoriteTrack(SongTrack track) {
    if (track.name == null) {
      return false;
    }
    _favoriteTracks.remove(track.name);
    notifyListeners();
    return true;
  }
}
