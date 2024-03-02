import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/screens/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/screens/profile_page.dart';
import 'package:todo_app/screens/todo_form.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("todo_item");
  await Hive.openBox("user_profile");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _showFab = true;
  late PageController _pageController;
  int current = 0;

  @override
  void initState(){
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    const duration = Duration(milliseconds: 300);
    
    return 
    MaterialApp(
      home: Scaffold(  
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
        floatingActionButton: AnimatedSlide(
          duration: duration,
          offset: Offset.zero,// ? Offset.zero : Offset(0, 2),
          child: AnimatedOpacity(
            duration: duration,
            opacity: 1, //_showFab ? 1 : 0,
            child:  Container( //Buttom Navbar
              height: 77,
              width: (media.size.width < 500) ? media.size.width/1.2 : 500,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan dan opasitasnya
                    spreadRadius: 5, // Radius penyebaran bayangan
                    blurRadius: 7, // Radius blur bayangan
                    offset: Offset(0, 3), // Geser bayangan (horizontal, vertical)
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageController.jumpToPage(0);
                          // _showFab = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded,
                            size: 32,
                            color: (current == 0)?Color(0xff5038BC): Color.fromRGBO(80, 56, 188, 0.39),
                          ),
                          Text("Home",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: (current == 0)?Color(0xff5038BC): Color.fromRGBO(80, 56, 188, 0.39),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageController.jumpToPage(1);
                          // _showFab = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,
                            size: 32,
                            color: (current == 1)?Color(0xff5038BC): Color.fromRGBO(80, 56, 188, 0.39),
                          ),
                          Text("Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: (current == 1)?Color(0xff5038BC): Color.fromRGBO(80, 56, 188, 0.39),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            )
          ),
        ),
        body: // NotificationListener<UserScrollNotification>(
          // onNotification: (notification) {
          //   final ScrollDirection direction = notification.direction;
            
          //   setState(() {
          //     if (direction == ScrollDirection.reverse) {
          //       // _showFab = false;
          //     } else if (direction == ScrollDirection.forward) {
          //       // _showFab = true;
          //     }
          //   });
          //   return true;
          // },
          PageView(
            controller: _pageController,
            onPageChanged: (index){
              setState(() {
                current = index;
              });
            },
            children: [
              HomePage(),
              ProfilePage(),
            ],
          ),
        )
      );
    // );
  }
}
