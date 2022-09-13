import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Member extends Equatable {
  final String id;
  final String name;

  final List<MediaStream> mediaStreams;

  final List<RTCDataChannel> dataChannels;

  const Member(this.id, this.name, this.mediaStreams, this.dataChannels);

  @override
  List<Object?> get props => [id, name, mediaStreams, dataChannels];
}
