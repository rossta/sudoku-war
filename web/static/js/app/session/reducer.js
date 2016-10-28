import Constants from './constants'
import { socket, playerId } from './socket'

const initialState = {
  playerId,
  socket,
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SESSION_SET_PLAYER:
      return {
        ...state,
        playerId: action.player_id,
        socket: action.socket,
      };

    default:
      return state;
  }
}
