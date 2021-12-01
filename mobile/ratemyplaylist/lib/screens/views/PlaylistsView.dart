
import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

int playlistIndex = 0;
List<dynamic> playlistView = [PlaylistPublicView(), PlaylistFriendsView()];
Color playlistButtonColor = RMPGreen;
Color playlisttextcolor = RMPGreen;

class PlaylistsView extends StatefulWidget{
  const PlaylistsView({Key? key}) : super(key:key);

  @override
  _PlaylistsViewState createState(){
    return _PlaylistsViewState();
  }
}

class _PlaylistsViewState extends State<PlaylistsView>{
  
  @override
  Widget build(BuildContext context){
    return Container(
      //Change this Color
      color: RMPBlack,
      child:Column(
        children: [
          Container(
            height: 80,
            color: RMPBlack,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Public", style: TextStyle(color: playlisttextcolor, fontWeight: FontWeight.bold, fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                    primary: playlistButtonColor
                  ),
                  onPressed: (){
                    if(loading != true){
                      setState(() {
                        if(playlistIndex == 1) {
                          playlistIndex = 0;
                          playlistButtonColor = RMPGreen;
                          playlisttextcolor = RMPBlack;
                        }
                        else {
                          playlistIndex = 1;
                          playlistButtonColor = RMPBlack;
                          playlisttextcolor = RMPGreen;
                        }
                      });
                    }
                  },
                )
              ],
            )
          ),
          Expanded(child:(allAccounts.initialized) ? (playlistIndex == 0) ? new PlaylistPublicView(): new PlaylistFriendsView() : const CircularProgressIndicator(),),
        ]
      )
    );
  }

  @override
  void initState(){
    super.initState();
    if(playlistIndex == 0) {
      //playlistIndex = 0;
      playlistButtonColor = RMPGreen;
      playlisttextcolor = RMPBlack;
    }
    else {
      //playlistIndex = 1;
      playlistButtonColor = RMPBlack;
      playlisttextcolor = RMPGreen;
    }
    
  }
}

class PlaylistPublicView extends StatefulWidget{
  const PlaylistPublicView({Key? key}) : super(key:key);

  @override
  _PlaylistPublicViewState createState(){
    return _PlaylistPublicViewState();
  }
}


class _PlaylistPublicViewState extends State<PlaylistPublicView>{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    if(!allAccounts.initialized) return Container();
    var _playlists = List.from(allAccounts.playlists);
    setState(() {
      for(int i=0;i<_playlists.length;i++){
        if(_playlists[i]['userID'] == user.id){
          print("EQ");
          _playlists.removeAt(i);
          i--;
        } 
      }
    });
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (BuildContext, int index){
        return Container(
          margin: EdgeInsets.only(top:5),
          height: 80,
          decoration: new BoxDecoration(
            color: RMPGreen,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Playlist: ${_playlists[index]['pname']}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      (allAccounts.ids.indexOf(_playlists[index]['userID']) == -1) ? 'Deleted User ': 'User: ${allAccounts.usernames[allAccounts.ids.indexOf(_playlists[index]['userID'])]}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ),
              
              Container(
                padding: EdgeInsets.all(5),
                width: 85,
                child: Text(
                  'Rating: ${_playlists[index]['rating']}',
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width - 170 - 85,
                //color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          allAccounts.increaseRating(allAccounts.playlists[index]['playlistID']);
                        });
                      }, 
                      icon: Icon(Icons.add, color: RMPBlack,),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 14),
                      child:IconButton(
                        onPressed: (){
                          setState(() {
                            allAccounts.decreaseRating(allAccounts.playlists[index]['playlistID']);
                          });
                        }, 
                        icon: Icon(Icons.minimize,color: RMPBlack,),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class PlaylistFriendsView extends StatefulWidget{
  const PlaylistFriendsView({Key? key}) : super(key:key);

  @override
  _PlaylistFriendsViewState createState(){
    return _PlaylistFriendsViewState();
  }
}

class _PlaylistFriendsViewState extends State<PlaylistFriendsView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(!friendAccounts.initialized) return Container();
    var _playlists = List.from(friendAccounts.playlists);
    for(int i=0;i<_playlists.length;i++){
      if(_playlists[i]['userID'] == user.id){
        _playlists.removeAt(i);
      } 
    }
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (BuildContext, int index){
        return Container(
          margin: EdgeInsets.only(top:5),
          height: 80,
          decoration: new BoxDecoration(
            color: RMPGreen,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Playlist: ${_playlists[index]['pname']}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      (friendAccounts.ids.indexOf(_playlists[index]['userID']) == -1) ? 'Deleted User ID ${friendAccounts.playlists[index]['userID']}': 'User: ${friendAccounts.usernames[friendAccounts.ids.indexOf(_playlists[index]['userID'])]}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 85,
                child: Text(
                  'Rating: ${_playlists[index]['rating']}',
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width - 175 - 80,
                //color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          friendAccounts.increaseRating(friendAccounts.playlists[index]['playlistID']);
                        });
                      }, 
                      icon: Icon(Icons.add, color: RMPBlack,),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 14),
                      child:IconButton(
                        onPressed: (){
                          setState(() {
                            friendAccounts.decreaseRating(friendAccounts.playlists[index]['playlistID']);
                          });
                        }, 
                        icon: Icon(Icons.minimize,color: RMPBlack,),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
