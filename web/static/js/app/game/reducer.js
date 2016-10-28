import Constants from './constants'

const initialState = {
  game: null,
  gameChannel: null,
  messages: [],
  readyForWar: false,
  gameOver: false,
  winnerId: null,
  currentTurn: null,
  error: null,
}

function readyForWar(game) {
  console.log('readyForWar', game)
  return game.board && game.board.ready
}

function currentTurn(game) {
  if (!readyForWar(game)) return null;

  const lastTurn = game.turns[0]

  if (lastTurn == undefined) {
    return game.attacker
  }

  return [game.attacker, game.defender].find(player_id => player_id != lastTurn.player_id)
}

export default function reducer(state = initialState, action = {}) {
  let game
  switch (action.type) {
    case Constants.GAME_SET_CHANNEL:
      return { ...state, gameChannel: action.channel }

    case Constants.GAME_SET_GAME:
      game = { ...state.game, ...action.game }

      return {
        ...state,
        game,
        readyForWar: readyForWar(game),
        currentTurn: currentTurn(game),
        error: null
      }

    case Constants.GAME_ADD_MESSAGE:
      // TODO implement GAME_ADD_MESSAGE
      return state

    case Constants.GAME_PLAYER_JOINED:
      game = state.game
      const { playerId } = action

      if (game.attacker != null && game.attacker != playerId) {
        game.defender = playerId
      }

      return { ...state, game }

    default:
      return state
  }
}
