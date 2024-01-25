import 'package:sih_app/utils/socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  sendData(double longitude, double latitude, String userId, bool reached,
      double d, double t) {
    _socketClient.emit("location", {
      "longitude": longitude,
      "latitude": latitude,
      "userId": userId,
      "reached": reached,
      "dist": d,
      "time": t
    });
  }

  sendLoadingData(double per) {
    _socketClient.emit("loading", {"filled": per});
  }
}
