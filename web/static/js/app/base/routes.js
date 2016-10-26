import React from 'react'
import { Route, IndexRoute } from 'react-router'

import App from './containers/App'

import { components as lobbyComponents } from '../lobby'
const { LobbyView } = lobbyComponents

export default (
  <Route path='/play' component={App}>
    <IndexRoute component={LobbyView} />
  </Route>
)