import 'package:flutter/material.dart';

class CustomView extends StatefulWidget {
  final AppBar appBar;
  final Widget drawer;
  final Widget body;

  const CustomView({
    super.key,
    required this.appBar,
    required this.drawer,
    required this.body,
  });

  @override
  State<CustomView> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: widget.body,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Container(
              color: Colors.blue,
              child: const Text("data"),
            ),
          )
        ],
      ),
    );
  }
}
