import 'package:flutter/material.dart';
import 'package:practica_1_kevin_gonzalez/blocs/bloc/recorder_bloc.dart';
import 'package:practica_1_kevin_gonzalez/pages/track_result_page/track_result_page.dart';
import 'package:practica_1_kevin_gonzalez/providers/favorite_tracks.dart';
import 'package:provider/provider.dart';

class SongTrackTile extends StatelessWidget {
  final SongTrack track;
  const SongTrackTile({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      padding: const EdgeInsets.only(left: 64, right: 64),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TrackResultPage(track: track),
          ));
        },
        child: Stack(
          children: [
            _getFixedSizeImage(),
            _getNameArtistBox(context),
            _getUnFavoriteIcon(context)
          ],
        ),
      ),
    );
  }

  IconButton _getUnFavoriteIcon(BuildContext context) {
    return IconButton(
      tooltip: 'Eliminar de favoritos',
      onPressed: () {
        showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Eliminar de favoritos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            content: const Text(
              'Esta canción se eliminará de tus favoritos. ¿Deseas continuar?',
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(context
                      .read<FavoriteTracks>()
                      .removeFavoriteTrack(track));
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ).then((value) {
          if (value == null) return;
          if (value == true) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('¡Se ha eliminado la canción a favoritos!'),
                ),
              );
          }
        });
      },
      icon: const Icon(Icons.favorite),
    );
  }

  Positioned _getNameArtistBox(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withAlpha(220),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            _getSingleChildScrollViewText(
                track.name ?? 'No name', 18, FontWeight.bold),
            _getSingleChildScrollViewText(
                track.artist ?? 'No artist', 14, FontWeight.w500),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _getSingleChildScrollViewText(
      String text, double fontSize, FontWeight fontWeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ClipRRect _getFixedSizeImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: SizedBox(
          width: double.infinity,
          child: Image.network(
            track.imageUrl!,
            fit: BoxFit.fill,
            loadingBuilder: ((context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }
}
