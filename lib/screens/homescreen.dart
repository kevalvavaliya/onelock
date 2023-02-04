import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:onelock/models/Peermodel.dart';
import 'package:onelock/providers/PeerProvider.dart';
import 'package:onelock/providers/gauthprovider.dart';
import 'package:onelock/providers/singaling.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Provider.of<PeerProvider>(context).createConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: ElevatedButton(
                          onPressed: () =>
                              Provider.of<GauthProvider>(context, listen: false)
                                  .signOutWithGoogle(),
                          child: Text("signout"))),
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          Provider.of<PeerProvider>(context, listen: false)
                              .createpeerOffer(),
                      child: Text("Create offer"),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          Provider.of<SignalingSocket>(context, listen: false)
                              .connectToServer(),
                      child: Text("socket test"),
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
          }),
    );
  }
}
