import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ratemyplaylist/screens/LoginScreen.dart';
import 'package:ratemyplaylist/utils/reuse.dart';
import 'package:http/http.dart' as http;
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:ratemyplaylist/screens/views/AccountView.dart';
import 'package:ratemyplaylist/screens/views/PlaylistsView.dart';
import 'package:ratemyplaylist/screens/views/LeaderboardsView.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 2;
  var _view = [LeaderboardsView(),PlaylistsView(),AccountView()];

  @override
  void initState(){
    super.initState();
    
  }
  
  void setup(){
    if(allAccounts.initialized == false) setupAllAccounts().whenComplete((){
    });
  }

  @override
  Widget build(BuildContext context){
    if(user.id != -1) {
      setup();
			return Scaffold(
      backgroundColor: RMPBlack,
      extendBody: false,
      body: SafeArea(
        child: Center(
          child: (allAccounts.initialized == false || friendAccounts.initialized == false) ? Center(child:const CircularProgressIndicator()) : _view[_index],
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: RMPBlack,
                  spreadRadius: .5,
                  blurRadius: .5,
                  offset: Offset(0, -1) 
                ),
              ]
            ),
          child: FloatingNavbar(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(0),
            borderRadius: 8,
            itemBorderRadius: 9,
            iconSize: 26,
            fontSize: 14,
            backgroundColor: RMPBlack,
            unselectedItemColor: RMPGreen,
            selectedBackgroundColor: RMPGreen,
            selectedItemColor: RMPBlack,
            onTap: (int val) => setState((){
              if(loading != true) _index = val;
            }),
            currentIndex: _index,
            items: [
              FloatingNavbarItem(icon: Icons.leaderboard, title:'Leaderboards'),
              FloatingNavbarItem(icon: Icons.featured_play_list_sharp,title:'Playlists'),
              FloatingNavbarItem(icon: Icons.account_circle_sharp, title:'Account'),
            ],
          ),
        )
      )
    );
    } else return LoginScreen();
  }
  
  Future<void> setupAllAccounts() async{
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/viewfriends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'userID':user.id,
      }),
    );
    user.friendsList = jsonDecode(response.body)['fid'];
    print('FriendsList: ${user.friendsList.toSet().toList()}');
    final response1 = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/searchUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'userID':-1,
        'search': '',
      }),
    );
    var usernames = jsonDecode(response1.body)['results'];
    usernames = usernames.toSet().toList();
    print(usernames);
    usernames.sort();
    print(usernames);
    var ids = [];
    var names = [];
    for(int i = 0;i<usernames.length; i++){
      final response2 = await http.post(
        Uri.parse('https://ratemyplaylist0.herokuapp.com/api/viewuser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':user.token,
        },
        body: jsonEncode(<String, dynamic>{
          'username': usernames[i],
        }),
      );
      ids.add(jsonDecode(response2.body)['userID']);
      names.add(jsonDecode(response2.body)['name']);
    }

    final response3 = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/showpleaderboard'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
    );
    var playlists = jsonDecode(response3.body)['parray'];
    allAccounts = new Accounts(usernames: usernames, ids: ids, names: names, playlists: playlists);    
    setState(() {
      allAccounts.initialized = true;
    });
    print(user.friendsList);
    if(user.friendsList != null) {
      friendAccounts.populate(user.friendsList.toSet().toList());
      print('Accounts ${friendAccounts.usernames}');
      print('Listt ${user.friendsList.toSet().toList()}');
    }
    else friendAccounts.populate([]);

    setState(() {
        //allAccounts.initialized = true;
        friendAccounts.initialized = true;
        friendAccounts.isRoot = true;
        loading = false;
        //allAccountsInitialized.value = true;
    });
  }

}

