import 'package:flutter/material.dart';

import '../../../Controller/DataApi/DataApiCloudStore.dart';

class addChatUser extends StatelessWidget {
  const addChatUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();

    String phone = '';
    return InkWell(
      onTap: (){
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
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  onChanged: (value) => phone = value,
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+91',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color
                                  ?.withOpacity(0.64))
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    hintText: "Ex:-9988774455     \t\t\t",
                    labelText: 'Enter User Mobile Number ',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Please enter a valid 10 digit phone number';
                    }
                    return null;
                  },
                ),
              ),
              //actions
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
                                      content: Text("User Does not exist..!!"),
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
