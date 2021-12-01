import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//This file is for reuseable features

//Colors
const Color RMPBlue = Color.fromRGBO(45, 70, 185, 1);
const Color RMPLightGrey = Color.fromRGBO(196, 196, 196, 1);
const Color RMPWhite = Colors.white;
const Color RMPGreen = Color.fromRGBO(30, 215, 96, 1);
const Color RMPBlack = Color.fromRGBO(25, 20, 20, 1);

bool loading = false;
ValueNotifier allAccountsInitialized = new ValueNotifier(false);
Accounts allAccounts = new Accounts(usernames: [], ids: [], names: [], playlists: []);
Accounts friendAccounts = new Accounts(usernames: [], ids: [], names: [], playlists: []);
User user = new User(id: -1, name: '', email: '', token: '', error: '', spotifyUserID: '');

var glbsize = null;

//Models
class Accounts{
  var usernames = [];
  var names = [];
  var ids = [];
  var playlists = [];
  bool initialized = false;
  bool isRoot = false;
  Accounts({required this.usernames, required this.ids, required this.names, required this.playlists});

  int populate(var fid){
    if(allAccounts.initialized != false){
      var _usernames = [];
      var _names = [];
      var _ids = [];
      var _playlists = [];
      for(int i=0;i<allAccounts.ids.length;i++){
        for(int j=0;j<fid.length;j++){
          if(allAccounts.ids[i] == fid[j]){
            _usernames.add(allAccounts.usernames[i]);
            _names.add(allAccounts.names[i]);
            _ids.add(allAccounts.ids[i]);
          }
        }
      }
      for(int i=0;i<allAccounts.playlists.length;i++){
        for(int j=0;j<_ids.length;j++){
          if(allAccounts.playlists[i]['userID'] == _ids[j]){
            _playlists.add(allAccounts.playlists[i]);
          }
        }
      }
      this.usernames = _usernames;
      this.names = _names;
      this.ids = _ids;
      this.playlists = _playlists;
      this.initialized = true;
    }else return -1;
    return 1;
  }

  Accounts searchAccounts(String str){
    Accounts search = new Accounts(usernames: [], ids: [], names: [], playlists: []);
    for(int i=0;i<this.usernames.length;i++){
      if(this.usernames[i].contains(str)){
        search.addAccount(this.ids[i]);
      }
    }
    return search;
  }

  int removeAccount(int id) {
    if(getAccount(id).usernames.length == 0) return -1;
    int index = this.ids.indexOf(id);
    this.usernames.removeAt(index);
    this.names.removeAt(index);
    this.ids.removeAt(index);
    for(int i=0;i<playlists.length;i++){
      if(playlists[i]['userID'] == id){
        playlists.removeAt(i);
      }
    }
    if(isRoot){
      futureDeleteAccount(id).whenComplete((){
        loading = false;
      });
      return 2;
    }
    return 1;
  }

  int addAccount(int id){
    if(getAccount(id).usernames.length != 0) return -1;
    if(!allAccounts.ids.contains(id)) return -1;
    if(this.isRoot){
      futureAddAccount(id).whenComplete((){
        loading = false;
        print("Added");
      });
    }
    int index = allAccounts.ids.indexOf(id);
    if(index <= this.ids.length){
      this.usernames.insert(index, allAccounts.usernames[index]);
      this.names.insert(index, allAccounts.names[index]);
      this.ids.insert(index, allAccounts.ids[index]);
    }else{
      this.usernames.add(allAccounts.usernames[index]);
      this.names.add(allAccounts.names[index]);
      this.ids.add(allAccounts.ids[index]);
    }
    var _playlists = [];
    for(int i=0;i<allAccounts.playlists.length;i++){
      for(int j=0;j<this.ids.length;j++){
        if(allAccounts.playlists[i]['userID'] == this.ids[j]){
          _playlists.add(allAccounts.playlists[i]);
        }
      }
    }
    this.playlists = _playlists;
    if (this.isRoot) return 2;
    return 1;
  }

  Accounts getAccount(int id){
    Accounts account = new Accounts(usernames:  [], ids: [], names: [], playlists: []);
    int index = this.ids.indexOf(id);
    if(index == -1) return account;
    account.usernames.add(this.usernames[index]);
    account.ids.add(this.ids[index]);
    account.names.add(this.names[index]);
    for(int i=0;i<this.playlists.length;i++){
      if(this.playlists[i]['userID'] == id){
        account.playlists.add(this.playlists[i]);
      }
    }
    return account;
  }


  int increaseRating(int playlistID){
    for(int i=0;i<this.playlists.length;i++){
      if(this.playlists[i]['playlistID'] == playlistID){
        this.playlists[i]['rating'] += 1;
        futureIncreaseRating(playlistID);
        return i;
      }
    }
    return -1;
  }

  int decreaseRating(int playlistID){
    for(int i=0;i<this.playlists.length;i++){
      if(this.playlists[i]['playlistID'] == playlistID){
        this.playlists[i]['rating'] -= 1;
        futureDecreaseRating(playlistID);
        return i;
      }
    }
    return -1;
  }

  List getSortedPlaylists(){
    var _playlists = List.from(this.playlists);
    _playlists.sort((a,b)=> b['rating'].compareTo(a['rating']));
    return _playlists;
  }

  Future<void> futureDecreaseRating(int playlistID) async{
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/decreaserating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'playlistID': playlistID,
      }),
    );
  }

  Future<void> futureIncreaseRating(int playlistID) async{
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/increaserating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'playlistID': playlistID,
      }),
    );
  }

  Future<void> futureViewAccount(String username) async{
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/viewuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
      }),
    );
  }

  Future<void> futureAddAccount(int id) async{
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/addfriend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'userID': user.id,
        'fid':id,
      }),
    );
    print(user.id);
    print('TTT: ${id}');
  }

  Future<http.Response> futureDeleteAccount(int id) async{
    loading = true;
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/deletefriend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':user.token,
      },
      body: jsonEncode(<String, dynamic>{
        'userID': user.id,
        'fid':id,
      }),
    );
    return response;
  }
}

class User{
  var id;
  var name;
  var email;
  var error;
  var token;
  var spotifyUserID;
  var friendsList;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.error,
    this.spotifyUserID,
    this.friendsList,
    });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id:json['userID'], 
      name: json['name'], 
      email: json['email'], 
      token: json['token'],
      error: json['error'],
      spotifyUserID: json['spotifyUserID'],
    );
  }
}
