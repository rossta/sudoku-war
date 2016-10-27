const initialState = {
  game: null,
  gameChannel: null,
  messages: [],
  readyForBattle: false,
  gameOver: false,
  winnerId: null,
  currentTurn: null,
  error: null,
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case 'SESSION_SET_PLAYER':
      return { ...state, gameChannel: action.channel }
    default:
      return state
  }
}
