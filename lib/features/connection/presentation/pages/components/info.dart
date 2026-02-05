
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
            'Some phones still require a manual confirm in Wi‑Fi settings. '
                'The phone will not automatically connect to the MowerBot-AP network.\n'
                'After automatic scanning, the following error is shown:\n',
          ),
          TextSpan(
            text: '[Error] Host unreachable \n',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          TextSpan(
            text:
            'With final status\n',
          ),
          TextSpan(
            text: 'Disconnected \n',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          TextSpan(
            text:
            'In this case, follow these steps:\n'
                '1) Open Wi‑Fi settings and connect to the MowerBot-AP network\n'
                '2) Come back and tap “Connect WebSocket”\n'
                '3) The status in the upper part of the screen will show\n',
          ),
          TextSpan(
            text: 'Connected \n',
            style: TextStyle(
                color: Colors.green
            ),
          ),
        ],
      ),
    );
  }
}