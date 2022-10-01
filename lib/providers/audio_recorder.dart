import 'package:record/record.dart';

final record = Record();

Future<String?> recordAudio(String filepath) async {
  // Check and request permission
  if (await record.hasPermission() == false) {
    throw 'Solicitando acceso al microfono';
  }
  if (await record.isRecording()) {
    throw 'Grabación en curso...';
  }

  // Start recording
  await record.start(path: filepath, encoder: AudioEncoder.aacHe);
  await Future.delayed(const Duration(seconds: 6));
  String? filePath = await record.stop();
  return filePath;
}
