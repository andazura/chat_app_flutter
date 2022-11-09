import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/usuario.dart';


class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: 1,nombre: "andres",email: "anda@",online: true),
    Usuario(uid: 2,nombre: "juan",email: "anda2@",online: false),
    Usuario(uid: 3,nombre: "maria",email: "andaaaamaria@",online: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi nombre", style: TextStyle( color: Colors.black54) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black54 ),
          onPressed: () {
            
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon( Icons.check_circle, color: Colors.blue,),
            // child: Icon( Icons.offline_bolt, color: Colors.red,),
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

      await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
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
    );
  }
}