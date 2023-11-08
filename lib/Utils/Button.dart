import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final GestureTapCallback onPressed;
  final String text1;
  final double height;
  double width;
  double font;
  bool shadow;
  FontWeight? weight;
  bool colored;
  Color? border;
  String? image;

  MyButton(
      {Key? key,
      required this.onPressed,
      required this.text1,
      this.font = 0,
      this.colored = true,
      this.border,
      this.shadow = true,
      this.image = '',
      this.weight,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.colored == true
            ? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(height * 0.15)),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF72BAA3), Color(0xFF7EC349)]),
                boxShadow: [
                    widget.shadow == true
                        ? BoxShadow(
                            color: const Color(0xFF1178B8).withOpacity(0.3),
                            spreadRadius: 2,
                            offset: const Offset(1, 1.5),
                            blurRadius: 2,
                          )
                        : const BoxShadow(color: Colors.transparent),
                  ])
            : BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(height * 0.15)),
                border: Border.all(
                    color: widget.text1 == "Discard"
                        ? Colors.red
                        : Colors.transparent),
                color: Colors.white,
                boxShadow: [
                    BoxShadow(
                      color: widget.text1 == "Discard"
                          ? Colors.red.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      offset: const Offset(1, 2),
                      blurRadius: 2,
                    ),
                  ]),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: widget.width,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                widget.image == ''
                    ? const SizedBox(width: 0)
                    : Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Image.asset(widget.image!,
                            fit: BoxFit.fitHeight, height: height * 0.035),
                      ),
                Text(
                  widget.text1,
                  style: TextStyle(
                      color: widget.colored == false
                          ? widget.text1 == "Discard"
                              ? Colors.red
                              : Colors.black
                          : Colors.white,
                      fontSize: widget.font == 0 ? height * 0.033 : widget.font,
                      fontWeight: widget.weight),
                ),
              ]),
            ),
          ),
        ));
  }
}
