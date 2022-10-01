import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1_kevin_gonzalez/blocs/bloc/recorder_bloc.dart';
import 'package:practica_1_kevin_gonzalez/pages/home_page/home_page.dart';
import 'package:practica_1_kevin_gonzalez/providers/favorite_tracks.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => FavoriteTracks()),
      ],
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider(
        create: (context) => RecorderBloc(),
        child: const HomePage(),
      ),
    );
  }
}
