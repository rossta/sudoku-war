import { push } from 'react-router-redux'

// import { setPlayer } from 'session'

export function newGame(channel) {
  return dispatch => {
    channel.push('new_game')
    .then(payload => dispatch(push(`/play/game/${payload.game_id}`)))
    .catch(reason => console.error('newGame action failed', reason))
  }
}
