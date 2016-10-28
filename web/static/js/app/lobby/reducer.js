import { socket } from '../session'

const lobbyChannel = socket.channel('lobby')
lobbyChannel.join()

const initialState = {
  lobbyChannel,
}

export default function reducer(state = initialState, action = {}) {
  return state
}
