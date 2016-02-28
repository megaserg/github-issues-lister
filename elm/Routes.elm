module Routes where

import Effects exposing (Effects)
import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import RouteParser exposing (..)
import TransitRouter

type Route
  = Home
  | IssuesPage Int
  | CommentsPage Int
  | EmptyRoute

routeParsers : List (Matcher Route)
routeParsers =
  [ static Home "/"
  , dyn1 IssuesPage "/page/" int ""
  , dyn1 CommentsPage "/issue/" int ""
  ]

decode : String -> Route
decode path =
  RouteParser.match routeParsers path
    |> Maybe.withDefault EmptyRoute

encode : Route -> String
encode route =
  case route of
    Home -> "/"
    IssuesPage pageNumber -> "/page/" ++ toString pageNumber
    CommentsPage issueNumber -> "/issue/" ++ toString issueNumber
    EmptyRoute -> ""

redirect : Route -> Effects ()
redirect route =
  encode route
    |> Signal.send TransitRouter.pushPathAddress
    |> Effects.task

clickTo : String -> List Attribute
clickTo path =
  [ href path
  , onWithOptions
      "click"
      { stopPropagation = True, preventDefault = True }
      Json.value
      (\_ -> Signal.message TransitRouter.pushPathAddress path)
  ]
