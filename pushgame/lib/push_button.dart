import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class PushButton extends StatefulWidget {
   bool showHiddenYes;
   bool hiddenYes;
   bool active;
    PushButton({
    required this.showHiddenYes,
    required this.hiddenYes,
    required this.active,
    super.key,
  });

  @override
  State<PushButton> createState() => _PushButtonState();
}

class _PushButtonState extends State<PushButton> {

  Color thisButtonColor = const Color.fromARGB(100, 217, 217, 217);

  @override
  Widget build(BuildContext context) {
    return widget.showHiddenYes ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
       height: 80,
       width: 80,
           decoration: const BoxDecoration(
             shape: BoxShape.circle,
             color: Color.fromARGB(200, 95, 196, 239)
           ),
    ) 
    ) : GestureDetector(
      onTap: () async {
        setState(() {
          if(widget.hiddenYes){
            thisButtonColor = const Color.fromARGB(200, 95, 196, 239);
          } else {
            thisButtonColor = Colors.orangeAccent;
            Vibration.vibrate(duration: 500, amplitude: 255);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
         height: 80,
         width: 80,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: thisButtonColor,
               border: Border.all(color: Colors.black, style: BorderStyle.solid),
              boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
             ),
      )),
    );
  }
}
