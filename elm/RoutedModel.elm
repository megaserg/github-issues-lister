module RoutedModel where

import CorePage.Model exposing (..)
import Routes exposing (Route)
import TransitRouter exposing (WithRoute)

type alias Model = WithRoute Route
  { coreModel : CorePage.Model.Model
  }

type Action =
  NoOp
  | CoreAction CorePage.Model.Action
  | RouterAction (TransitRouter.Action Route)
