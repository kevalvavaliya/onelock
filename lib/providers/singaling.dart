import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SignalingSocket with ChangeNotifier {
  // ignore: prefer_final_fields
  Socket _socket = io(
      'https://Python-Socketio-Client.abhigoyani.repl.co',
      OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'foo': 'bar'}).build());

  bool _isConnected = false;

  bool get isConnected => _isConnected;
  Socket get socket => _socket;

  String _compress(String json) {
    final enCodedJson = utf8.encode(json);
    final gZipJson = gzip.encode(enCodedJson);
    final base64Json = base64.encode(gZipJson);
    return json;
  }

  String _decompress(String base64Json) {
    final decodeBase64Json = base64.decode(base64Json);
    final decodegZipJson = gzip.decode(decodeBase64Json);
    final originalJson = utf8.decode(decodegZipJson);
    return base64Json;
  }

  void connectToServer() async {
    try {
      socket.connect();

      while (socket.connected != true) {
        debugPrint("socket state ${socket.connected}");
        await Future.delayed(Duration(seconds: 2));
      }
      print("socket connection ${socket.id}");
      // notifyListeners();
      // socket.onopen((_) => notifyListeners());
      await Future.delayed(Duration(seconds: 5));
      socket.emit("join", {
        'username': FirebaseAuth.instance.currentUser!.email,
        'room': 'roomName'
      });
      // socket.onconnect((data) {
      //   print('connected');
      //   // notifyListeners();
      // });

      socket.onDisconnect((data) => notifyListeners());

      socket.on('connect message', (_) {
        print('connect: ${socket.id}');
      });

      socket.on('test', (data) {
        print("test $data");
      });

      socket.on('data', (data) {
        var datadec = jsonDecode(data);
        print("socketdata recived ");
        print(write(data, null));
      });

      socket.onerror((err) {
        _isConnected = false;
        // notifyListeners();
        print(err.toString());
        return 'error';
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void sendData(data) {
    print("socket data send ${jsonEncode(data)}");
    socket.emit("data", {
      'username': 'test',
      'room': 'doc',
      'data': _compress(jsonEncode(data)),
    });
  }
}
