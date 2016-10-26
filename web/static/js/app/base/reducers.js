import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import { reducer as lobbyReducer } from '../lobby'

export default combineReducers({
  routing: routerReducer,
  lobby: lobbyReducer,
})
