import { Socket } from 'phoenix'

const playerId = window.playerId;
const socket = new Socket("/socket", {
  params: {
    id: playerId,
  },
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) },
})

socket.connect()

const lobbyChannel = socket.channel('lobby')
lobbyChannel.join()

const initialState = {
  playerId,
  socket,
  lobbyChannel
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case 'SESSION_SET_PLAYER':
      return { ...state, gameChannel: action.channel }
    default:
      return state
  }
}
