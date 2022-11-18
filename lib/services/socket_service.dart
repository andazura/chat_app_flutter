

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStauts{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStauts _serverStauts = ServerStauts.Connecting;
  late IO.Socket _socket;
  ServerStauts get serverStauts => this._serverStauts;
  IO.Socket get socket => this._socket;



  void connect() async {

    final token = await AuthService.getToken();


    print("intentadno conectar");
    _socket = IO.io(Environment.socketUrl,{
      'transports':['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token':token
      }
    });

    _socket.onConnect((_) {
      _serverStauts = ServerStauts.Online;
      notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      _serverStauts = ServerStauts.Offline;
      notifyListeners();
    });
  }

  void disconnect(){
    this._socket.disconnect();
  }

  void emit(String evento, Map payload){
    _socket.emit(evento,payload);
  }
}