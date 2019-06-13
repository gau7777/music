import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayer/audioplayer.dart';

class Song extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final GoogleSignIn googleSignIn;
  Song({this.firebaseUser, this.googleSignIn});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SongState();
  }
}

enum PlayerState { playing, paused, stopped }

class _SongState extends State<Song> {
  Duration position;
  PlayerState playerState;
  StreamSubscription<Duration> _positionSubscription;
  StreamSubscription<AudioPlayerState> _audioPlayerStateSubscription;

  AudioPlayer audioPlayer = new AudioPlayer();

  Duration duration;
  Future<void> play() async {
    await audioPlayer.play(
        "https://firebasestorage.googleapis.com/v0/b/music-867d6.appspot.com/o/Vaaste-Song-(Dhvani-Bhanushali)-Mr-Jatt.mp3?alt=media&token=fef8d61d-c41c-482a-ac6a-54c6aeb726b2");
    setState(() => playerState = PlayerState.playing);
  }

  Future<void> pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Play'),
          onPressed: () {
            _positionSubscription = audioPlayer.onAudioPositionChanged
                .listen((p) => setState(() => position = p));

            _audioPlayerStateSubscription =
                audioPlayer.onPlayerStateChanged.listen((s) {
              if (s == AudioPlayerState.PLAYING) {
                setState(() => duration = audioPlayer.duration);
              } else if (s == AudioPlayerState.STOPPED) {
                setState(() {
                  position = duration;
                });
              }
            }, onError: (msg) {
              setState(() {
                playerState = PlayerState.stopped;
                duration = new Duration(seconds: 0);
                position = new Duration(seconds: 0);
              });
            });
          },
        ),
      ),
    );
  }
}
