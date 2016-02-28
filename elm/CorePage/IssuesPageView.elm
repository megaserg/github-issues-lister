module CorePage.IssuesPageView where

import CorePage.Model exposing (..)
import CorePage.ViewUtils exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown exposing (..)
import String exposing (..)


renderIssuesPage : Signal.Address Action -> Int -> (List Issue) -> Html
renderIssuesPage address pageNumber issues =
  div [class "container"] (
    [ h1 [] [ text ( "page " ++ (toString pageNumber) ) ] ]
    ++
    List.map (\issue -> renderIssue address issue) issues
  )

makeUserInput : Signal.Address Action -> String -> Html
makeUserInput address user =
  input
    [ placeholder "User"
    , value user
    , on "input" targetValue (Signal.message address << UserChanged)
    , class "userInput"
    ]
    []

makeRepoInput : Signal.Address Action -> String -> Html
makeRepoInput address repo =
  input
    [ placeholder "Repo"
    , value repo
    , on "input" targetValue (Signal.message address << RepoChanged)
    , class "repoInput"
    ]
    []

renderIssue : Signal.Address Action -> Issue -> Html
renderIssue address issue =
  let
    number = toString issue.number
    title = issue.title
    -- body = text "lol"
    body = Markdown.toHtml (left 140 (issue.body |> Maybe.withDefault ""))
    username = issue.authorName
    avatarUrl = issue.authorAvatarUrl
    commentCount = toString issue.commentCount
    commentsLink = makeCommentsLink issue.number
  in
    div [class "row issueDiv"]
      [ div [class "row"]
        [ div [class "col-xs-2", style [("text-align", "center")]] [ renderUserWithAvatar username avatarUrl ]
        , div [class "col-xs-10"] [ h5 [] [text ("#" ++ number ++ ": " ++ title)] ]
        ]
      , div [class "row"]
        [ div [class "col-xs-12"] (List.map renderLabel issue.labels) ]
      , div [class "row"]
        [ div [class "col-xs-9"] [ body ] ]
      , div [class "row"]
        [ div [class "col-xs-9"]
          [ a (triggerAction (LoadSingleIssueCommand issue.number) (makeCommentsLink issue.number)) [ text (commentCount ++ " comments") ] ]
        ]
      ]
