import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';
import 'package:ratemyplaylist/screens/views/FriendsView.dart';
import 'package:ratemyplaylist/screens/views/SettingsView.dart';
import 'package:ratemyplaylist/screens/views/MyPlaylistsView.dart';


int accountIndex = 1;
var accountView = [MyPlaylistsView(), FriendsView(), SettingsView()];
var accountTopBarColors = [RMPBlack, RMPBlack, RMPBlack];
var accountTextColors = [RMPGreen, RMPGreen, RMPGreen];

class AccountView extends StatefulWidget{
  const AccountView({Key? key}) : super(key:key);

  @override
  _AccountViewState createState(){
    return _AccountViewState();
  }
}

class _AccountViewState extends State<AccountView>{
  @override
  void initState(){
    super.initState();
    
    setTopBarActive(accountIndex);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: RMPBlack,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: RMPBlack,
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("My Playlists", style: TextStyle(color: accountTextColors[0], fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    primary: accountTopBarColors[0],
                    ),
                  onPressed: (){
                    if(loading != true){
                      setState(() {
                        accountIndex = 0;
                        setTopBarActive(0);
                      });
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("Friends", style: TextStyle(color: accountTextColors[1], fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    primary: accountTopBarColors[1]
                  ),
                  onPressed: (){
                    if(loading != true){
                      setState(() {
                        accountIndex = 1;
                        setTopBarActive(1);
                      });
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: accountTopBarColors[2]
                  ),
                  child: Text("Profile", style: TextStyle(color: accountTextColors[2], fontWeight: FontWeight.bold),),
                  onPressed: (){
                    if(loading != true){
                      setState(() {
                        accountIndex = 2;
                        setTopBarActive(2);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(child: accountView[accountIndex]),
        ],
      ),
    );
  }

  void setTopBarActive(int idx){
    for(int i = 0; i < 3; i++){
      if(i == idx) {
        accountTopBarColors[i] = RMPGreen;
        accountTextColors[i] = RMPBlack;
      }
      else
      {
        accountTopBarColors[i] = RMPBlack;
        accountTextColors[i] = RMPGreen;
      }
    }
  }

}

