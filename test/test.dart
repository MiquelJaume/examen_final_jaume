import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicació d'arbres',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables
  bool _loggedIn = false;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Arbre> _arbres = [];
  Arbre? _selectedArbre;

  // Mètodes
  void _login() async {
    // TODO: Implementar login amb FirebaseAuth (opcional)
    setState(() {
      _loggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      _loggedIn = false;
    });
  }

  void _loadArbres() {
    _database.ref('arbres').onValue.listen((event) {
      final List<Arbre> arbres = [];
      for (DataSnapshot snapshot in event.snapshot.children) {
        arbres.add(Arbre.fromJson(snapshot.value));
      }
      setState(() {
        _arbres = arbres;
      });
    });
  }

  void _addArbre(Arbre arbre) {
    _database.ref('arbres').push().set(arbre.toJson());
  }

  void _deleteArbre(Arbre arbre) {
    _database.ref('arbres/${arbre.id}').remove();
  }

  void _getGeolocation() async {
    final String ip = await _getPublicIp();
    final Location location = await Geolocator.getCurrentPosition();
    final LatLng latLng = LatLng(location.latitude, location.longitude);
    final CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 15);
    final Marker marker = Marker(
      markerId: MarkerId('marker'),
      position: latLng,
      infoWindow: InfoWindow(title: 'Organització: ${(await _getOrganization(ip)).name}'),
    );
    // TODO: Mostrar mapa amb Google Maps
  }

  Future<String> _getPublicIp() async {
    final Uri url = Uri.parse('https://api.ipify.org/?format=json');
    final Response response = await http.get(url);
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['ip'];
  }

  Future<Organization> _getOrganization(String ip) async {
    final Uri url = Uri.parse('https://ipinfo.io/$ip/geo');
    final Response response = await http.get(url);
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Organization(name: data['org']);
  }

  // Widgets
  Widget _buildLogin() {
    return Column(
      children: [
        TextField(
          controller: _userController,
          decoration: InputDecoration(labelText: 'Usuari'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Contrasenya'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: _login,
          child: Text('Iniciar sessió'),
        ),
      ],
    );
  }

  Widget _buildArbreList() {
    return ListView.builder(
      itemCount: _arbres.length,
      itemBuilder: (context, index) {
        final Arbre arbre = _arbres
