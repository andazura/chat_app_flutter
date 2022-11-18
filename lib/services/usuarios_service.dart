

import 'dart:convert';

import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/environment.dart';

class UsuariosService {

  Future<List<Usuario>> getUsarios() async{

    try {

      final token = await AuthService.getToken();
      if( token == null ) return [];

      final uri = Uri.http('${Environment.apiUrl}','/api/usuarios');

      final resp = await http.get
      (
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
      );

      final usuariosResponse = usuariosFromJson( resp.body );
      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }
  }


}