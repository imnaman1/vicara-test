import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget {
  const ValueCard({
    Key? key,
    required this.xValue,
    required this.yValue,
    required this.zValue,
  }) : super(key: key);

  final xValue;
  final yValue;
  final zValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('The Accelerometer values are:'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    child: Text('$xValue'),
                  ),
                  CircleAvatar(
                    child: Text('$yValue'),
                  ),
                  CircleAvatar(
                    child: Text('$zValue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
