require('dotenv').config();
const url = process.env.MONGODB_URI;
const MongoClient = require('mongodb').MongoClient;
const client = new MongoClient(url);
client.connect();

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require("jsonwebtoken");
const auth = require("./middleware/auth");
const sendEmail = require('./middleware/emailsend');
const templates = require('./middleware/template');
const msgs = require('./middleware/emailmsgs');

const path = require('path');           
const PORT = process.env.PORT || 5000;

const app = express();

app.set('port', (process.env.PORT || 5000));

app.use(cors());
app.use(bodyParser.json());

app.post('/api/login', async (req, res, next) => 
{
  // incoming: username, password
  // outgoing: userID, name, email, spotifyUserID, token, error
	
  var error = '';

  const { username, password } = req.body;
  const db = client.db();
  const result = await 
  db.collection('User').find({username:username,password:password}).toArray();
  var id = -1;
  var n = '';
  var em = '';
  var sid = '';
  if( result.length > 0 )
  {
    id = result[0].userID;
    n = result[0].name;
    em = result[0].email;
    sid = result[0].spotifyUserID;
    stat = result[0].status;

    if(stat)
    {
      const token = jwt.sign(
        { id, em },
        process.env.TOKEN_KEY,
        {
          expiresIn: "2h",
        }
      );
    
      var ret = { userID:id, name:n, email:em, spotifyUserID:sid, token:token ,error:error};
      res.status(200).json(ret);
    }
    else
    {
      error = 'This user is not verified yet. Please check your e-mail for verification.';
      var ret = {error:error};
      res.status(200).json(ret);   
    }
  }
  else
  {
    error = 'Username or Password is invalid. Please try again.';
    var ret = {error:error};
    res.status(200).json(ret); 
  }
});

app.post('/api/register', async (req, res, next) =>
{
  // incoming: name, username, password, email
  // outgoing: error, email sent message
	
  const { name, username, password, email } = req.body;

  var error = '';
  var token = '';
  const db = client.db();
  let result = await db.collection('User').findOne({username:username});
  if(result) {
    error = 'this username exists';
  }
  else{
    try
    {
      token = jwt.sign(
        { username, email },
        process.env.TOKEN_KEY,
        {
          expiresIn: "2h",
        }
      );

      const db = client.db();
      const result = db.collection('User').insertOne({name:name, username:username, password:password, email:email, status: false, token: token});
      sendEmail(email, templates.confirm(token));
    }
    catch(e)
    {
      error = e.toString();
    }
  }
  
  var ret = {error: error, msg: msgs.confirm, token: token };
  res.status(200).json(ret);

});

app.post('/api/viewfriends', auth, async (req, res, next) =>
{
  // incoming: userID
  // outgoing: fid, error
	
  var error = '';

  const { userID} = req.body;
  const db = client.db();
  const result = await
  db.collection('User').find({userID:userID}).toArray();
  var f = [];
  
  if( result.length > 0 )
  {
    f = result[0].fid;
  }

  var ret = { fid:f, error:error};
  res.status(200).json(ret);
});


app.post('/api/viewuser', auth,  async (req, res, next) =>
{
  // incoming: username
  // outgoing: userID, name,  error
	
  var error = '';

  const { username} = req.body;
  const db = client.db();
  const result = await
  db.collection('User').find({username:username}).toArray();
  var id = 0;
  var n = '';
  
  
  if( result.length > 0 )
  {
    id = result[0].userID;
    n = result[0].name;
  }

  var ret = { userID:id, name:n, error:error};
  res.status(200).json(ret);
});

app.post('/api/confirmemail',async (req, res, next) =>
{
  // incoming token
  // outgoing error, email confirmed message

  var error = '';
  const { token } = req.body;
  const db = client.db();
  try
  {
    const result = db.collection('User').updateOne(
    { token : token},
      {
        $set: 
        {
          status : true
        }
      });
    
    /*const result1 = db.collection('User').updateOne(
    { token : token},
      {
        $unset: 
        {
          token : ""
        }
      });*/
  }
  catch(e)
  {
    error = e.toString();
  } 

    var ret = { error: error, msg: msgs.confirmed };
    res.status(200).json(ret);

});

app.post('/api/forgotpassword', async (req, res, next) =>
{
  // incoming: email
  // outgoing: error, email sent message
	
  const { email } = req.body;

  var error = '';
  var token = ''
  const db = client.db();
  const result = await db.collection('User').find({email:email}).toArray();
  var id = -1;
  var em = '';
  if( result.length > 0 )
  {
    try
    {
      id = result[0].userID;
      em = result[0].email;
      token = jwt.sign(
        { id, em },
        process.env.TOKEN_KEY,
        {
          expiresIn: "2h",
        }
      );

      const result1 = db.collection('User').updateOne(
        { email : email},
          {
            $set: 
            {
              token : token
            }
          });

      sendEmail(email, templates.fconfirm(token));
    }
    catch(e)
    {
      error = e.toString();
    }

    var ret = {error: error, msg: msgs.fconfirm, token: token };
    res.status(200).json(ret);
  }
  else{
    error = 'This e-mail does not exists';
    var ret = {error: error};
    res.status(200).json(ret);
  }
  
});

