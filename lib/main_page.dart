import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaipoing_test/checkBoxes/check_green.dart';
import 'package:vaipoing_test/checkBoxes/check_red.dart';
import 'package:vaipoing_test/checkBoxes/check_yellow.dart';

/// Главная страница приложения, вызывается из [main]
///

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  ///Стримы для контроллеров значений чекбоксов
  ///Красный
  final StreamController<bool> _controllerRed =
      StreamController<bool>.broadcast();

  Stream<bool> get _checkBoxRedStream => _controllerRed.stream;

  ///Желтый
  final StreamController<bool> _controllerYellow =
      StreamController<bool>.broadcast();

  Stream<bool> get _checkBoxYellowStream => _controllerYellow.stream;

  ///Зеленый
  final StreamController<bool> _controllerGreen =
      StreamController<bool>.broadcast();

  Stream<bool> get _checkBoxGreenStream => _controllerGreen.stream;

  ///Длительность
  final StreamController<Duration> _controllerDuration =
      StreamController<Duration>.broadcast();

  Stream<Duration> get _durationStream => _controllerDuration.stream;

  ///Список чекбоксов для отображения
  var listCheck = <Widget>[];

  ///Флаги для инициализации новых чекбоксов по текущему значению
  bool redFlag = false;
  bool greenFlag = true;
  bool yellowFlag = false;

  /// Переменная длительности
  Duration duration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    /// Высота экрана
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            reverse: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: height - kToolbarHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 96.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 7,
                          children: [
                            for (var i = 0; i < listCheck.length; i++) ...[
                              listCheck[i],
                            ],
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text('AnimationDuration'),
                        ),
                        Slider(
                          value: duration.inMilliseconds.toDouble(),
                          min: 200,
                          max: 5000,
                          activeColor: Colors.green.withOpacity(0.8),
                          inactiveColor: Colors.green.withOpacity(0.3),
                          thumbColor: Colors.green,
                          onChanged: (double value) {
                            setState(() {
                              duration = Duration(
                                milliseconds: value.toInt(),
                              );
                              _controllerDuration.add(
                                Duration(
                                  milliseconds: value.toInt(),
                                ),
                              );
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text('${duration.inMilliseconds} ms'),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          /// Список из возможных вариаций чекбоксов
                          var list = [
                            StreamBuilder(
                              stream: _durationStream,
                              initialData: duration,
                              builder: (BuildContext context,
                                  AsyncSnapshot<Duration> snapshotDuration) {
                                return StreamBuilder(
                                  stream: _checkBoxGreenStream,
                                  initialData: greenFlag,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return CheckboxGreen(
                                      value: snapshot.data,
                                      duration: snapshotDuration.data,
                                      onTap: (changedValue) {
                                        if (redFlag || yellowFlag) {
                                          redFlag = false;
                                          yellowFlag = false;
                                          _controllerYellow.add(false);
                                          _controllerRed.add(false);
                                        }
                                        _controllerGreen.add(changedValue);
                                        greenFlag = changedValue;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            StreamBuilder(
                              stream: _durationStream,
                              initialData: duration,
                              builder: (BuildContext context,
                                  AsyncSnapshot<Duration> snapshotDuration) {
                                return StreamBuilder(
                                  stream: _checkBoxRedStream,
                                  initialData: redFlag,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return CheckboxRed(
                                      value: snapshot.data,
                                      duration: snapshotDuration.data,
                                      onTap: (changedValue) {
                                        if (greenFlag || yellowFlag) {
                                          greenFlag = false;
                                          yellowFlag = false;
                                          _controllerYellow.add(false);
                                          _controllerGreen.add(false);
                                        }
                                        _controllerRed.add(changedValue);
                                        redFlag = changedValue;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            StreamBuilder(
                              stream: _durationStream,
                              initialData: duration,
                              builder: (BuildContext context,
                                  AsyncSnapshot<Duration> snapshotDuration) {
                                return StreamBuilder(
                                  stream: _checkBoxYellowStream,
                                  initialData: yellowFlag,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return CheckboxYellow(
                                      value: snapshot.data,
                                      duration: snapshotDuration.data,
                                      onTap: (changedValue) {
                                        if (greenFlag || redFlag) {
                                          greenFlag = false;
                                          redFlag = false;
                                          _controllerGreen.add(false);
                                          _controllerRed.add(false);
                                        }
                                        _controllerYellow.add(changedValue);
                                        yellowFlag = changedValue;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ];
                          var newNewList = [];

                          /// Рандомизирование списка добавляемых элементов
                          for (int i = 0; i < 10; i++) {
                            list.shuffle();
                            newNewList.add(list[0]);
                          }

                          /// Добавление элементов в исходный список
                          setState(() {
                            for (var i = 0; i < 10; i++) {
                              listCheck.add(newNewList[i]);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12,
                            ),
                            child: Text(
                              'AddCheckboxes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listCheck.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12,
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Закрытие потоков
  @override
  void dispose() {
    _controllerRed.close();
    _controllerYellow.close();
    _controllerGreen.close();
    _controllerDuration.close();
    super.dispose();
  }
}
