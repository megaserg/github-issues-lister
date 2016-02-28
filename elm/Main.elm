module Main where

import Effects exposing (Never)
import RoutedModel
import Html exposing (..)
import Signal
import StartApp
import Task
import Update exposing (init, update, actions)
import View exposing (view)

port initialPath : String

app : StartApp.App RoutedModel.Model
app =
  StartApp.start
    { init = init initialPath
    , update = update
    , view = view
    , inputs = [ actions ]
    }

main : Signal Html.Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
