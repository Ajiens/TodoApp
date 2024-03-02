import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/home_page.dart';

class TodoForm extends StatefulWidget {
  int? keyItem;
  String? start;
  String? end;
  String? title;
  bool? isPriority;
  String? description;
  bool? isDone;

  bool? isUpdating;

  TodoForm({this.keyItem, this.start, this.end, this.title, this.isPriority, this.description, this.isDone, this.isUpdating});
 

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _todoItem = Hive.box("todo_item");

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late bool _isPriority = true;
  late bool _isDone = false;
  late bool _isUpdating = false;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _startDateController = TextEditingController(text: widget.start != null ? widget.start:'',);
    _endDateController = TextEditingController(text: widget.end != null ? widget.end : '',);
    _isPriority = widget.isPriority??true;
    _isDone = widget.isDone??false;
    _isUpdating = widget.isUpdating ?? false;
    print(_isUpdating);
    super.initState();
  }

  void _getAllValue(BuildContext context){
    print(_isPriority);
    if (_startDateController.text.length == 0 ||
        _endDateController.text.length == 0 ||
        _titleController.text.length == 0
    ){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Field tidak boleh kosong.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
    else{
      Map<String, dynamic> allValue = {
        "start_date": _startDateController.text,
        "end_date":_endDateController.text,
        "category":_isPriority,
        "title":_titleController.text,
        "description" : _descriptionController.text,
        "is_done" : _isDone,
      };

      if (!_isUpdating){
        _createItem(allValue);
      }
      else{
        _updateItem(allValue);
      }
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
    }
  }

  Future<void> _createItem(Map<String, dynamic> value) async {
    await _todoItem.add(value);
  }

  Future<void> _updateItem(Map<String, dynamic> value) async {
      print("inisiapa ? ${widget.keyItem}");
    if (widget.keyItem != null){
      await _todoItem.put(widget.keyItem as int, value);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff5038BC),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xff5038BC),
        title: Text(_isUpdating?"Edit Task":"Add Task",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16
          ),
        )
      ),
      body: Column(
        children: [
          SizedBox(height:10),
          Container(
            height: MediaQuery.of(context).size.height-90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView(
                children: [
                  _titleLabel(context),
                  SizedBox(height:20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _dateField(context, true),
                      _dateField(context, false)
                    ]
                  ),
                  _titleField(context, ""),
                  _categoryField(context),
                  _descriptionField(context, ""),
                  _checkBox(context),
                  _buttonSubmit(context),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  Container _titleLabel(BuildContext context){
    return Container(

      child: !_isUpdating
      ?null
      :Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child :Center(
          child: Text(_titleController.text, 
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 32,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
      ),
    );
  }

  Padding _dateField(BuildContext context, bool startOrEnd){
    //Start for true ;; End for false
    return Padding(
      padding: startOrEnd?EdgeInsets.only(left: 25):EdgeInsets.only(right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(startOrEnd?"Start":"Ends", 
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width/2 - 35,
            height: 48,
            child: TextField(
              readOnly: true,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
              textAlignVertical: TextAlignVertical.center,
              controller: startOrEnd?_startDateController:_endDateController,
              decoration: InputDecoration(
                prefixIcon: const Padding(padding: EdgeInsets.only(left:10, right: 10), child: Icon(Icons.date_range_rounded, color: Color(0xff5038bc),)),
                focusColor: Color(0xff5038bc),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )               
              ),
              onTap: () async{
                DateTime? pickeddate = await showDatePicker(
                    context: context, 
                    firstDate: DateTime(2000), 
                    lastDate: DateTime(2050)
                  );
                
                if (pickeddate != null){
                  setState(() {
                    if (startOrEnd){
                      _startDateController.text = DateFormat('MMM-dd-yyyy').format(pickeddate);
                    }
                    else{
                      _endDateController.text = DateFormat('MMM-dd-yyyy').format(pickeddate);
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Padding _titleField(BuildContext context, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Title",
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),

          TextField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              focusColor: Color(0xff5038bc),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )               
            ),
          )
        ],
      ),
    );
  }

  Padding _categoryField(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Category",
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPriority = !_isPriority;
                      print(_isPriority);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isPriority?Color(0xff5038BC):Colors.white,
                      border: Border.all(color: Color.fromARGB(255, 134, 139, 139)),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Priority Task",
                      style: TextStyle(
                        color:_isPriority?Colors.white:Color(0xff5038bc),
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPriority = !_isPriority;
                      print(_isPriority);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    decoration: BoxDecoration(
                      color: !_isPriority?Color(0xff5038BC):Colors.white,
                      border: Border.all(color: Color.fromARGB(255, 134, 139, 139)),
                      borderRadius: BorderRadius.circular(10)  
                    ),
                    child: Text("Daily Task",
                      style: TextStyle(
                        color:!_isPriority?Colors.white:Color(0xff5038bc),
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

    Padding _descriptionField(BuildContext context, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Description",
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),

          TextField(
            controller: _descriptionController,
            maxLines: null,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              focusColor: Color(0xff5038bc),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )               
            ),
          )
        ],
      ),
    );
  }

  InkWell _checkBox(BuildContext context){
    return InkWell(
      onTap: () {
        setState(() {
          _isDone = !_isDone;
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15,0,25,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: _isDone,
              onChanged: (bool? value) {
                setState(() {
                  _isDone = value!;
                });
              },
            ),
            Text("Mark this task is done.",
              style: TextStyle(
                color: Color(0xff5038bc),
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buttonSubmit(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(25,0,25,25),
      child: InkWell(
        onTap: () {
          _getAllValue(context);
        },
        child: Container(
          alignment: Alignment.center,
          // width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xff5038BC),
            border: Border.all(color: Color.fromARGB(255, 134, 139, 139)),
            borderRadius: BorderRadius.circular(10)  
          ),
          child: Text(!_isUpdating?"Create a Task":"Update task",
            style: const TextStyle(
              color:Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}