part of 'recorder_bloc.dart';

abstract class RecorderEvent extends Equatable {
  const RecorderEvent();

  @override
  List<Object> get props => [];
}

class RecorderStartRecordingEvent extends RecorderEvent {
  const RecorderStartRecordingEvent();

  @override
  List<Object> get props => [];
}

class RecorderAnalizeRecordingEvent extends RecorderEvent {
  final String pathToRecording;
  const RecorderAnalizeRecordingEvent({required this.pathToRecording});
  @override
  List<Object> get props => [];
}
