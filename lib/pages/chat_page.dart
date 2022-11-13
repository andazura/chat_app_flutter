import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
   
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List <ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("An", style: TextStyle( fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text("Melissa flores", style: TextStyle( color: Colors.black87, fontSize: 12),)
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
        uid: "123",
        animationController: 
          AnimationController(vsync: this, duration: Duration(milliseconds: 200)));
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
      

      setState(() {
        _isWriting = false;
      });
    }

  @override
  void dispose() {
    // TODO: off del socket
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    } 
    super.dispose();
  }
}