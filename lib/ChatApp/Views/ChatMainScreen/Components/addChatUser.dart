import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../Controller/DataApi/DataApiCloudStore.dart';

class addChatUser extends StatelessWidget {
  const addChatUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();
    String phone = '';
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  contentPadding: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  //title
                  title: Row(
                    children: const [
                      Icon(
                        Icons.person_add,
                        color: Colors.indigo,
                        size: 28,
                      ),
                      Text('   Add User       \t')
                    ],
                  ),
                  //content
                  content: Form(
                      key: formKey1,
                      child: IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: "Ex:-9988774455     \t\t\t",
                          labelText: 'Enter User Mobile Number ',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          fillColor: const Color(0xffF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffCCCCCC)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (value) {
                          phone = value.completeNumber;
                        },
                      )),
                  actions: [
                    //cancel button
                    MaterialButton(
                        onPressed: () {
                          //hide alert dialog
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        )),
                    //update button
                    MaterialButton(
                        onPressed: () async {
                          //hide alert dialog
                          if (formKey1.currentState!.validate()) {
                            formKey1.currentState!.save();
                            Navigator.pop(context);
                            if (phone.isNotEmpty) {
                              await DataApiCloudStore.addChatUser(phone)
                                  .then((value) {
                                if (!value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("User Does not exist..!!"),
                                          backgroundColor:
                                              Colors.blue.withOpacity(.8),
                                          behavior: SnackBarBehavior.floating));
                                }
                              });
                            }
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ))
                  ],
                ));
      },
      child: Center(
        child: CircleAvatar(
            radius: 25,
            child: Icon(
              Icons.add_comment_rounded,
              color: Colors.white,
            ),
            backgroundColor: Colors.indigo),
      ),
    );
  }
}
