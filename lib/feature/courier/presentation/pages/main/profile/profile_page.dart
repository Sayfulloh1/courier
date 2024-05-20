import 'package:courier_app/feature/courier/presentation/resources/values_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width(context), height(context) * .25),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Личный кабинет",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.white,
                    size: 70,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Erkin A.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "+998903901898",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(context) * .03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.only(top: 20),
              width: width(context),

              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Уведомления',
                    style: TextStyle(fontSize: 25),
                  ),
                  trailing: Switch(
                    activeColor: Colors.blue,
                    onChanged: (val) {},
                    value: false,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: width(context)*.8,
              child: Row(

                children: [
                  Icon(Icons.logout,color: Colors.red,size: 20,),
                  SizedBox(width: 8),
                  Text("Выйти с аккаунта",style: TextStyle(color: Colors.red,fontSize: 16),),
                  SizedBox(height: height(context)*.1,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
