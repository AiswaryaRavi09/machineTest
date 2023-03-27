import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otpscreen.dart';



class HomePage extends StatefulWidget {
  const HomePage( {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading=false;
  final TextEditingController _controller=TextEditingController();
  final auth=FirebaseAuth.instance;
  var phone="";
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Scaffold(

        body: SafeArea(
          child: Padding(
            padding:  const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
            child: Column(
              children:   [ const SizedBox(height: 70,),
                const Center(child: Image(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkwuvoWMhl6YAb-8BWrKD1JN5NKA6qe9rHVQfXQKNAVbmSeAKTPeJ8KGzusoTuWC25OX4&usqp=CAU",))),
                const SizedBox(height: 20,),
                TextFormField(
                  onChanged: (value){
                    phone=value;
                  },
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                    prefix: Padding(padding: EdgeInsets.all(4),
                      child: Text('+91'),),
                  ),
                  maxLength: 10,keyboardType: TextInputType.number,

                ),


                const SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OtpScreen(phone: phone,)));
                }, child: const Text('Login'))
              ],
            ),
          ),),
      ),
    );
  }

}
