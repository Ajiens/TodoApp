import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/screens/todo_form.dart';
import 'package:todo_app/widgets/todo_card.dart';


import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todoItem = Hive.box("todo_item");
  final _profileData = Hive.box("user_profile");

  List<Map<String, dynamic>> _itemList = [];

  @override
  void initState(){
    _itemList = readItem(_todoItem);
    super.initState();
  }

  List<Map<String, dynamic>> readItem(Box<dynamic> box){
    return box.keys.map((key){
      dynamic item = box.get(key);
      return {"key": key, 
        "start_date": item["start_date"],
        "end_date": item["end_date"],
        "category": item["category"],
        "title": item["title"],
        "description" : item["description"],
        "is_done" : item["is_done"],
      };
    }).toList();
  }

  void _refereshItem(){
    setState(() {
      _itemList = readItem(_todoItem);
    });
  }
  
  void _deleteItem(int itemKey) async{
    await _todoItem.delete(itemKey);
    _refereshItem();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("${DateFormat('EEEE, MMM d yyyy').format(DateTime.now())}",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                  ),
                ),
              ),
              SizedBox(height: 25,),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("Welcome, ${_profileData.get("profile_user")["nama"]}!",
                  textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("Have a nice day!",
                  textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Task",
                      textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                      ),
                    ),
                    GestureDetector(
                      onTap:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TodoForm()),
                        );
                      },
                      child: Container(
                        width: 88,
                        height: 27,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xff5038BC),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child:Text("Add Task",
                          textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _itemList.length,
                itemBuilder: (context, index){
            
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => 
                          TodoForm( keyItem: _itemList[index]["key"],
                                    start: _itemList[index]["start_date"], 
                                    end: _itemList[index]["end_date"],
                                    title: _itemList[index]["title"],
                                    isPriority: _itemList[index]["category"] ,
                                    description: _itemList[index]["description"],
                                    isDone: _itemList[index]["is_done"],
                                    isUpdating: true,
                                    )
                                  )
                                );
                    },
                    child: TodoCard(todoItem: _itemList[index], action: (BuildContext) {_deleteItem(_itemList[index]["key"]);},)
                  );
                }
              ),
            ]
          ),
        ),
      ),
    );
  }
}