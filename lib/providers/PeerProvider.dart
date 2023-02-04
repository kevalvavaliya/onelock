import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:onelock/models/Peermodel.dart';
import 'package:onelock/providers/singaling.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'dart:convert';

class PeerProvider extends ChangeNotifier {
  PeerModel peerModel = PeerModel();
  bool _offer = false;
  SignalingSocket? signalsocket;
  void update(SignalingSocket signalsockets) {
    signalsocket = signalsockets;
    signalsocket!.connectToServer();
    // print("is socket null ${signalsocket == null}");
  }

  Future<void> createConnection() async {
    peerModel.localPeerConnection = await createPeerConnection({
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    });

    peerModel.localPeerConnection!.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        }));
        signalsocket!.sendData({
          'type': 'candidate',
          'candidate': {
            'candidate': e.candidate.toString(),
            'sdpMid': e.sdpMid.toString(),
            'sdpMlineIndex': e.sdpMLineIndex,
          }
        });
      }
    };

    peerModel.localPeerConnection!.onIceConnectionState = (e) {
      print("ICE CONNECTION STATE" + e.toString());
    };

    peerModel.rtcDataChannel = await peerModel.localPeerConnection!
        .createDataChannel('datachannel 1', RTCDataChannelInit()..id = 1);
    peerModel.localPeerConnection!.onDataChannel = (channel) {
      peerModel.rtcDataChannel = channel;
    };

    peerModel.rtcDataChannel!.onDataChannelState = (state) {
      print('DATA CHANNEL state: ${state.toString()}');
    };
    peerModel.rtcDataChannel!.onMessage = (data) {
      print("ON MESSSAGE" + data.text);
    };
  }

  void createpeerOffer() async {
    var lp = await peerModel.localPeerConnection!.createOffer({});
    var session = parse(lp.sdp.toString());
    _offer = true;
    if (signalsocket == null) {
      print("socket null in peer");
    } else {
      print("CREATE OFFER" + jsonEncode(session));
      signalsocket!.sendData(session);
    } // peerModel.localPeerConnection!.setLocalDescription(lp);
    // await Dbutil.insertOffer(session);
  }

  void createpeerAnswer() async {
    var lp = await peerModel.localPeerConnection!.createAnswer({});
    peerModel.localPeerConnection!.setLocalDescription(lp);
    signalsocket!.sendData(jsonEncode(lp.sdp.toString()));
    print("CREATE ANSWER" + jsonEncode(parse(lp.sdp.toString())));
  }

  void setpeerRemoteDesc(String jsonSdp) async {
    dynamic session = await jsonDecode(jsonSdp);

    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print("REMOTE DESC" + description.toMap().toString());

    await peerModel.localPeerConnection!.setRemoteDescription(description);
  }

  void setpeeraddCandidate(String sdpText) async {
    String jsonString = sdpText;
    print(jsonString);
    dynamic session = await jsonDecode(jsonString);
    print(session['candidate']);
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await peerModel.localPeerConnection!.addCandidate(candidate);
  }
}
