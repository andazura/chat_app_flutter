import 'package:chat_app/helpers/alertas.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
   
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: "Messenger"),
                _Form(),
                const Labels( route: 'register', label: "¿No tienes cuenta?", label2: "Crea una ahora!" ),
                const Text("Terminso y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => _FormStateState();
}

class _FormStateState extends State<_Form> {
  final emailCtrl = TextEditingController();

  final passwCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: true);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            textInputType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",
            textInputType: TextInputType.text,
            textController: passwCtrl,
            isPassword: true,
          ),
          
          //todo crear boton
          BotonAzul(
            onPress: authService.autenticando
            ? null
            : boton,
            textButton: "Ingresar"
          )
        ],
      ),
    );
  }

  void boton() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    FocusScope.of(context).unfocus();
    final loginOk = await authService.login(emailCtrl.text.trim(), passwCtrl.text.trim());
    if( loginOk ){
      Navigator.pushReplacementNamed(context, 'usuarios');
    }else{
      mosrtarAlerta(context, "Credenciales invalidas", "Intenta de nuevo");
    }
  }
}
