# chat_app_signalr
A chat application using .NET SignalR technology developed with Flutter.

.NET Core SignalR is an open source library developed by Microsoft that provides real-time communication.

Tested on .NET 9.0 version

<table>
<tr>
    <td style="border: 1px solid black;"><img src="/exampleScreens/loginScreen.png" width="200"> </td>
    <td style="border: 1px solid black;"><img src="/exampleScreens/mainScreen.png" width="200"> </td>
    <td style="border: 1px solid black;"><img src="/exampleScreens/chatScreen.png" width="200"> </td>
</tr>
<tr>
    <td style="border: 1px solid black;"><img src="/exampleScreens/groupDialog.png" width="200"> </td>
    <td style="border: 1px solid black;"><img src="/exampleScreens/selectPersonDialog.png" width="200"> </td>
</tr>
</table>

# How Use

If you do not have a SignalR project that you have developed yourself, you can use the <a href="https://github.com/seromany/chat_app_server"> SignalR Server</a> project that I have developed.

## Example for my own SignalR project

1. Download the <a href="https://github.com/seromany/chat_app_server"> server project</a> and run it on your own computer.
2. If the server project is running on a different port, change the baseurl value in the api_controller.dart file.

```Dart
class ApiController {
  static String baseurl =
      "https://10.0.2.2:7073/"; //Local Server (This line local server port)
}
```

## Example for your own SignalR project

1. Change the server url value in the api_controller.dart file

```Dart
class ApiController {
  static String baseurl =
      "https://10.0.2.2:7073/"; //Local Server (This line local server port)
}
```
2. If you are going to use user login, edit the login, register, loginStatus, getUser methods in the user_controller.dart file according to your own login operations.
3. Edit the request and listen methods in the hub_controller.dart file according to your own socket operations.

## For Firebase notifications

1. Create a firebase project via <a href="https://console.firebase.google.com/"> Firebase console. </a> 
2. Follow the necessary steps.

## Required flutter dependencies

```Dart
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  dio: ^5.7.0
  shared_preferences: ^2.3.5
  signalr_netcore: ^1.4.0
  sqflite: ^2.4.1
  path_provider: ^2.1.5
  intl:
  firebase_core: ^3.10.0
  firebase_messaging: ^15.2.0
```