module CorePage.ViewUtils where

import CorePage.Model exposing (..)
import CorePage.Update exposing (actionsAddress)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Encode exposing (string)
import Json.Decode as Json
import Routes
import Signal

triggerAction : Action -> String -> List Attribute
triggerAction action path =
  [ href path
  , onWithOptions
      "click"
      { stopPropagation = True, preventDefault = True }
      Json.value
      (\_ -> Signal.message actionsAddress action)
  ]

renderUserWithAvatar : String -> String -> Html
renderUserWithAvatar username avatarUrl =
  let
    userLink = "https://github.com/" ++ username
  in
    a
      [ href userLink ]
      [ img
        [ src avatarUrl
        , class "avatarImg"] []
      , text ("@" ++ username)
      ]

renderLabel : Label -> Html
renderLabel label =
  button
    [ type' "button"
    , class "btn btn-primary btn-xs"
    ]
    [ text label.name ]

renderPagination : Signal.Address Action -> Int -> Html
renderPagination address pages =
  let
    makePageItem page =
      li []
        [ a (triggerAction (LoadIssuesCommand page) (makePageLink page)) [ text (toString page) ]
        ]
  in
    nav []
      [ ul [class "pagination"] (
        [ li []
          [ a
            [ href (makePageLink 1), prop "aria-label" "Previous" ]
            [ span [prop "aria-hidden" "true"] [text "«"] ]
          ]
        ]
        ++
        List.map makePageItem [1..pages]
        ++
        [ li []
          [ a
            [ href (makePageLink pages), prop "aria-label" "Next" ]
            [ span [prop "aria-hidden" "true"] [text "»"] ]
          ]
        ])
      ]

prop : String -> String -> Html.Attribute
prop key value =
  property key (Json.Encode.string value)

propInt : String -> Int -> Html.Attribute
propInt key value =
  property key (Json.Encode.int value)

makeMainPageLink : String
makeMainPageLink = "/"

makePageLink : Int -> String
makePageLink pageNumber =
  Routes.encode (Routes.IssuesPage pageNumber)

makeCommentsLink : Int -> String
makeCommentsLink issueNumber =
  Routes.encode (Routes.CommentsPage issueNumber)
