
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String display = '0';
  double? firstNumber;
  String? operator;
  bool resetDisplay = false;

  void inputNumber(String number) {
    setState(() {
      if (display == 'Error' || resetDisplay) {
        display = number;
        resetDisplay = false;
      } else if (display == '0') {
        display = number;
      } else {
        display += number;
      }
    });
  }

  void inputDecimal() {
    setState(() {
      if (display == 'Error' || resetDisplay) {
        display = '0.';
        resetDisplay = false;
      } else if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void chooseOperator(String selectedOperator) {
    setState(() {
      if (display == 'Error') return;

      if (firstNumber != null && operator != null &&
          !resetDisplay) {
        calculate();
      }

      firstNumber = double.tryParse(display);
      operator = selectedOperator;
      resetDisplay = true;
    });
  }

  void calculate() {
    if (firstNumber == null || operator == null) return;

    double secondNumber = double.tryParse(display) ?? 0;
    double result = 0;

    switch (operator) {
      case '+':
        result = firstNumber! + secondNumber;
        break;

      case '-':
        result = firstNumber! - secondNumber;
        break;

      case '×':
        result = firstNumber! * secondNumber;
        break;

      case '÷':
        if (secondNumber == 0) {
          display = 'Error';
          firstNumber = null;
          operator = null;
          resetDisplay = true;
          return;
        }
        result = firstNumber! / secondNumber;
        break;
    }

    display = formatNumber(result);
    firstNumber = null;
    operator = null;
    resetDisplay = true;
  }

  String formatNumber(double number) {
    if (!number.isFinite) return 'Error';

    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }

    return number
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  void clearAll() {
    setState(() {
      display = '0';
      firstNumber = null;
      operator = null;
      resetDisplay = false;
    });
  }

  void deleteNumber() {
    setState(() {
      if (display == 'Error' || resetDisplay) {
        display = '0';
        resetDisplay = false;
      } else if (display.length > 1) {
        display = display.substring(0, display.length - 1);
        if (display == '-') display = '0';
      } else {
        display = '0';
      }
    });
  }

  void toggleSign() {
    setState(() {
      if (display == '0' || display == 'Error') return;

      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  Widget buildButton(
    String text, {
    Color color = const Color(0xFF242424),
    Color textColor = Colors.white,
    int flex = 1,
    VoidCallback? onTap,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<Widget> buttons) {
    return Expanded(
      child: Row(children: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9500);
    const lightButton = Color(0xFF505050);

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: const Text(
          'MY CALCULATOR',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 68,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 5,
                child: Column(
                  children: [

                    buildRow([
                      buildButton('AC',
                        color: lightButton,
                        onTap: clearAll),
                      buildButton('DEL',
                        color: lightButton,
                        onTap: deleteNumber),
                      buildButton('±',
                        color: lightButton,
                        onTap: toggleSign),
                      buildButton('÷',
                        color: orange,
                        onTap: () => chooseOperator('÷')),
                    ]),

                    buildRow([
                      buildButton('7', onTap: () => inputNumber('7')),
                      buildButton('8', onTap: () => inputNumber('8')),
                      buildButton('9', onTap: () => inputNumber('9')),
                      buildButton('×',
                        color: orange,
                        onTap: () => chooseOperator('×')),
                    ]),

                    buildRow([
                      buildButton('4', onTap: () => inputNumber('4')),
                      buildButton('5', onTap: () => inputNumber('5')),
                      buildButton('6', onTap: () => inputNumber('6')),
                      buildButton('-',
                        color: orange,
                        onTap: () => chooseOperator('-')),
                    ]),

                    buildRow([
                      buildButton('1', onTap: () => inputNumber('1')),
                      buildButton('2', onTap: () => inputNumber('2')),
                      buildButton('3', onTap: () => inputNumber('3')),
                      buildButton('+',
                        color: orange,
                        onTap: () => chooseOperator('+')),
                    ]),

                    buildRow([
                      buildButton('0',
                        flex: 2,
                        onTap: () => inputNumber('0')),
                      buildButton('.',
                        onTap: inputDecimal),
                      buildButton('=',
                        color: orange,
                        onTap: () {
                          setState(() {
                            calculate();
                          });
                        }),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
