import 'dart:io';
import 'package:chat_app/models/mensajes_rest.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
   
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List <ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    // TODO: implement initState
    this.chatService   = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService   = Provider.of<AuthService>(context, listen: false);


    this.socketService.socket.on('mensaje-personal', _escucharMensaje );

    _cargarMensaje( chatService.usuarioPara.uid);
  }

  void _cargarMensaje( String usuarioId ) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioId);
    
    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
        )..forward()
      )
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje( dynamic data){
    ChatMessage message = ChatMessage(
      texto: data['mensaje'],
      uid: data['de'],
      animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 200)));

      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
  }
  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0,2), style: TextStyle( fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text(usuarioPara.nombre, style: TextStyle( color: Colors.black87, fontSize: 12),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_,i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              )
            ),

            Divider( height: 1 ),
            //todo cjada de text
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _inputChat(){
      return SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: ( texto ) {
                      // cuando hay valor
                      setState(() {
                        
                        if( texto.trim().length > 0 ){ 
                           _isWriting = true; 
                        } else{
                          _isWriting = false; 
                        }
                      });
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: "Enivar mensaje"
                  ),
                  focusNode: _focusNode,
                )
              ),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                ? CupertinoButton(
                    child: Text("Enviar"),
                    onPressed: _isWriting
                      ? () => _handleSubmit( _textController.text.trim() )
                      : null,
                  )
                : Container(
                  margin: EdgeInsets.symmetric( horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData( color: Colors.blue[400] ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon( Icons.send ),
                      onPressed: _isWriting
                      ? () => _handleSubmit( _textController.text.trim() )
                      : null,
                    ),
                  ),
                ) 
              )
            ],
          ),
        ),
      );
    }

    _handleSubmit( String texto){
      
      if( texto.length == 0 ) return;
      
      _textController.clear();
      _focusNode.requestFocus();

      final newMessage = new ChatMessage(
        texto: texto,
        uid: authService.usuario.uid,
        animationController: 
          AnimationController(vsync: this, duration: Duration(milliseconds: 200)));
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
      

      setState(() {
        _isWriting = false;
      });

      this.socketService.emit('mensaje-personal',{
        'de': authService.usuario.uid,
        'para': chatService.usuarioPara.uid,
        'mensaje': texto
      });
    }

  @override
  void dispose() {
    // TODO: off del socket
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    } 
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}