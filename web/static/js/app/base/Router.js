import React from 'react'
import { Router as ReactRouter } from 'react-router'

import routes from './routes'

export default function Router({ history }) {
  return (
    <ReactRouter history={history}>
      {routes}
    </ReactRouter>
  )
}
