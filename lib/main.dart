import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onelock/providers/PeerProvider.dart';
import 'package:onelock/providers/gauthprovider.dart';
import 'package:onelock/screens/docscreen.dart';
import 'package:onelock/screens/homescreen.dart';
import 'package:onelock/screens/loginscreen.dart';
import 'package:onelock/screens/navbarscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => GauthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PeerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), //it give a token whter it is authenticed or not
          builder: (context, userSnapshot) {
            // print("12434242");
            print(userSnapshot.connectionState.toString());
            // print(userSnapshot.hasData);
            // print(userSnapshot.toString());
            if (userSnapshot.hasData) {
              print(userSnapshot.data);
              // print("cnxvxlkffjdlfjfhjfjkf");
              // print(userSnapshot.hasData);
              // print(userSnapshot.toString());
              //if data is found mean userr authanticated so we go to chatscreem
              return NavbarScreen();
            } else {
              //and no data so not auth.. so retry
              return LoginScreen();
            }
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          NavbarScreen.routeName: (context) => NavbarScreen(),
          DocScreen.routeName: (context) => DocScreen()
        },
      ),
    );
  }
}
