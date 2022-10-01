// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:practica_1_kevin_gonzalez/pages/favorite_tracks_page/song_track_tile.dart';
import 'package:practica_1_kevin_gonzalez/providers/favorite_tracks.dart';
import 'package:provider/provider.dart';

class FavoriteTracksPage extends StatelessWidget {
  const FavoriteTracksPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Canciones favoritas'),
      ),
      body: ListView.builder(
        itemCount: context.watch<FavoriteTracks>().favoriteTracks.length,
        itemBuilder: (BuildContext context, int index) {
          return SongTrackTile(
            track: context.watch<FavoriteTracks>().favoriteTracks[index],
          );
        },
      ),
    );
  }
}
