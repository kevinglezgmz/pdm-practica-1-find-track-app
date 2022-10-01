import 'dart:convert';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica_1_kevin_gonzalez/secrets.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

Uri _url = Uri.parse('https://api.audd.io/');

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  Record record = Record();

  RecorderBloc() : super(RecorderInitialState()) {
    on<RecorderStartRecordingEvent>(_startRecording);
    on<RecorderAnalizeRecordingEvent>(_analyzeRecording);
  }

  FutureOr<void> _startRecording(
      RecorderStartRecordingEvent event, Emitter<RecorderState> emit) async {
    try {
      // Check microphone access and request permission
      await _checkMicrophonePermission();
      await _assertNotRecordingAlready();
      String recordingSavePath = await _getExternalDirPath();
      // Start recording
      await _initRecording('$recordingSavePath/myFile.wav');
      emit(RecorderRecordingState());
      // Wait for recording to finish with a 6s delay after being called
      String recordingPath = await _finishRecording(const Duration(seconds: 6));
      emit(RecorderRecordingSuccessState(pathToRecording: recordingPath));
    } on _StateException catch (errorState) {
      emit(errorState.nextState);
    }
  }

  FutureOr<void> _analyzeRecording(
      RecorderAnalizeRecordingEvent event, Emitter<RecorderState> emit) async {
    Map<String, String> requestBody = {
      'api_token': API_KEY,
      'return': 'apple_music,spotify',
    };
    MultipartFile multipartFile =
        await MultipartFile.fromPath('file', event.pathToRecording);
    MultipartRequest request = MultipartRequest('POST', _url)
      ..fields.addAll(requestBody)
      ..files.add(multipartFile);
    StreamedResponse response = await request.send();
    final Response parsedResponse = await Response.fromStream(response);
    if (parsedResponse.statusCode != 200) {
      return null;
    }
    dynamic parsedBody = jsonDecode(parsedResponse.body);
    if (parsedBody['status'] != 'success' || parsedBody['result'] == null) {
      emit(RecorderAnalysisErrorState(error: 'error'));
      return;
    }
    dynamic result = parsedBody['result'];
    dynamic apple = result['apple_music'];
    dynamic spotify = result['spotify'];
    spotify?.remove('available_markets');
    spotify?['album'].remove('available_markets');
    spotify?['album'].remove('album_type');
    spotify?['album'].remove('artists');
    spotify?['album'].remove('href');
    apple?.remove('previews');
    apple?.remove('artwork');
    result.remove('apple_music');
    result.remove('spotify');
    emit(
      RecorderAnalysisSucessState(
        track: SongTrack(
          name: result['title'],
          imageUrl: spotify?['album']?['images']?[0]?['url'],
          album: result['album'],
          date: result['release_date'],
          artist: result['artist'],
          spotifyUrl: spotify?['external_urls']?['spotify'],
          appleUrl: apple?['url'],
          listenUrl: result['song_link'],
        ),
      ),
    );
  }

  Future<void> _checkMicrophonePermission() async {
    if (await record.hasPermission() == false) {
      throw _StateException(
        nextState: RecorderRecordingState(
          message: 'Solicitando acceso al microfono',
        ),
      );
    }
  }

  Future<void> _assertNotRecordingAlready() async {
    if (await record.isRecording()) {
      throw _StateException(
        nextState: RecorderRecordingState(
          message: 'Grabación en curso...',
        ),
      );
    }
  }

  FutureOr<String> _getExternalDirPath() async {
    final appDir = await getExternalStorageDirectory();
    if (appDir == null) {
      throw _StateException(
        nextState: RecorderRecordingErrorState(
          error: 'No se pudo acceder al directorio',
        ),
      );
    }
    return appDir.path;
  }

  FutureOr<void> _initRecording(String fileName) async {
    await record.start(
      path: fileName,
      encoder: AudioEncoder.aacHe,
    );
  }

  FutureOr<String> _finishRecording(Duration delay) async {
    await Future.delayed(delay);
    String? filePath = await record.stop();
    if (filePath == null) {
      throw _StateException(
        nextState: RecorderRecordingErrorState(
          error: 'No se pudo almacenar la grabacion',
        ),
      );
    }
    return filePath;
  }
}

class SongTrack {
  final String? name;
  final String? imageUrl;
  final String? album;
  final String? date;
  final String? artist;
  final String? spotifyUrl;
  final String? appleUrl;
  final String? listenUrl;

  SongTrack({
    required this.spotifyUrl,
    required this.appleUrl,
    required this.listenUrl,
    required this.name,
    required this.imageUrl,
    required this.album,
    required this.date,
    required this.artist,
  });
}

class _StateException implements Exception {
  final RecorderState nextState;
  _StateException({required this.nextState});
}
