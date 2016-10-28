import { socket } from '../session'
import { Channel } from '../utils'

const lobbyChannel = new Channel(socket, 'lobby')
lobbyChannel.join()
.then(() => console.log('Joined lobby channel'))
.catch(reason => console.error('Lobby join failed', reason))

const initialState = {
  lobbyChannel,
}

export default function reducer(state = initialState, action = {}) {
  return state
}
