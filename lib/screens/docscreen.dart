import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DocScreen extends StatelessWidget {
  
  const DocScreen({super.key});
  static const routeName = '/docscreen';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Docscreen"),
    );
  }
}
