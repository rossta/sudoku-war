import React from 'react'
import { connect } from 'react-redux'

import { setDocumentTitle } from '../../utils'

class GameView extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props

    setDocumentTitle('Game Room')

    // dispatch(fetchGames(lobbyChannel))
  }

  render() {
    const { dispatch } = this.props

    return (
      <section className="container">
        <header>
          <h2>Let's play</h2>
        </header>
        <section className="columns large-9 small-12">
          <h3>Set up board</h3>
        </section>
        <section className="columns large-3 small-12">
          <h3>Chat room</h3>
        </section>
      </section>
    )
  }
}

const mapStateToProps = (state) => {
  return {...state.game}
}

export default connect(mapStateToProps)(GameView)
