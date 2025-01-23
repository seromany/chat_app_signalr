import 'package:chat_app_signalr/Models/chat_screen_data.dart';
import 'package:chat_app_signalr/Screens/chat_screen.dart';
import 'package:chat_app_signalr/Screens/loading_screen.dart';
import 'package:chat_app_signalr/Screens/login_screen.dart';
import 'package:chat_app_signalr/Screens/main_screen.dart';
import 'package:chat_app_signalr/Screens/register_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loadingScreenRoute:
        return MaterialPageRoute(builder: (_) => LoadingScreen());
      case loginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case mainScreenRoute:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case registerScreenRoute:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case chatScreenRoute:
        final arguments = settings.arguments as ChatScreenData;
        return MaterialPageRoute(
            builder: (_) => ChatScreen(
                  screenData: arguments,
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Something went wrong'),
            ),
          ),
        );
    }
  }
}

const String loadingScreenRoute = '/';
const String loginScreenRoute = '/loginScreen';
const String mainScreenRoute = '/mainScreen';
const String chatScreenRoute = '/chatScreen';
const String registerScreenRoute = '/registerScreen';
