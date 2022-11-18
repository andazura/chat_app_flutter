import 'package:chat_app/models/mensajes_rest.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';

class ChatService extends ChangeNotifier{

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioId ) async {

    final token = await AuthService.getToken();
    if( token == null ) return [];
    final url = Uri.http('${ Environment.apiUrl }', '/api/mensajes/$usuarioId');

    final res = await http.get(url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    final mensajes = mensajesResponseFromJson(res.body);

    return mensajes.mensajes;

  }
}