import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:model_performance_app/display/thanks_page.dart';
import 'package:model_performance_app/model/mobile.dart';
import 'start_page.dart';

class Submit extends StatefulWidget {
  const Submit({super.key});

  @override
  State<Submit> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  final formkey = GlobalKey<FormState>();
  Mobile myMobile = Mobile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _mobileCollection =
      FirebaseFirestore.instance.collection("score");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            // body: Container(
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [Colors.blue, Colors.red],
              // )),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            'About your device?',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Brand',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          validator: RequiredValidator(
                              errorText: "Please type your device brand."),
                          onSaved: (brand) {
                            myMobile.brand = brand;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Model',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          validator: RequiredValidator(
                              errorText: "Please type your device model."),
                          onSaved: (model) {
                            myMobile.model = model;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  await _mobileCollection.add({
                                    'Device': {
                                      "Brand": myMobile.brand,
                                      "Model": myMobile.model,
                                    },
                                    'MoveNet_Thunder_Float16': {
                                      'Duration': score.duration[0],
                                      'Score': score.score[0],
                                      'Frame_Sec': score.frame_sec[0]
                                    },
                                    'MoveNet_Thunder_Int8': {
                                      'Duration': score.duration[1],
                                      'Score': score.score[1],
                                      'Frame_Sec': score.frame_sec[1]
                                    },
                                    'MoveNet_Lightning_Float16': {
                                      'Duration': score.duration[2],
                                      'Score': score.score[2],
                                      'Frame_Sec': score.frame_sec[2]
                                    },
                                    'MoveNet_Lightning_Int8': {
                                      'Duration': score.duration[3],
                                      'Score': score.score[3],
                                      'Frame_Sec': score.frame_sec[3]
                                    },
                                    'Total_Duration': score.totalTime
                                  });
                                  formkey.currentState!.reset();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return ThanksPage();
                                  }));
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 18),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            // ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
