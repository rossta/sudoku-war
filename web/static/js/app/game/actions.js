import { push }   from 'react-router-redux';
import Constants  from './constants';
import { Channel } from '../utils'

export function joinGame(socket, playerId, gameId) {
  return dispatch => {
    const channel = new Channel(socket, `game:${gameId}`)

    channel.join()
    .then(() => dispatch(playerJoined(channel, playerId, gameId)))
    .catch(payload => dispatch(playerJoinedError(payload)))

    channel.on('game:message_sent', (payload) => {
      dispatch({
        type: Constants.GAME_ADD_MESSAGE,
        message: payload.message,
      })
    })

    channel.on('game:player_joined', (payload) => {
      dispatch({
        type: Constants.GAME_PLAYER_JOINED,
        playerId: payload.player_id,
        board: payload.board,
      })
    })

    channel.on('game:board_updated', (payload) => {
      dispatch({
        type: Constants.GAME_BOARD_UPDATED,
        board: payload.board,
      })
    })
  }
}

function playerJoined(channel, playerId, gameId) {
  return dispatch => {
    channel.push('game:get_data', {
      game_id: gameId,
      player_id: playerId
    })
    .then((payload) => {
      dispatch(setChannelAndGame(channel, payload.game))
    })
    .catch((reason) => {
      console.warn('Error with game:get_data', reason)
    })

    channel.push('game:joined')
    .then((payload) => console.log('game:joined', payload))
  }
}

function playerJoinedError(payload) {
  return dispatch => {
    console.warn("Could not join game", payload.reason)
    if (payload.reason === 'No more players allowed') {
      dispatch(push('/play/not_found'))
    }
    if (payload.reason === 'Game does not exist') {
      dispatch(push('/play/not_found'))
    }
  }
}

function setChannelAndGame(channel, game) {
  return dispatch => {
    dispatch({
      type: Constants.GAME_SET_CHANNEL,
      channel,
    });

    dispatch(setGame(game));
  };
}

export function setGame(game) {
  return {
    type: Constants.GAME_SET_GAME,
    game,
  };
}

export function selectCell(row, col) {
  return {
    type: Constants.GAME_SELECT_CELL,
    row,
    col
  }
}

export function enterValue(channel, key, value) {
  return dispatch => {
    channel.push('game:enter_value', {
      key,
      value
    })
    .then((payload) => {
      console.log("Successfully entered value!", key, value)
    })
  }
}
