import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pushgame/push_button.dart';
import 'package:pushgame/rows.dart';

enum StartButtonState { ready, init, playing }
List<Row> gameRows = [];

class PushGame extends StatefulWidget {
  final bool hasVibration;
  const PushGame({
    required this.hasVibration,
    super.key,
  });

  @override
  State<PushGame> createState() => _PushGameState();
}

class _PushGameState extends State<PushGame> {
  int totalYes = 0;
  int totalError = 0;
  int pressedYes = 0;
  int pressedError = 0;

  final mainKey = GlobalKey();


  @override
  void initState() {
    gameRows = rows;
    super.initState();
  }

  void clickStartStopButton() {
    RenderBox renderbox =
        mainKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderbox.localToGlobal(Offset.zero);
    double x = position.dx;
    double y = position.dy;

    print(x);
    print(y);

    GestureBinding.instance.handlePointerEvent(PointerDownEvent(
      position: Offset(x, y),
    )); //trigger button up,

    GestureBinding.instance.handlePointerEvent(PointerUpEvent(
      position: Offset(x, y),
    ));
  }

  void updateGame(bool hiddenYes) {
    hiddenYes == true ? pressedYes += 1 : pressedError += 1;
    if (pressedYes == totalYes) {
      setState(() {
          gameRows = [];
          clickStartStopButton();
        _dialogBuilder(context, true);
      });
    } else if (pressedError == totalError) {
        gameRows = [];
        clickStartStopButton();
      _dialogBuilder(context, false);
    }
  }

  Future<void> _dialogBuilder(BuildContext context, bool won) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            won ? 'You won!' : 'You Lost',
            style:
                TextStyle(color: won ? Colors.green : Colors.redAccent),
          ),
          content: const Text(
            'You won in xxx time and score xxx points.',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Great', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  StartButtonState buttonState = StartButtonState.ready;

  void startGame(StartButtonState buttonState) {
    List<PushButton> firstRowButtons = [];
    List<PushButton> secondRowButtons = [];
    List<PushButton> thirdRowButtons = [];
    if (buttonState == StartButtonState.ready) {
        gameRows = [];
        setState(() {});
        gameRows = backupRows;
        setState(() {});
    } else {
      gameRows = [];
      totalYes = 0;
      totalError = 0;
      var random = Random();

      for (var i = 0; i <= 2; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        hidden == true ? totalYes += 1 : totalError += 1;
        firstRowButtons.add(PushButton(
            showHiddenYes: hidden,
            hiddenYes: hidden,
            active: false,
            callbackFunction: updateGame,
            reset: false));
      }
      for (var i = 0; i <= 3; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        hidden == true ? totalYes += 1 : totalError += 1;
        secondRowButtons.add(PushButton(
            showHiddenYes: hidden,
            hiddenYes: hidden,
            active: false,
            callbackFunction: updateGame,
            reset: false));
      }

      for (var i = 0; i <= 2; i++) {
        int binary = random.nextInt(2);
        bool hidden = binary <= 0 ? true : false;
        hidden == true ? totalYes += 1 : totalError += 1;
        thirdRowButtons.add(PushButton(
            showHiddenYes: hidden,
            hiddenYes: hidden,
            active: false,
            callbackFunction: updateGame,
            reset: false));
      }

      gameRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: firstRowButtons,
      ));
      gameRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: secondRowButtons,
      ));
      gameRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: thirdRowButtons,
      ));
      setState(() {});

      Timer(const Duration(seconds: 1), () {
        List<PushButton> firstNewRowButtons = [];
        List<PushButton> secondNewRowButtons = [];
        List<PushButton> thirdNewRowButtons = [];
        for (var first in firstRowButtons) {
          PushButton button = PushButton(
              showHiddenYes: false,
              hiddenYes: first.hiddenYes,
              active: first.active,
              callbackFunction: updateGame,
              reset: false);
          firstNewRowButtons.add(button);
        }
        for (var second in secondRowButtons) {
          PushButton button = PushButton(
              showHiddenYes: false,
              hiddenYes: second.hiddenYes,
              active: second.active,
              callbackFunction: updateGame,
              reset: false);
          secondNewRowButtons.add(button);
        }
        for (var third in thirdRowButtons) {
          PushButton button = PushButton(
              showHiddenYes: false,
              hiddenYes: third.hiddenYes,
              active: third.active,
              callbackFunction: updateGame,
              reset: false);
          thirdNewRowButtons.add(button);
        }
        gameRows = [];
        gameRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: firstNewRowButtons,
        ));
        gameRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: secondNewRowButtons,
        ));
        gameRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: thirdNewRowButtons,
        ));
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 660,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: gameRows),
            ),
          ],
        ),
        StartButton(
          startButtonState: StartButtonState.ready,
          callbackFunction: startGame,
          mainKey: mainKey,
        ),
      ],
    );
  }
}

class StartButton extends StatefulWidget {
  final StartButtonState startButtonState;
  final Function(StartButtonState) callbackFunction;
  final GlobalKey mainKey;
  const StartButton(
      {required this.startButtonState,
      required this.callbackFunction,
      required this.mainKey,
      super.key});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  String elapsedTime = '00:00:00';
  late Timer timer;
  Stopwatch watch = Stopwatch();
  bool startStop = true;
  StartButtonState buttonState = StartButtonState.ready;

  @override
  void initState() {
    buttonState = widget.startButtonState;
    super.initState();
  }

  startOrStop() {
    if (startStop) {
      startWatch();
      widget.callbackFunction(StartButtonState.playing);
    } else {
      stopWatch();
      widget.callbackFunction(StartButtonState.ready);
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
    if (buttonState == StartButtonState.init) {
      return ElevatedButton(
          key: widget.mainKey,
          onPressed: startOrStop,
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.orangeAccent),
          child: const Icon(
            Icons.pause_rounded,
            color: Colors.white,
          ));
    } else if (buttonState == StartButtonState.ready) {
      return ElevatedButton(
        key: widget.mainKey,
        onPressed: startOrStop,
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: Colors.greenAccent),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
        ),
      );
    } else if (buttonState == StartButtonState.playing) {
      return ElevatedButton(
        key: widget.mainKey,
        onPressed: startOrStop,
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: Colors.redAccent),
        child: const Icon(
          Icons.stop_rounded,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          elapsedTime,
          style: const TextStyle(color: Colors.white),
        ),
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
