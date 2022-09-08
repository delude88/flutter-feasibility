import 'package:flutter_feasibility/store/eventor.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Session {
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
  List<MediaStream> _remoteStreams = <MediaStream>[];
}

class WebRTCService {
  final Eventor _eventor;

  WebRTCService(this._eventor) {
    _eventor.on("user-added", (username) {
      print('WebRTC: member ${username} added');
    });
    _eventor.on("user-removed", (username) {
      print('WebRTC: member ${username} removed');
    });
  }

  void close() {
    print("CLEANUP WEBRTC SERVICE");
    //TODO: Checkout if off methods are really required
  }
}
