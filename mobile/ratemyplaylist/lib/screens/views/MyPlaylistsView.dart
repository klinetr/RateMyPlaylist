import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

class MyPlaylistsView extends StatefulWidget{
  const MyPlaylistsView({Key? key}) : super(key:key);

  @override
  _MyPlaylistsViewState createState(){
    return _MyPlaylistsViewState();
  }
}

class _MyPlaylistsViewState extends State<MyPlaylistsView>{
  
  @override
  Widget build(BuildContext context){
    return Container(
      color: RMPBlack,
      child:Column(
        children: [
          Expanded(child:(allAccounts.initialized) ?  new BuildMyPlaylistView() : const CircularProgressIndicator(),),
        ]
      )
    );
  }

  @override
  void initState(){
    super.initState();
  }
}

class BuildMyPlaylistView extends StatefulWidget{
  const BuildMyPlaylistView({Key? key}) : super(key:key);

  @override
  _BuildMyPlaylistViewState createState(){
    return _BuildMyPlaylistViewState();
  }
}


class _BuildMyPlaylistViewState extends State<BuildMyPlaylistView>{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    if(!allAccounts.initialized) return Container();
    Accounts myAccount = allAccounts.getAccount(user.id);
    if(myAccount.playlists.length == 0) return Container(
      width: MediaQuery.of(context).size.width,
      color: RMPBlack,
      child: Column(
        children:[
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              'You have no playlists',
              style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold),
            )
          )
        ]
      ),
    );
    return ListView.builder(
      itemCount: myAccount.playlists.length,
      itemBuilder: (BuildContext, int index){
        return Container(
          margin: EdgeInsets.only(top:5),
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            color: RMPGreen,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Playlist: ${myAccount.playlists[index]['pname']}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ), 
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  'Rating: ${myAccount.playlists[index]['rating']}',
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}