import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import { reducer as lobbyReducer } from '../lobby'
import { reducer as gameReducer } from '../game'
import { reducer as sessionReducer } from '../session'

export default combineReducers({
  routing: routerReducer,
  lobby: lobbyReducer,
  game: gameReducer,
  session: sessionReducer,
})
