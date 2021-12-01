import 'package:flutter/material.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

ValueNotifier outsideClick = new ValueNotifier(false);
ValueNotifier overlayOpen = new ValueNotifier(false);
String val = '';
class SearchFriendWidget extends StatefulWidget{

  @override
  SearchFriendWidgetState createState(){
    return SearchFriendWidgetState();
  }
}

class SearchFriendWidgetState extends State<SearchFriendWidget>{
  OverlayEntry? _entry;
  //final _formKey = GlobalKey<FormState>();
  //final searchFriendController = TextEditingController();
  final layerLink = LayerLink();
  final focusNode = FocusNode();
  String last = '';
  Accounts search = new Accounts(usernames: [], ids: [], names: [], playlists: []);
  @override
  void dispose(){
    //searchFriendController.dispose();
    //hideOverlay();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    outsideClick.addListener(() {
      if(outsideClick.value == true){
        outsideClick.value = false;
        print("hide");
        setState(() {
          hideOverlay();
        });
        
      }
    });
  }

  void hideOverlay(){
    overlayOpen.value = false;
    if(_entry != null){
      setState(() {
      });
      _entry?.remove();
      _entry = null;
    }
  }

  void showOverlay(Accounts search){
    overlayOpen.value = true;
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        //left: offset.dx,
        //top: offset.dy + size.height,
        width: size.width*.8,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(size.width*.1,size.height),
          child: OverlayClass(search:search,focusNode: focusNode,),
        )
      )
    );
    overlay.insert(_entry!);
  }

  @override
  Widget build(BuildContext context){
    return CompositedTransformTarget(
      link: layerLink,
      child:Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children:[
                IconButton(
                  onPressed: (){
                    setState(() {
                      search = allAccounts.searchAccounts(''.toLowerCase());
                      WidgetsBinding.instance!.addPostFrameCallback((_){
                        hideOverlay();
                        showOverlay(search);
                      });
                    });
                  }, 
                  icon: Icon(Icons.search_sharp, color: RMPGreen,),
                ),
              ]
            )
          ],
        )
      )
    );
  }

}

class TextWidget extends StatefulWidget{

  final TextEditingController searchFriendController = TextEditingController();
  final FocusNode focusNode;
  TextWidget({required this.focusNode});
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {

  late TextEditingController _searchFriendController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    print('V: ${val}');
    _searchFriendController = widget.searchFriendController;
    _focusNode = widget.focusNode;
    _searchFriendController.addListener(() {
      print("Listen");
      val = _searchFriendController.text;
    });
  }

  @override
  void dispose(){
    _searchFriendController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return TextField(
      //focusNode: _focusNode,
      controller: _searchFriendController,
      cursorColor: RMPGreen,
      style: TextStyle(color: RMPGreen),
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Colors.red),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: RMPGreen, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: RMPGreen, width: 2.0),
        ),

        fillColor: RMPBlack,
        labelText: 'Username',
        filled: true,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: RMPGreen,
        ),
      ),
    );
  }

}

class OverlayClass extends StatefulWidget{
  final Accounts search;
  final FocusNode focusNode;
  OverlayClass({required this.search,required this.focusNode});

  @override
  _OverlayClassState createState() => _OverlayClassState();
}

class _OverlayClassState extends State<OverlayClass> {
  late FocusNode _focusNode;

  Accounts _search = new Accounts(usernames: [], ids: [], names: [], playlists: []);

  @override
  void initState() {
    super.initState();
    
    _search = widget.search;
    print(_search.removeAccount(user.id));
    _focusNode = widget.focusNode;
  }

  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print(_search.usernames.length);
    return Material(
      color: RMPBlack,
      child: GestureDetector(
        onTap: (){
          _focusNode.unfocus();
          debugPrint('uf');
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: RMPBlack,
          child: (_search.usernames.length == 0) ?
          Container(
            height:50 ,
            //width: 100,
            child: Center(
                child:Text('No users found.',
                  style: TextStyle(
                      color: Colors.red
                  ),
                )
            ),
          ):
          ConstrainedBox(
              constraints: BoxConstraints(minHeight: 0, maxHeight: 400),
              child:SearchBuilder(search: _search),
          ),
        ),
      )
    );
  }
 
}

class SearchBuilder extends StatefulWidget{
  final Accounts search;
  @override
  SearchBuilder({required this.search});//, this.update});
  _SearchBuilderState createState() => _SearchBuilderState();
}

class _SearchBuilderState extends State<SearchBuilder>{

  Accounts _search = new Accounts(usernames: [], ids: [], names: [], playlists: []);

  @override
  void initState(){
    super.initState();
    _search = widget.search;
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _search.usernames.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
            margin: EdgeInsets.only(top:5),
            height: 48,
            //width: 50,
            decoration: new BoxDecoration(
              color: RMPGreen,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                child:Text(
                  '${_search.usernames[index]}', 
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
                          if(friendAccounts.ids.contains(_search.ids[index])){
                            friendAccounts.removeAccount(_search.ids[index]);
                          }else{
                            friendAccounts.addAccount(_search.ids[index]);
                          }
                        });
                      }, 
                      icon: Icon( (friendAccounts.ids.contains(_search.ids[index]) != true) ? Icons.add : Icons.delete),
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

/*
class UserQuery{
  var usernames;
  var friends = [];
  var userIds = [];
  UserQuery({required this.usernames, required this.friends, required this.userIds});
  factory UserQuery.fromJson(Map<String,dynamic> json){
    return UserQuery(
      usernames: json['results'],
      friends: [],
      userIds: [],
    );
  }
}*/
