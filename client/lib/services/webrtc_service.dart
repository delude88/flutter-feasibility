import 'dart:async';
import 'dart:convert';

import 'package:flutter_feasibility/io/socket_connection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCConnection {
  final String peerId;
  final RTCPeerConnection pc;
  final List<RTCDataChannel> remoteDataChannels = <RTCDataChannel>[];
  final List<MediaStream> remoteStreams = <MediaStream>[];

  //final List<RTCIceCandidate> remoteCandidates = <RTCIceCandidate>[];

  WebRTCConnection(this.peerId, this.pc);
}

class WebRTCEvent {}

class LocalStreamAdded extends WebRTCEvent {}

class LocalStreamRemoved extends WebRTCEvent {}

class LocalDataChannelAdded extends WebRTCEvent {}

class LocalDataChannelRemoved extends WebRTCEvent {}

abstract class WebRTCService {
  Stream<WebRTCEvent> get events;

/*
  Function(MediaStream stream)? onLocalSteamAdded;
  Function(MediaStream stream)? onLocalStreamRemoved;
  Function(RTCDataChannel dataChannel)? onLocalDataChannelAdded;
  Function(RTCDataChannel dataChannel)? onLocalDataChannelRemoved;
  Function(WebRTCConnection connection, MediaStream stream)? onRemoteStreamAdded;
  Function(WebRTCConnection connection, MediaStream stream)? onRemoteStreamRemoved;
  Function(WebRTCConnection connection, RTCDataChannel dataChannel)? onRemoteDataChannelAdded;
  Function(WebRTCConnection connection, RTCDataChannel dataChannel)? onRemoteDataChannelRemoved;
 */
  String get peerId;

  List<WebRTCConnection> get connections;

  List<MediaStream> get localMediaStreams;

  List<RTCDataChannel> get localDataChannels;

  WebRTCConnection? getConnectionTo(String remotePeerId);

  Future<void> addStream(MediaStream stream);

  Future<void> removeStream(String id);

  Future<void> createDataChannel(String label);

  Future<void> removeDataChannel(String label);

  Future<void> addPeer(String remotePeerId);

  Future<void> removePeer(String remotePeerId);

  Future<void> close();
}

class WebRTCServiceImpl implements WebRTCService {
  final SocketConnection _repository;
  @override
  final String peerId;
  @override
  final List<WebRTCConnection> connections = [];
  @override
  final List<MediaStream> localMediaStreams = [];
  @override
  final List<RTCDataChannel> localDataChannels = [];
  final StreamController<WebRTCEvent> _eventController =
      StreamController<WebRTCEvent>.broadcast();

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'}
    ]
  };
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };
  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  WebRTCServiceImpl(this._repository, this.peerId) {
    _repository.events.listen((event) async {
      switch (event.event) {
        case "candidate":
          {
            // Received an remote candidate
            final data = jsonDecode(event.payload);
            assert(data["to"] == peerId);
            final connection =
                getConnectionTo(data["from"]) ?? await addPeer(data["from"]);
            final candidate = data["candidate"] as RTCIceCandidate;
            connection.pc.addCandidate(candidate);
          }
          break;
        case "description":
          {
            // Received an remote description
            // Is there any connection for this description?
            final data = jsonDecode(event.payload);
            assert(data["to"] == peerId);
            final connection =
                getConnectionTo(data["from"]) ?? await addPeer(data["from"]);
            final description = data["description"] as RTCSessionDescription;
            connection.pc.setRemoteDescription(description);
            if (description.type == "offer") {
              _createAnswer(connection);
            }
          }
          break;
      }
    });
  }

  @override
  Stream<WebRTCEvent> get events => _eventController.stream;

  String get sdpSemantics =>
      WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

  @override
  Future<void> close() async {
    for (var connection in connections) {
      await connection.pc.close();
    }
  }

  @override
  Future<WebRTCConnection> addPeer(String remotePeerId) async {
    if (getConnectionTo(remotePeerId) != null) {
      throw UnimplementedError("Create an custom exection here");
    }
    print("Creating connection to $remotePeerId");
    // Create connection
    final RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);
    final WebRTCConnection connection = WebRTCConnection(remotePeerId, pc);
    connections.add(connection);
    pc.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
      // 1 second is just an heuristic value and should be thoroughly tested in our environment.
      await Future.delayed(
          const Duration(seconds: 1),
          () => _repository.send('candidate', {
                'to': remotePeerId,
                'from': peerId,
                'candidate': {
                  'sdpMLineIndex': candidate.sdpMLineIndex,
                  'sdpMid': candidate.sdpMid,
                  'candidate': candidate.candidate,
                }
              }));
    };
    return connection;
  }

  @override
  Future<void> addStream(MediaStream stream) async {
    if (this.localMediaStreams.any((element) => stream.id == stream.id))
      // TODO: implement addStream
      throw UnimplementedError();
  }

  @override
  Future<void> createDataChannel(String label) {
    // Create local data channel
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    // TODO: implement createDataChannel
    throw UnimplementedError();
  }

  @override
  Future<void> removeDataChannel(String label) async {
    localDataChannels.removeWhere((channel) => channel.label == label);
  }

  @override
  Future<void> removePeer(String remotePeerId) async {
    final connection = getConnectionTo(remotePeerId);
    if (connection != null) {
      print("Removing connection to $remotePeerId");
      await connection.pc.close();
    }
  }

  @override
  Future<void> removeStream(String id) async {
    localMediaStreams.removeWhere((stream) => stream.id == id);
  }

  @override
  WebRTCConnection? getConnectionTo(String remotePeerId) {
    try {
      return connections
          .firstWhere((element) => element.peerId == remotePeerId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _createOffer(WebRTCConnection connection) async {
    try {
      // RTCSessionDescription s = await connection.pc.createOffer(media == 'data' ? _dcConstraints : {});
      RTCSessionDescription s = await connection.pc.createOffer({});
      await connection.pc.setLocalDescription(s);
      _repository.send('description', {
        'to': connection.peerId,
        'from': peerId,
        'description': {'sdp': s.sdp, 'type': s.type},
        // 'media': media,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createAnswer(WebRTCConnection connection) async {
    try {
      // RTCSessionDescription s = await connection.pc.createAnswer(media == 'data' ? _dcConstraints : {});
      RTCSessionDescription s = await connection.pc.createAnswer({});
      await connection.pc.setLocalDescription(s);
      _repository.send('description', {
        'to': connection.peerId,
        'from': peerId,
        'description': {'sdp': s.sdp, 'type': s.type},
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
