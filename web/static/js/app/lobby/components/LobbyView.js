import React from 'react'
import { connect } from 'react-redux'

import { setDocumentTitle } from '../../utils'

import NewGameButton from './NewGameButton'

class LobbyView extends React.Component {
  componentDidMount() {
    const { dispatch, lobbyChannel } = this.props

    setDocumentTitle('Lobby')

    // dispatch(fetchGames(lobbyChannel))
  }

  renderCurrentGames() {
    return []
  }

  render() {
    const { dispatch, lobbyChannel } = this.props

    return (
      <div>
        <header className="lobby-welcome">
          <h1>Welcome to Sudoku War</h1>
          <h2>Let's play!</h2>
        </header>

        <NewGameButton {...{dispatch, lobbyChannel}}>
          Start new game
        </NewGameButton>

        {::this.renderCurrentGames()}
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {...state.lobby}
}

export default connect(mapStateToProps)(LobbyView)
