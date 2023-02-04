import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gauthprovider.dart';

class LoginScreen extends StatelessWidget {
  Future<void> onSubmitGoogleSignup(BuildContext context) async {
    print("object");
    await Provider.of<GauthProvider>(context, listen: false)
        .signUpWithGoogle(context);
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    final mxheight = MediaQuery.of(context).size.height;
    final mxwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      child: Center(
        child: ElevatedButton(
          child: Text("Google signin"),
          onPressed: () {
            onSubmitGoogleSignup(context);
          },
        ),
      ),
    ));
  }
}
