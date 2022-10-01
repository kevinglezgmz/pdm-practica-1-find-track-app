import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:practica_1_kevin_gonzalez/blocs/bloc/recorder_bloc.dart';
import 'package:practica_1_kevin_gonzalez/pages/favorite_tracks_page/favorite_tracks_page.dart';
import 'package:practica_1_kevin_gonzalez/pages/track_result_page/track_result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 140),
                child: _getTitleBlocConsumer(),
              ),
            ),
          ),
          SizedBox(
            height: 170 * 2,
            child: _recordingButton(context),
          ),
          _favoritesButton(context)
        ],
      ),
    );
  }

  BlocConsumer<RecorderBloc, RecorderState> _getTitleBlocConsumer() {
    return BlocConsumer<RecorderBloc, RecorderState>(
      listener: (context, state) {
        if (state is RecorderRecordingState) {
          _maybeShowSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is RecorderRecordingState) {
          return _getTitleText('Grabando audio...');
        } else if (state is RecorderAnalizingRecordingState ||
            state is RecorderRecordingSuccessState) {
          return _getTitleText('Analizando audio...');
        }
        return _getTitleText('Toque para escuchar');
      },
    );
  }

  BlocConsumer<RecorderBloc, RecorderState> _recordingButton(
      BuildContext context) {
    return BlocConsumer<RecorderBloc, RecorderState>(
      listener: (context, state) {
        if (state is RecorderRecordingSuccessState) {
          context.read<RecorderBloc>().add(
                RecorderAnalizeRecordingEvent(
                  pathToRecording: state.pathToRecording,
                ),
              );
        } else if (state is RecorderAnalysisSucessState) {
          _navigateToResultsPage(context, state.track);
        } else if (state is RecorderAnalysisErrorState) {
          _showConfirmDialog(
            context,
            'Error',
            'No se encontró ningún resultado, por favor intenta de nuevo.',
          );
        }
      },
      builder: (context, state) {
        bool isRecording = state is RecorderRecordingState;
        return _getAvatarGlow(context, isRecording);
      },
    );
  }

  GestureDetector _getAvatarGlow(BuildContext context, bool isRecording) {
    return GestureDetector(
      onTap: () async {
        context.read<RecorderBloc>().add(const RecorderStartRecordingEvent());
      },
      child: AvatarGlow(
        animate: isRecording,
        glowColor: const Color.fromARGB(255, 253, 253, 84),
        endRadius: 150,
        duration: const Duration(milliseconds: 1500),
        showTwoGlows: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        curve: const CosAnimationCurve(),
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 60, 60, 60),
          radius: 100,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset('assets/musica.png'),
          ),
        ),
      ),
    );
  }

  Expanded _favoritesButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 60, 60, 60),
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 70,
            width: 70,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.favorite,
                size: 32,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavoriteTracksPage(),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Text _getTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
      ),
    );
  }

  void _maybeShowSnackBar(BuildContext context, String? text) {
    if (text != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void _navigateToResultsPage(BuildContext context, SongTrack track) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrackResultPage(
          track: track,
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

class CosAnimationCurve extends Curve {
  const CosAnimationCurve();

  @override
  double transformInternal(double t) {
    return -cos(2 * pi * (t - 1.5) / 2) * 0.6 + 0.6;
  }
}
