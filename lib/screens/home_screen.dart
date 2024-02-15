import 'package:examen_final_jaume/screens/login_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
@override
_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
//signout function 
logout() async {
	Navigator.pushReplacement(
		context, MaterialPageRoute(builder: (context) => LoginPage()));
}

@override
Widget build(BuildContext context) {
	return Scaffold(
	appBar: AppBar(
		centerTitle: true,
		backgroundColor: Colors.yellow,
		title: Text("Main Page"),
	),
	
	// Botó per fer logout
	floatingActionButton: FloatingActionButton(
		onPressed: () {
		logout();
		},
		child: Icon(Icons.logout_rounded),
		backgroundColor: Colors.yellow,
	),

	body: Center(
		child: Text("Home Screen"),
	),
	);
}
}
