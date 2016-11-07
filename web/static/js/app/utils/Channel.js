import { Promise } from 'es6-promise'

function Channel(socket, route) {
  this.channel = socket.channel(route)
}

Channel.prototype.join = function(resolve, reject) {
  const channel = this.channel

  return new Promise((resolve, reject) => {
    channel.join()
    .receive('ok', resolve)
    .receive('error', reject)
  })
}

Channel.prototype.on = function(event, resolve, reject) {
  const channel = this.channel
  channel.on(event, resolve)
  channel.onError(reject)
}

Channel.prototype.push = function(event, payload, resolve, reject) {
  const channel = this.channel

  return new Promise((resolve, reject) => {
    channel.push(event, payload)
    .receive('ok', resolve)
    .receive('error', reject)
  })
}

export default Channel
