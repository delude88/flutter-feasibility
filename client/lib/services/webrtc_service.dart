import 'dart:async';

import 'package:flutter_feasibility/io/repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Session {
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
  List<MediaStream> _remoteStreams = <MediaStream>[];
}

class WebRTCService {
  final Repository repository;
  StreamSubscription<Event>? _listener;

  WebRTCService(this.repository) {
    /*
    _listener = repository.events
        .where((event) => event.event == 'user-added')
        .listen((event) {
      if (event.event == 'user-added') {
        print('WebRTC: member ${event.payload} added');
        return;
      }
      if (event.event == 'user-removed') {
        print('WebRTC: member ${event.payload} removed');
        return;
      }
    });*/
  }

  void close() {
    print("CLEANUP WEBRTC SERVICE");
    _listener?.cancel();
  }
}
