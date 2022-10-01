part of 'recorder_bloc.dart';

@immutable
abstract class RecorderState {}

// Recording States
class RecorderInitialState extends RecorderState {}

class RecorderRecordingState extends RecorderState {
  final String? message;

  RecorderRecordingState({this.message});
}

class RecorderRecordingSuccessState extends RecorderState {
  final String pathToRecording;
  RecorderRecordingSuccessState({required this.pathToRecording});
}

class RecorderRecordingErrorState extends RecorderState {
  final String error;
  RecorderRecordingErrorState({required this.error});
}

class RecorderNoPermissionState extends RecorderState {}

// Api States
class RecorderAnalizingRecordingState extends RecorderState {}

class RecorderAnalysisSucessState extends RecorderState {
  final SongTrack track;
  RecorderAnalysisSucessState({required this.track});
}

class RecorderAnalysisErrorState extends RecorderState {
  final String error;
  RecorderAnalysisErrorState({required this.error});
}
