import React from 'react'
import { connect } from 'react-redux'
import { Link } from 'react-router'

import { setDocumentTitle } from '../../utils'
import { joinGame } from '../actions'
import { Board } from '../components'

class GameView extends React.Component {
  componentDidMount() {
    setDocumentTitle('War Room')

    const { dispatch, playerId, socket } = this.props
    const gameId = this.props.params.id

    dispatch(joinGame(socket, playerId, gameId))
  }

  render() {
    const { dispatch, game, gameOver, gameChannel, playerId, currentTurn, selectedCell } = this.props;

    if (!game) return false

    const data = game.board

    return (
      <section className="container">
        <section className="row">
          <section className="columns large-6 small-12 board-container">
            <h2>Game</h2>
            <Board {...{dispatch, gameChannel, selectedCell, data}}/>
          </section>
          <section className="columns large-6 small-12">
            <header>
              <h2>Let's play</h2>
            </header>
            <h3>Set up board</h3>
            <p>Introduction</p>
            <section className="row">
              <h3>Chat room</h3>
            </section>
            <section className="row">
              <Link className="button" to="/play">Exit game</Link>
            </section>
          </section>
        </section>
      </section>
    )
  }
}

const mapStateToProps = (state) => {
  return {...state.game, ...state.session }
}

export default connect(mapStateToProps)(GameView)
