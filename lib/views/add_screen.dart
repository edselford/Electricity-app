import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/models/statusbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  final Function callback;
  final bool isEdit;
  final int? index;
  const AddPage({
    Key? key,
    required this.callback,
    this.isEdit = false,
    this.index,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  DateTime _currentDate = DateTime.now();
  TextEditingController firstSize = TextEditingController();
  TextEditingController lastSize = TextEditingController();
  TextEditingController size = TextEditingController();
  HiveManager hiveManager = HiveManager();
  final String instruction =
      'Please fill all the fields and make sure the total size is correct and the first size is smaller than the last size. if you don\'t know the size, please fill the first size to 0, or at least fill the first size smaller than last size. tap the total size to calculate the total size. if you want to clear all the fields, tap the "Add Data" button and click "Clear All".';

  @override
  initState() {
    if (widget.isEdit || widget.index != null) {
      var data = hiveManager.getAllData()[widget.index];
      firstSize.text = data['firstSize'].toString();
      lastSize.text = data['lastSize'].toString();
      size.text = data['size'].toString();
      _currentDate = data['time'];
    }
    super.initState();
  }

  bool _autoCalculate = false;

  void calculateTotal() {
    if (_autoCalculate) {
      try {
        if (double.parse(lastSize.text) > double.parse(firstSize.text)) {
          size.text = NumberFormat('#.##').format(
              double.parse(lastSize.text) - double.parse(firstSize.text));
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    refreshStatusBar();
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        middle: GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: const Text('Menu'),
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text('Clear All',
                          style: Theme.of(context).textTheme.headline5),
                      onPressed: () {
                        firstSize.text = '';
                        lastSize.text = '';
                        size.text = '';
                        setState(() {
                          _currentDate = DateTime.now();
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text('Cancel',
                        style: Theme.of(context).textTheme.headline5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          },
          child: Text(
            'Add Data',
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontFamily: "Product",
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        leading: CupertinoButton(
          child: Row(
            children: [
              const Icon(CupertinoIcons.back),
              Text('Back', style: Theme.of(context).textTheme.headline5)
            ],
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            // pop with animation
            Navigator.of(context).pop();
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Done', style: Theme.of(context).textTheme.headline5),
          onPressed: () {
            bool verified = true;
            int errorCode = 0;
            try {
              if (size.text == '' ||
                  firstSize.text == '' ||
                  lastSize.text == '' ||
                  double.parse(size.text) == 0.0 ||
                  double.parse(firstSize.text) == 0.0 ||
                  double.parse(lastSize.text) == 0.0 ||
                  double.parse(firstSize.text) > double.parse(lastSize.text)) {
                verified = false;
              } else if (widget.isEdit || widget.index != null) {
                var data = hiveManager.getAllData()[widget.index];
                if (double.parse(size.text) == data['size'] &&
                    double.parse(firstSize.text) == data['firstSize'] &&
                    double.parse(lastSize.text) == data['lastSize'] &&
                    _currentDate.isAtSameMomentAs(data['time'])) {
                  verified = false;
                  errorCode = 1;
                }
              }
            } catch (e) {
              verified = false;
            }

            if ((widget.isEdit || widget.index != null) && verified) {
              hiveManager.deleteData(widget.index!);
            }

            if (verified) {
              hiveManager.addData({
                'time': _currentDate,
                'size': double.parse(size.text),
                'firstSize': double.parse(firstSize.text),
                'lastSize': double.parse(lastSize.text),
              });
              widget.callback();
              Navigator.of(context).pop();
            } else {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text(
                      'Error',
                      style: TextStyle(
                          fontFamily: 'Product', fontWeight: FontWeight.w300),
                    ),
                    content: Text(
                      (errorCode == 1)
                          ? 'You don\'t change anything'
                          : 'Please read the instructions below',
                      style: const TextStyle(
                          fontFamily: "Product", fontWeight: FontWeight.w300),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('OK',
                            style: Theme.of(context).textTheme.headline5),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('Instructions',
                            style: Theme.of(context).textTheme.headline5),
                        onPressed: () {
                          Navigator.of(context).pop();
                          showIntruction();
                        },
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      child: ListView(
        children: [
          Container(
            height: 40,
            color: Theme.of(context).backgroundColor,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date', style: Theme.of(context).textTheme.headline4),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: pickDateCalendar,
                      child: Text(
                        DateFormat('EEEE - dd MMM yyyy').format(_currentDate),
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'SF UI',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time', style: Theme.of(context).textTheme.headline4),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? const Color(0xff3D3C41)
                          : Theme.of(context).backgroundColor,
                      child: Text(
                        DateFormat('HH:mm').format(_currentDate),
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'SF UI',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      onPressed: pickTimeCalendar,
                    ),
                  ],
                ),
                sizeInput(title: 'First Size', controller: firstSize),
                sizeInput(title: 'Last Size', controller: lastSize),
                sizeInput(title: 'Total Size', controller: size, isTotal: true),
                sizeInput(
                  title: 'Automatic Calculate',
                  controller: TextEditingController(),
                  useCustomTrailing: true,
                  trailing: CupertinoSwitch(
                    value: _autoCalculate,
                    onChanged: (value) {
                      setState(
                        () {
                          _autoCalculate = value;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              'Note:\n' + instruction,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemGrey3,
                    fontSize: 15,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void showIntruction() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Instructions'),
          message: Text(
            instruction,
            textAlign: TextAlign.start,
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text('OK', style: Theme.of(context).textTheme.headline5),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget sizeInput({
    required String title,
    required TextEditingController controller,
    bool isTotal = false,
    bool useCustomTrailing = false,
    Widget? trailing,
  }) {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (isTotal)
                ? GestureDetector(
                    child: Text(title,
                        style: Theme.of(context).textTheme.headline4),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: const Text('Menu'),
                          actions: [
                            CupertinoActionSheetAction(
                              child: const Text('Calculate'),
                              onPressed: () {
                                try {
                                  if (double.parse(lastSize.text) >
                                      double.parse(firstSize.text)) {
                                    controller.text = NumberFormat('#.##')
                                        .format(double.parse(lastSize.text) -
                                            double.parse(firstSize.text));
                                  }
                                  // ignore: empty_catches
                                } catch (e) {}
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Text(title, style: Theme.of(context).textTheme.headline4),
            (useCustomTrailing)
                ? trailing!
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 75,
                        height: 40,
                        child: CupertinoTextField.borderless(
                          onChanged: (value) {
                            calculateTotal();
                          },
                          controller: controller,
                          maxLength: 5,
                          placeholder: 0.0.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'SF UI',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text(
                        'KWH',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SF UI',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).secondaryHeaderColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }

  void pickTimeCalendar() {
    DateTime tempTime = _currentDate;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 200,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Theme.of(context).brightness,
            ),
            child: CupertinoDatePicker(
              onDateTimeChanged: (DateTime value) {
                tempTime = value;
              },
              initialDateTime: _currentDate,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () {
              setState(() {
                _currentDate = tempTime;
              });
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void pickDateCalendar() {
    DateTime tempDate = _currentDate;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 300,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.single,
              showNavigationArrow: true,
              headerStyle: DateRangePickerHeaderStyle(
                textStyle: Theme.of(context).textTheme.headline2,
              ),
              rangeTextStyle: TextStyle(
                fontFamily: 'SF UI',
                color: Theme.of(context).secondaryHeaderColor,
              ),
              // add start & end date
              initialSelectedDate: _currentDate,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                tempDate = args.value;
              },
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Ok"),
              onPressed: () {
                setState(() {
                  _currentDate = DateTime.parse(
                    DateFormat('yyyy-MM-dd').format(tempDate) +
                        ' ' +
                        DateFormat('HH:mm:ss').format(_currentDate),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