app.post('/api/updatepassword',async (req, res, next) =>
{
  // incoming token,password
  // outgoing error, updated messages

  var error = '';
  const { token, password } = req.body;
  const db = client.db();
  try
  {
    const result = db.collection('User').updateOne(
    { token : token},
      {
        $set: 
        {
          password : password
        }
      });
  }
  catch(e)
  {
    error = e.toString();
  } 

    var ret = { error: error, msg: msgs.updated };
    res.status(200).json(ret);

});

app.post('/api/addspotifyuser', auth, async (req, res, next) => 
{
  // incoming: userID, spotifyUserID
  // outgoing: error
	
  var error = '';

  const { userID, spotifyUserID } = req.body;
  
    try
    {
      const db = client.db();
      const result = db.collection('User').updateOne(
        { userID : userID },
        {
          $set:{
            spotifyUserID : spotifyUserID
          }
           
        });
    }
    catch(e)
    {
      error = e.toString();
    }
  
    var ret = { error: error };
    res.status(200).json(ret);
});

app.post('/api/addplaylist', auth, async (req, res, next) =>
{
  // incoming: pname, userID, genre, spotifyPlaylistID
  // outgoing: error
	
  const { pname, userID, genre, spotifyPlaylistID, username } = req.body;

  var error = '';
  var rating = 0;
    try
    {
      const db = client.db();
      const result = db.collection('Playlist').insertOne({pname:pname, userID:userID, rating:rating, genre:genre, spotifyPlaylistID:spotifyPlaylistID, username:username});
    }
    catch(e)
    {
      error = e.toString();
    }
  
  
  var ret = { error: error };
  res.status(200).json(ret);

});

app.post('/api/viewplaylist', auth, async (req, res, next) =>
{
  // incoming: playlistID, userID
  // outgoing: pname, rating, genre, error
	
  var error = '';

  const { playlistID, userID} = req.body;
  const db = client.db();
  const result = await
  db.collection('Playlist').find({playlistID:playlistID,userID:userID}).toArray();
  var pn = '';
  var r = '';
  var g = [];
  
  if( result.length > 0 )
  {
    pn = result[0].pname;
    r = result[0].rating;
    g = result[0].genre;
  }

  var ret = { pname:pn, rating:r, genre:g, error:error};
  res.status(200).json(ret);
});

app.post('/api/addfriend', auth, async (req, res, next) =>
{
  // incoming: userID, fid
  // outgoing: error

  var error = '';

  const { userID, fid } = req.body;

  try
  {
    const db = client.db();
    const result = db.collection('User').updateOne(
      { userID : userID },
      {
        $push: 
        {
         fid : fid
        }
      });
  }
  catch(e)
  {
    error = e.toString();
  }

  var ret = { error: error };
  res.status(200).json(ret);
});

app.post('/api/deletefriend', auth, async (req, res, next) =>
{
  // incoming: userID, fid
  // outgoing: error

  var error = '';

  const { userID, fid } = req.body;

  try
  {
    const db = client.db();
    const result = db.collection('User').updateOne(
      { userID : userID},
      {
        $pull: 
        {
         fid : fid
        }
      });
  }
  catch(e)
  {
    error = e.toString();
  }

  var ret = { error: error };
  res.status(200).json(ret);
});

app.post('/api/increaserating', auth, async (req, res, next) =>
{
  // incoming: playlistID
  // outgoing: error

  var error = '';

  const { playlistID } = req.body;

  try
  {
    const db = client.db();
    const result = db.collection('Playlist').updateOne(
      { playlistID : playlistID},
      {
        $inc: 
        {
         rating : 1
        }
      });
  }
  catch(e)
  {
    error = e.toString();
  }

  var ret = { error: error };
  res.status(200).json(ret);
});

app.post('/api/decreaserating', auth, async (req, res, next) =>
{
  // incoming: playlistID
  // outgoing: error

  var error = '';

  const { playlistID } = req.body;

  try
  {
    const db = client.db();
    const result = db.collection('Playlist').updateOne(
      { playlistID : playlistID},
      {
        $inc: 
        {
         rating : -1
        }
      });
  }
  catch(e)
  {
    error = e.toString();
  }

  var ret = { error: error };
  res.status(200).json(ret);
});



app.delete('/api/deleteplaylist', auth, async (req, res, next) =>
{
  // incoming: playlistID
  // outgoing: error

  var error = '';

  const { playlistID } = req.body;

  try
  {
    const db = client.db();
    const result = db.collection('Playlist').deleteOne(
    {
      playlistID : playlistID
    }
    );
  }
  catch(e)
  {
    error = e.toString();
  }

  var ret = { error: error };
  res.status(200).json(ret);
});

