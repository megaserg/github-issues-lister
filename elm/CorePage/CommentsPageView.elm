module CorePage.CommentsPageView where

import CorePage.Model exposing (..)
import CorePage.ViewUtils exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown exposing (..)
import Routes

renderCommentsPage : Signal.Address Action -> Issue -> (List Comment) -> Html
renderCommentsPage address issue comments =
  let
    number = toString issue.number
    title = issue.title
    body = Markdown.toHtml (issue.body |> Maybe.withDefault "")
    username = issue.authorName
    avatarUrl = issue.authorAvatarUrl
  in
    div [class "container"] (
      [ div [class "row"]
        [ div [class "col-xs-12"]
          [ a (Routes.clickTo makeMainPageLink) [ text "back to main page" ] ]
        ]
      , div [class "row"]
        [ div [class "col-xs-2"] [ renderUserWithAvatar username avatarUrl ]
        , div [class "col-xs-7"]
          [ h5 [] [text ("#" ++ number ++ ": " ++ title)]
          , button
            [ type' "button"
            , class "btn btn-primary btn-xs"
            ]
            [ text issue.state ]
          ]
        ]
      , div [class "row"]
        [ div [class "col-xs-12"] (List.map renderLabel issue.labels) ]
      , div [class "row"]
        [ div [class "col-xs-12"] [ body ] ]
      ]
      ++
      (List.map renderComment comments)
    )

renderComment : Comment -> Html
renderComment comment =
  let
    commentBody = Markdown.toHtml comment.body
    username = comment.authorName
    avatarUrl = comment.authorAvatarUrl
  in
    div [class "row commentDiv"]
      [ div [class "row"]
        [ div [class "col-xs-2"] [ renderUserWithAvatar username avatarUrl ] ]
      , div [class "row"]
        [ div [class "col-xs-12"] [ commentBody ] ]
      ]
