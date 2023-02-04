import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

class RTCConnect extends StatelessWidget {
  RTCPeerConnection? remotePeerConnection;

  RTCPeerConnection? localPeerConnection;

  RTCDataChannel? rtcDataChannel;
  void createConnection() async {
    localPeerConnection = await createPeerConnection({
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    });

    localPeerConnection!.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        }));
      }
    };

    localPeerConnection!.onIceConnectionState = (e) {
      print("ICE CONNECTION STATE" + e.toString());
    };
    
    rtcDataChannel = await localPeerConnection!
        .createDataChannel('datachannel 1', RTCDataChannelInit()..id = 1);
    localPeerConnection!.onDataChannel =  (channel) {
      rtcDataChannel = channel;
    };
    
    rtcDataChannel!.onDataChannelState = (state) {
      print('DATA CHANNEL state: ${state.toString()}');
    };
    rtcDataChannel!.onMessage = (data) {
      print("ON MESSSAGE" + data.text);
    };
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}