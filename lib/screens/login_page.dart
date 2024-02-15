import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:examen_final_jaume/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _savedUsername; // Guardarà el nom d'usuari guardat
  String? _savedPassword; // Guardarà la contrasenya guardada

  @override
  void initState() {
    super.initState();
    _getSavedCredentials(); // Obté les credencials guardades en iniciar la pàgina
  }

  void _getSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false; // Obté l'estat de "recorda'm" guardat
      if (_rememberMe) {
        // Si "recorda'm" està actiu, carrega les credencials guardades
        _savedUsername = prefs.getString('username') ?? ''; // Obté el nom d'usuari guardat
        _savedPassword = prefs.getString('password') ?? ''; // Obté la contrasenya guardada
        _usernameController.text = _savedUsername!; // Assigna el nom d'usuari guardat al controlador del TextField
        _passwordController.text = _savedPassword!; // Assigna la contrasenya guardada al controlador del TextField
      }
    });
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      // Si "recorda'm" està actiu, guarda les credencials ingressades i l'estat de "recorda'm"
      _savedUsername = username; // Guarda el nom d'usuari
      _savedPassword = password; // Guarda la contrasenya
      prefs.setString('username', username); // Guarda el nom d'usuari a SharedPreferences
      prefs.setString('password', password); // Guarda la contrasenya a SharedPreferences
      prefs.setBool('rememberMe', true); // Guarda l'estat de "recorda'm" a SharedPreferences
    } else {
      // Si "recorda'm" està desactivat, elimina les credencials guardades i establix l'estat de "recorda'm" a fals
      prefs.remove('username'); // Elimina el nom d'usuari guardat de SharedPreferences
      prefs.remove('password'); // Elimina la contrasenya guardada de SharedPreferences
      prefs.setBool('rememberMe', false); // Estableix l'estat de "recorda'm" a fals a SharedPreferences
    }
    // Navega a la pantalla HomeScreen després d'iniciar sessió
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                Text('Remember me'),
              ],
            ),
            // Botó per fer login
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
