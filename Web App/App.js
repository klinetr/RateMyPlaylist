//import React from 'react';
import React, { Component } from 'react'
import {Routes, Route, Navigate} from 'react-router-dom'
import "./App.css";
import Login from './components/Login'
import Register from './components/Register'
import SpotifyLogin from './components/SpotifyLogin'
import GetSpotifyId from './components/GetSpotifyId'
import UploadPlaylist from './components/UploadPlaylist'
import PublicPlaylists from './components/PublicPlaylists'
import FriendsPlaylists from './components/FriendsPlaylists'
import PublicLeaderboard from './components/PublicLeaderboard'
import FriendsLeaderboard from './components/FriendsLeaderboard'
import YourFriends from './components/YourFriends'
import AddFriend from './components/AddFriend'
import ConfirmEmail from './components/ConfirmEmail'
import ResetPassword from './components/ResetPassword'
import ViewTracks from './components/ViewTracks';

class App extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <>
          <Routes>
            <Route path='/register' element={
              <Register />
            }/>

            <Route path='/spotifylogin' element={
              <SpotifyLogin />
            }/>

            <Route path='/getspotifyid' element={
              <GetSpotifyId />
            }/> 

            <Route path='/uploadplaylist' element={
              <UploadPlaylist />
            }/>

            <Route path='/publicplaylists' element={
              <PublicPlaylists />
            }/> 

            <Route path='/friendsplaylists' element={
              <FriendsPlaylists />
            }/>

            <Route path='/publicleaderboard' element={
              <PublicLeaderboard />
            }/>

            <Route path='/friendsleaderboard' element={
              <FriendsLeaderboard />
            }/>

            <Route path='/yourfriends' element={
              <YourFriends />
            }/>

            <Route path='addfriend' element={
              <AddFriend />
            }/>

            <Route path='/confirm' element={
              <ConfirmEmail />
            }/>

            <Route path='/password' element={
              <ResetPassword />
            }/>

            <Route path='/viewtracks' element={
              <ViewTracks />
            }/>

            <Route path='/' element={
              <Login />
            }/>
          </Routes>
      </>
    );
  }
}

export default App