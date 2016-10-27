import { push } from 'react-router-redux'

// import { setPlayer } from 'session'

export function newGame(channel) {
  return dispatch => {
    channel.push('new_game')
    .receive('ok', (payload) => {
      dispatch(push(`/play/game/${payload.game_id}`))
    })
  }
}
