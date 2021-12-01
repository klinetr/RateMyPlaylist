import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

class SettingsView extends StatefulWidget{
  const SettingsView({Key? key}) : super(key:key);

  @override
  _SettingsViewState createState(){
    return _SettingsViewState();
  }
}

class _SettingsViewState extends State<SettingsView>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //margin: EdgeInsetsDirectional.only(bottom: 500),
          decoration: BoxDecoration(
            color: RMPBlack,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          height: 200,
          width: MediaQuery.of(context).size.width*.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: MediaQuery.of(context).size.width*.6,child:Text('Username: ${allAccounts.usernames[allAccounts.ids.indexOf(user.id)]}',
                style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold),)),
              Container(width: MediaQuery.of(context).size.width*.6,child:Text('Name: ${user.name}',
                  style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold),)),
              Container(width:MediaQuery.of(context).size.width*.6, child:Text('Email: ${user.email}',
                  style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold),)),
              Container(
                width:MediaQuery.of(context).size.width*.6,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    Text('Spotify Status: ', style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold),),
                    (user.spotifyUserID != null) ?
                    Text('Linked',
                        style:TextStyle(color: RMPGreen, fontWeight: FontWeight.w900, decoration: TextDecoration.underline)) :
                    Text('Not Linked',
                        style:TextStyle(color: Colors.red, fontWeight: FontWeight.w900, decoration: TextDecoration.underline)),
                  ],
                )
              )
            ]
          ),
        )
      ],
    );
  }
}