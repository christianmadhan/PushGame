import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pushgame/push_button.dart';


enum StartButtonState { ready, init, playing }

class PushGame extends StatefulWidget {
   PushGame({
    super.key,
  });

  @override
  State<PushGame> createState() => _PushGameState();
}

class _PushGameState extends State<PushGame> {

  @override
  void initState() {
    super.initState();
  }

  StartButtonState buttonState = StartButtonState.ready;

  List<Row> rows = [
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
               PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
                                  PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
            ],),
                            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
                              
                              children: [

               PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
                                  PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
                                  PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
                                  PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
            ],),
                            Row(
              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
               PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),                   PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),                   PushButton(
                showHiddenYes: false,
                hiddenYes: false,
                active: false,
               ),
              
            ],)
  ];


   void startGame(){
      rows = [];
      var random = Random();
      List<PushButton> firstRowButtons = [];
      List<PushButton> secondRowButtons = [];
      List<PushButton> thirdRowButtons = [];
      for (var i = 0; i <= 2; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        firstRowButtons.add(PushButton(showHiddenYes: hidden, hiddenYes: hidden, active: false));
      }
      for (var i = 0; i <= 3; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        secondRowButtons.add(PushButton(showHiddenYes: hidden, hiddenYes: hidden, active: false));
      }

      for (var i = 0; i <= 2; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        thirdRowButtons.add(PushButton(showHiddenYes: hidden, hiddenYes: hidden, active: false));
      }

      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: firstRowButtons,));
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: secondRowButtons,));
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: thirdRowButtons,));
      setState(() {
        
      });
      print(rows);

      Timer(const Duration(seconds: 2), ()  {
        print("4 seconds passed");
        List<PushButton> firstNewRowButtons = [];
        List<PushButton> secondNewRowButtons = [];
        List<PushButton> thirdNewRowButtons = [];
        for (var first in firstRowButtons) {
            PushButton button = PushButton(showHiddenYes: false, hiddenYes: first.hiddenYes, active: first.active);
            firstNewRowButtons.add(button);
        }
        for (var second in secondRowButtons) {
            PushButton button = PushButton(showHiddenYes: false, hiddenYes: second.hiddenYes, active: second.active);
            secondNewRowButtons.add(button);
        }
        for (var third in thirdRowButtons) {
            PushButton button = PushButton(showHiddenYes: false, hiddenYes: third.hiddenYes, active: third.active);
            thirdNewRowButtons.add(button);
        }
        rows = [];
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: firstNewRowButtons,));
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: secondNewRowButtons,));
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: thirdNewRowButtons,));
        setState(() {          
        });
      });
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StartButton(startButtonState: StartButtonState.ready, callbackFunction: startGame,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rows
        ),
      ],
    );
  }
}

class StartButton extends StatefulWidget {
  final StartButtonState startButtonState;
  final Function() callbackFunction;
  StartButton({
    required this.startButtonState,
    required this.callbackFunction
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  String elapsedTime = '00:00:00';
  late Timer timer;
  Stopwatch watch = Stopwatch();
  bool startStop = true;
  StartButtonState buttonState =StartButtonState.ready;


  @override
  void initState() {
    buttonState = widget.startButtonState;
    super.initState();
  }


   startOrStop() {
    if(startStop) {
      startWatch();
      widget.callbackFunction();
    } else {
      stopWatch();
    }
  }

   updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      buttonState = StartButtonState.playing;
      timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      buttonState = StartButtonState.ready;
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  

  buildStartStopButton(StartButtonState buttonState, bool startStop) {
    if(buttonState == StartButtonState.init){
              return ElevatedButton(
          onPressed: startOrStop,
          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.orangeAccent),
          child: const Icon(Icons.pause_rounded, color: Colors.white,));
    } else if(buttonState == StartButtonState.ready){
      return ElevatedButton(
          onPressed: startOrStop,
          style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: Colors.greenAccent),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white,),
        );
    } else if(buttonState == StartButtonState.playing) {
      return ElevatedButton(
          onPressed: startOrStop,
          style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: Colors.redAccent),
          child: const Icon(Icons.stop_rounded, color: Colors.white,),
      );
    }

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(elapsedTime, style: const TextStyle(color: Colors.white),),
        buildStartStopButton(buttonState, startStop)
      ],
    );
  }
}


  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }