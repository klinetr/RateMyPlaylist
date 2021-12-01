import 'package:ratemyplaylist/screens/widgets/searchFriendWidget.dart';
import 'package:ratemyplaylist/utils/reuse.dart';
import 'package:flutter/material.dart';


class FriendsView extends StatefulWidget{
  const FriendsView({Key? key}) : super(key:key);

  @override
  _FriendsViewState createState(){
    return _FriendsViewState();
  }
}

class _FriendsViewState extends State<FriendsView>{
  final addFriendController = TextEditingController();


  @override
  void initState(){
    super.initState();
    outsideClick = new ValueNotifier(false);
    overlayOpen = new ValueNotifier(false);
    overlayOpen.addListener(() {
      print('Overlay Val: ${overlayOpen.value}');
      setState(() {
        
      });
    });
  }

  @override
  void dispose(){
    addFriendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        setState(() {
          outsideClick.value = true;
          print(outsideClick.value);

        });
      },
      child:Container(
        color: RMPBlack,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child:SearchFriendWidget(),
            ),
            (overlayOpen.value == false) ? Expanded(
              child:GestureDetector(
                onTap: (){
                  setState(() {
                    //outsideClick.value = true;
                    print(outsideClick.value);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width*.8,
                  child: (friendAccounts.initialized == false) ?  Container(height: 50, width:50, child: const CircularProgressIndicator(),): friendsBuilder(),
                ),
              )
            ): Container(width:MediaQuery.of(context).size.width, color: RMPBlack,)
          ],
        )
      )
    );
  }

  Widget friendsBuilder(){
    return ListView.builder(
      itemCount: friendAccounts.usernames.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          margin: EdgeInsets.only(top:5),
          height: 48,
          width: MediaQuery.of(context).size.width*.8,
            decoration: new BoxDecoration(
              color: RMPGreen,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width:150,
                child:Text(
                  '${friendAccounts.usernames[index]}', 
                  style: TextStyle(
                    color: RMPBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  )
                )
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          friendAccounts.removeAccount(friendAccounts.ids[index]);
                        });
                      }, 
                      highlightColor: RMPGreen,
                      icon: Icon(Icons.delete),
                      ),
                  ],
                )
              )
            ]
          )
        );
      },
    );
  }
}
