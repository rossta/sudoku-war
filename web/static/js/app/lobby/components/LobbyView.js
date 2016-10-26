import React from 'react'

export default function LobbyView({ children }) {
  return (
    <div>
      <header className="lobby-welcome">
        <h1>Welcome to Sudoku War</h1>
        <h2>Let's play!</h2>
      </header>

      {children}
    </div>
  )
}
