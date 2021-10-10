import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vicara_test/notification.dart';
import 'package:vicara_test/sign_in.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'sensor_value_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize('resource://drawable/success', [
    NotificationChannel(
      channelKey: 'basic_notification',
      channelName: 'Basic Notification',
      channelShowBadge: true,
      importance: NotificationImportance.High,
    ),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.blueAccent,
            secondary: Colors.blueAccent,
            brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.dark,
      home: const SignIn(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User user;

  const MyHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic accelerometerX;
  dynamic accelerometerY;
  dynamic accelerometerZ;

  final _channel = WebSocketChannel.connect(
    Uri.parse(
        'wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self'),
  );

  dynamic gyroscopeX;
  dynamic gyroscopeY;
  dynamic gyroscopeZ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accelerometerValues();
    gyroscopicValues();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('App would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Don\'t Allow'),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: const Text('Allow'),
              ),
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _channel.sink.close();

    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
  }

  accelerometerValues() {
    Timer.periodic(const Duration(milliseconds: 25), (timer) {
      setState(() {
        accelerometerEvents.listen((event) {
          accelerometerX = event.x;
          accelerometerY = event.y;
          accelerometerZ = event.z;
        });
      });
    });
  }

  gyroscopicValues() {
    Timer.periodic(const Duration(milliseconds: 25), (timer) {
      setState(() {
        gyroscopeEvents.listen((GyroscopeEvent event) {
          gyroscopeX = event.x;
          gyroscopeY = event.y;
          gyroscopeZ = event.z;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Vicara Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueCard(
                xValue: accelerometerX,
                yValue: accelerometerY,
                zValue: accelerometerZ),
            const SizedBox(
              height: 20,
            ),
            ValueCard(
                xValue: gyroscopeX, yValue: gyroscopeY, zValue: gyroscopeZ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(
                      snapshot.hasData ? "Connected to WebSocket Test" : " ");
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        onPressed: () {
          buttonNotification();
          _channel.sink.add(accelerometerX.toString());
          _channel.sink.add(accelerometerY.toString());
          _channel.sink.add(accelerometerZ.toString());
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
