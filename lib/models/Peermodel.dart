import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'dart:convert';

class PeerModel {
  RTCSessionDescription? local;
  RTCSessionDescription? remote;
  RTCPeerConnection? remotePeerConnection;

  RTCPeerConnection? localPeerConnection;

  RTCDataChannel? rtcDataChannel;
}
  

