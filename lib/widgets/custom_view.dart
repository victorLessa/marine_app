import 'package:flutter/material.dart';

class CustomView extends StatefulWidget {
  final AppBar? appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? floatingActionButton;

  const CustomView({
    super.key,
    this.appBar,
    this.drawer,
    required this.body,
    this.floatingActionButton,
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
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.blue,
        child: const Center(
            child: Text(
          "Anúncio",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: widget.body,
      ),
    );
  }
}
