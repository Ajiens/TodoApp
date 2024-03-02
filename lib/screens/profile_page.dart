import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileBox = Hive.box("user_profile");

  
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _birthController;
  late TextEditingController _emailController;

  @override
  void initState(){
    if (profileBox.length == 0){
      Map<String, String> dataProfile = {
        "nama": "username",
        "major": "",
        "birth": "",
        "email" : ""
      };
      profileBox.put("profile_user", dataProfile);      
    }
    Map<String, String> data = profileBox.get('profile_user');

    _nameController = TextEditingController(text: data["nama"]);
    _majorController = TextEditingController(text: data["major"]);
    _birthController = TextEditingController(text: data["birth"]);
    _emailController = TextEditingController(text: data["email"]);

    super.initState();
  }

  Future<void> _updateProfile() async {
    Map<String, String> allValue = {
      "nama": _nameController.text,
        "major": _majorController.text,
        "birth": _birthController.text,
        "email" : _emailController.text,
    };

    await profileBox.put("profile_user", allValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff5038BC),
      appBar: AppBar(
        backgroundColor: Color(0xff5038BC),
        title: Center(
          child: Text("My Profile",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16
            ),
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
                  _field(context, "Name", _nameController),
                  _field(context, "Major", _majorController),
                  _dateField(context),
                  _field(context, "Email", _emailController),
                  SizedBox(height: 40,),
                  _buttonSubmit(context),
                ]
              ),
            ),
          )
        ],
      )
    );
  }

  Padding _field(BuildContext context, String header, TextEditingController controller){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),

          TextField(
            controller: controller,
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

  
  Padding _dateField(BuildContext context){
    //Start for true ;; End for false
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date of Birth", 
            style: TextStyle(
              color: Color(0xff5038bc),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: TextField(
              readOnly: true,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
              textAlignVertical: TextAlignVertical.center,
              controller: _birthController,
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
                    firstDate: DateTime(1900), 
                    lastDate: DateTime(2050)
                  );
                
                if (pickeddate != null){
                  setState(() {
                    _birthController.text = DateFormat('MMM-dd-yyyy').format(pickeddate);
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
  
  Padding _buttonSubmit(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(25,0,25,25),
      child: InkWell(
        onTap: () {
          _updateProfile();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile berhasil di update"))
          );
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
          child: Text("Update profile.",
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