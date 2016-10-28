import { Socket } from 'phoenix'

const playerId = window.playerId;
const socket = new Socket("/socket", {
  params: {
    id: playerId,
  },
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) },
})

socket.connect()

export {
  socket,
  playerId
}
