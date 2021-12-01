
import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

int leaderboardIndex = 1;
List<dynamic> leaderboardView = [PublicView(), FriendsView()];
Color leaderboardButtonColor = RMPGreen;
Color leaderboardtextcolor = RMPGreen;

class LeaderboardsView extends StatefulWidget{
  const LeaderboardsView({Key? key}) : super(key:key);

  @override
  _LeaderboardsViewState createState(){
    return _LeaderboardsViewState();
  }
}

class _LeaderboardsViewState extends State<LeaderboardsView>{
  
  @override
  Widget build(BuildContext context){
    return Container(
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
                  child: Text("Public", style: TextStyle(color: leaderboardtextcolor, fontWeight: FontWeight.bold, fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                    primary: leaderboardButtonColor
                  ),
                  onPressed: (){
                    if(loading != true){
                      setState(() {
                        if(leaderboardIndex == 1) {
                          leaderboardIndex = 0;
                          leaderboardButtonColor = RMPGreen;
                          leaderboardtextcolor = RMPBlack;
                        }
                        else {
                          leaderboardIndex = 1;
                          leaderboardButtonColor = RMPBlack;
                          leaderboardtextcolor = RMPGreen;
                        }
                      });
                    }
                  },
                )
              ],
            )
          ),
          Expanded(child:(allAccounts.initialized) ? (leaderboardIndex == 0) ? new PublicView(): new FriendsView() : const CircularProgressIndicator(),),
        ]
      )
    );
  }

  @override
  void initState(){
    super.initState();
    if(leaderboardIndex == 0) {
      //leaderboardIndex = 0;
      leaderboardButtonColor = RMPGreen;
      leaderboardtextcolor = RMPBlack;
    }
    else {
      //leaderboardIndex = 1;
      leaderboardButtonColor = RMPBlack;
      leaderboardtextcolor = RMPGreen;
    }
    
  }
}

class PublicView extends StatefulWidget{
  const PublicView({Key? key}) : super(key:key);

  @override
  _PublicViewState createState(){
    return _PublicViewState();
  }
}


class _PublicViewState extends State<PublicView>{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    if(!allAccounts.initialized) return Container();
    var _playlists = allAccounts.getSortedPlaylists();
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
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Playlist Name: ${_playlists[index]['pname']}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      (allAccounts.ids.indexOf(_playlists[index]['userID']) == -1) ? 'Deleted User ID ${_playlists[index]['userID']}': 'User: ${allAccounts.usernames[allAccounts.ids.indexOf(_playlists[index]['userID'])]}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ),
              
              Container(
                width: 80,
                child: Text(
                  'Rating: ${_playlists[index]['rating']}',
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class FriendsView extends StatefulWidget{
  const FriendsView({Key? key}) : super(key:key);

  @override
  _FriendsViewState createState(){
    return _FriendsViewState();
  }
}

class _FriendsViewState extends State<FriendsView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(!friendAccounts.initialized) return Container();
    var _playlists = friendAccounts.getSortedPlaylists();
    print(friendAccounts.playlists.length);
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
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Playlist Name: ${_playlists[index]['pname']}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                    Text(
                      (friendAccounts.ids.indexOf(_playlists[index]['userID']) == -1) ? 'Deleted User ID ${_playlists[index]['userID']}': 'User: ${friendAccounts.usernames[friendAccounts.ids.indexOf(_playlists[index]['userID'])]}',
                      style: TextStyle(
                        color: RMPBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ),
              
              Container(
                width: 80,
                child: Text(
                  'Rating: ${_playlists[index]['rating']}',
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}