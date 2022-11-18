import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/usuario.dart';


class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosService = UsuariosService();

  List<Usuario> usuarios = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: true);

    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle( color: Colors.black54) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black54 ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.getToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStauts == ServerStauts.Online
            ? Icon( Icons.check_circle, color: Colors.blue)
            : Icon( Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue
        ),
        child: _ListViewUsuario(usuarios: usuarios),
      )
    );
  }

    _cargarUsuarios() async {
      
      
      this.usuarios = await usuariosService.getUsarios();
      setState(() { });
    _refreshController.refreshCompleted();
    }
}

class _ListViewUsuario extends StatelessWidget {
  const _ListViewUsuario({
    Key? key,
    required this.usuarios,
  }) : super(key: key);

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_,i) => _UsuarioListTile(usuario: usuarios[i]),
      separatorBuilder: (_,i) => const Divider(),
      itemCount: usuarios.length);
  }
}

class _UsuarioListTile extends StatelessWidget {
  const _UsuarioListTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text( usuario.nombre ),
      subtitle: Text( usuario.email ),
      leading: CircleAvatar(
        child: Text( usuario.nombre.substring(0,2) ),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context,listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}