
import 'package:flutter_test/flutter_test.dart';
import 'package:ratemyplaylist/utils/reuse.dart';

void main(){
  group('Accounts',(){
    Accounts a = new Accounts(usernames: [], ids: [], names: [], playlists: []);
    Accounts b = new Accounts(usernames: ['kal','mal','sal','hal','jj'], ids: [1001,2002,3003,4004,5], names: ['kaleb','maleb','saleb','haleb','james'], playlists: [
    {
      "_id": "618c8369b289028dec2005b3",
      "pname": "Boomer Playlist",
      "userID": 4,
      "rating": 12,
      "playlistID": 14,s
      "genre": [
        1,
        4
      ],
      "spotifyPlaylistID": 134134,
      "timedateAdded": "2021-11-11T02:43:53.546Z"
    },
    {
      "_id": "6184495780fd9b1ba9771499",
      "pname": "Another playlist",
      "userID": 3,
      "rating": 10,
      "playlistID": 7
    },
    {
      "_id": "61a3df8b0c6c252147309180",
      "username": "eg12345",
      "pname": "Zoomer Playlist",
      "userID": 1,
      "rating": 10,
      "playlistID": 22,
      "genre": [
        1,
        4
      ],
      "spotifyPlaylistID": 1234,
      "timedateAdded": "2021-11-28T19:59:07.441Z"
    },
    {
      "_id": "61844aac80fd9b1ba977149c",
      "pname": "playliist 1 more",
      "userID": 8,
      "rating": 2,
      "playlistID": 10
    },
    {
      "_id": "618c812db289028dec2005b1",
      "pname": "New Playlist yup",
      "userID": 5,
      "rating": 2,
      "playlistID": 12,
      "genre": [
        1,
        2
      ],
      "spotifyPlaylistID": 1234,
      "timedateAdded": "2021-11-11T02:34:21.925Z"
    },
    {
      "_id": "61844a7480fd9b1ba977149b",
      "pname": "playliist 1 more",
      "userID": 5,
      "rating": 1,
      "playlistID": 9
    },
    {
      "_id": "618c823ab289028dec2005b2",
      "pname": "New Playlist another",
      "userID": 2,
      "rating": 0,
      "playlistID": 13,
      "genre": [
        1,
        5
      ],
      "spotifyPlaylistID": 12134,
      "timedateAdded": "2021-11-11T02:38:50.121Z"
    },
    {
      "_id": "618ef930f855f82cf89c20c4",
      "pname": "a playlist",
      "userID": 5,
      "rating": 0,
      "genre": [
        3
      ],
      "spotifyPlaylistID": "475653",
      "playlistID": 17
    },
    {
      "_id": "61a2be36b7c7a239703b5951",
      "pname": "lofi beats",
      "userID": "2",
      "rating": 0,
      "genre": [
        2,
        4
      ],
      "spotifyPlaylistID": "37i9dQZF1DWWQRwui0ExPn",
      "playlistID": 20
    },
    {
      "_id": "61a3ddcfab1ef8709ced1d83",
      "usermane": "eg123456",
      "pname": "playlist playlists",
      "userID": "8",
      "rating": 0,
      "genre": [
        2,
        4
      ],
      "spotifyPlaylistID": "6",
      "playlistID": 21
    },
    {
      "_id": "61a4476bc0d02295915a9eab",
      "pname": "lofi hip hop music - beats to relax/study to",
      "userID": 2,
      "rating": 0,
      "genre": [
        2,
        4
      ],
      "spotifyPlaylistID": "0vvXsWCC9xrXsKd4FyS8kM",
      "username": "jb1234",
      "playlistID": 26
    },
    {
      "_id": "61a4476cc0d02295915a9eac",
      "pname": "lofi beats",
      "userID": 2,
      "rating": 0,
      "genre": [
        2,
        4
      ],
      "spotifyPlaylistID": "37i9dQZF1DWWQRwui0ExPn",
      "username": "jb1234",
      "playlistID": 27
    },
    {
      "_id": "61a44772c0d02295915a9ead",
      "pname": "Mood",
      "userID": 2,
      "rating": 0,
      "genre": [
        2,
        4
      ],
      "spotifyPlaylistID": "4Q9Nxn1euHCXPqI2j9rqSl",
      "username": "jb1234",
      "playlistID": 28
    }]);

    allAccounts = b;
    allAccounts.initialized = true;
    test('Initialization', (){
      expect(a.initialized, false);
      expect(a.isRoot, false);
    });
    test('Populate', (){
      var fid = [1001,3003];
      expect(a.populate(fid), 1);
      expect(a.ids,[1001,3003]);
      expect(a.usernames,['kal','sal']);
      expect(a.names, ['kaleb','saleb']);
      expect(a.initialized, true);
    });

    test('Management', (){
      var fid = [1001,3003];
      expect(a.populate(fid), 1);
      
      expect(a.addAccount(2001), -1);
      print(a.ids);
      expect(a.addAccount(2002), 1);
      print(a.ids);
      expect(a.isRoot, false);
      expect(a.ids,[1001,2002,3003]);
      expect(a.usernames,['kal','mal','sal']);
      expect(a.names, ['kaleb','maleb','saleb']);

      expect(a.removeAccount(2001), -1);
      expect(a.removeAccount(2002), 1);
      expect(a.removeAccount(3003), 1);
      expect(a.addAccount(4004), 1);
      expect(a.addAccount(2002), 1);
      expect(a.addAccount(3003), 1);
      expect(a.ids, [1001,2002,3003,4004]);
    });

    test('Search', (){
      var fid = [1001,2002,3003];
      expect(a.populate(fid), 1);
      expect(a.searchAccounts('a').usernames, ['kal','mal','sal']);
      expect(a.removeAccount(2002), 1);
      expect(a.searchAccounts('m').usernames.length, 0);
      
    });

    test('Get Account', (){
      expect(b.getAccount(2002).usernames.length, 1);
      expect(b.getAccount(2002).usernames[0], 'mal');
      expect(b.getAccount(2002).ids[0], 2002);
      expect(b.getAccount(2002).names[0], 'maleb');
      expect(b.getAccount(2002).playlists.length, 0);

      expect(b.getAccount(5).playlists.length > 0, true);
      //Starting value 2
      expect(b.getAccount(5).playlists[0]['rating'], 2);
      b.increaseRating(b.getAccount(5).playlists[0]['playlistID']);
      expect(b.getAccount(5).playlists[0]['rating'], 3);
      b.decreaseRating(b.getAccount(5).playlists[0]['playlistID']);
      expect(b.getAccount(5).playlists[0]['rating'], 2);
    });

  });
}