app.post('/api/showpleaderboard', auth, async (req, res, next) =>
{
  // incoming:
  // outgoing: parray
	
  var error = '';

  const db = client.db();
  const result = await
  db.collection('Playlist').find().sort({rating: -1}).limit(25).toArray();

  var ret = { parray: result, error:error};
  res.status(200).json(ret);
});

app.post('/api/showfleaderboard', auth, async (req, res, next) =>
{
  // incoming: userID
  // outgoing: parray, error
	
  var error = '';

  const {userID} = req.body;
  
  const db = client.db();
  const result = await
  db.collection('Playlist').find({userID : userID}).sort({rating: -1}).limit(25).toArray();

  var ret = { parray: result, error:error};
  res.status(200).json(ret);

});

app.post('/api/showpplaylist', auth, async (req, res, next) =>
{
  // incoming:
  // outgoing: parray, error
	
  var error = '';

  const db = client.db();
  const result = await
  db.collection('Playlist').find().sort({playlistID: -1}).limit(50).toArray();

  var ret = { parray: result, error:error};
  res.status(200).json(ret);
});

app.post('/api/showfriendplaylist', auth, async (req, res, next) =>
{
  // incoming: userID
  // outgoing: parray
	
  var error = '';

  const {userID} = req.body;
  
  const db = client.db();
  const result = await
  db.collection('Playlist').find({userID : userID}).sort({playlistID: -1}).limit(20).toArray();

  var ret = { parray: result, error:error};
  res.status(200).json(ret);
});

app.post('/api/showfriendplaylists',  async (req, res, next) =>
{
  // incoming: fid, fid length
  // outgoing: parray
	
  var error = '';

  const {fid, length} = req.body;
  
  const db = client.db();
  var playlists = []
  for(var i=0; i<length; i++) {
    userID = fid[i]
    const result = await
    db.collection('Playlist').find({userID : userID}).sort({playlistID: -1}).limit(50).toArray();
    playlists.push(...result)
  }

  var ret = { parray: playlists, error:error};
  res.status(200).json(ret);
});
app.post('/api/showfriendleaderboard', auth, async (req, res, next) =>
{
  // incoming: fid, fid length
  // outgoing: parray, error
	
  var error = '';

  const {fid, length} = req.body;
  
  const db = client.db();
  var playlists = []
  for(var i=0; i<length; i++) {
    userID = fid[i]
    const result = await
    db.collection('Playlist').find({userID : userID}).sort({rating: -1}).limit(25).toArray();
    playlists.push(...result)
  }
  playlists.sort(function(a, b){return b.rating - a.rating})
  var ret = { parray: playlists, error:error};
  res.status(200).json(ret);

});

app.post('/api/searchplaylist', auth, async (req, res, next) =>
{
  // incoming: userID, search
  // outgoing: results[], error
  var error = '';
  const { userID, search } = req.body;
  var _search = search.trim();
  
  const db = client.db();
  const results = await db.collection('Playlist').find({"pname":{$regex:_search+'.*', $options:'r'}}).toArray();
  
  var _ret = [];
  for( var i=0; i<results.length; i++ )
  {
    _ret.push( results[i].pname);
  }
  
  var ret = {results:_ret, error:error};
  res.status(200).json(ret);

});
app.post('/api/searchuser', auth, async (req, res, next) =>
{
  // incoming: userID, search
  // outgoing: results[], error
  var error = '';
  const { userID, search } = req.body;
  var _search = search.trim();
  
  const db = client.db();
  const results = await db.collection('User').find({"username":{$regex:_search+'.*', $options:'r'}}).toArray();
  
  var _ret = [];
  for( var i=0; i<results.length; i++ )
  {
    _ret.push( results[i].username);
  }
  
  var ret = {results:_ret, error:error};
  res.status(200).json(ret);

});
app.post('/api/getusername', auth, async (req, res, next) =>
{
  // incoming: userID
  // outgoing: username, name,  error
	
  var error = '';

  const { userID} = req.body;
  const db = client.db();
  const result = await
  db.collection('User').find({userID:userID}).toArray();
  var user = '';
  var n = '';
  
  
  if( result.length > 0 )
  {
    user = result[0].username;
    n = result[0].name;
  }

  var ret = { username:user, name:n, error:error};
  res.status(200).json(ret);
});
app.use((req, res, next) => 
{
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  );
  res.setHeader(
    'Access-Control-Allow-Methods',
    'GET, POST, PATCH, DELETE, OPTIONS'
  );
  next();
});

app.listen(PORT, () => 
{
  console.log('Server listening on port ' + PORT);
});

if (process.env.NODE_ENV == 'production') 
{
  // Set static folder
  app.use(express.static('frontend/build'));

  app.get('*', (req, res) => 
 {
    res.sendFile(path.resolve(__dirname, 'frontend', 'build', 'index.html'));
  });
}
