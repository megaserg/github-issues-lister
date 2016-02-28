module API where

import Decoders exposing (..)
import Effects exposing (Effects, Never)
import Http
import CorePage.Model exposing (..)
import Task exposing (Task)

fetchIssues : String -> String -> Int -> Effects Action
fetchIssues user repo page =
  Http.get issueListDecoder (issueListUrl user repo page)
    |> Task.toMaybe
    |> Task.map (IssueListLoaded page)
    |> Effects.task

issueListUrl : String -> String -> Int -> String
issueListUrl user repo page =
  Http.url
    ("https://api.github.com" ++ "/repos/" ++ user ++ "/" ++ repo ++ "/issues")
    [ ("page", toString page)
    , ("per_page", "25")
    ]

fetchSingleIssue : String -> String -> Int -> Effects Action
fetchSingleIssue user repo number =
  Http.get issueDecoder (singleIssueUrl user repo number)
    |> Task.toMaybe
    |> Task.map SingleIssueLoaded
    |> Effects.task

singleIssueUrl : String -> String -> Int -> String
singleIssueUrl user repo number =
  "https://api.github.com" ++ "/repos/" ++ user ++ "/" ++ repo ++ "/issues/" ++ (toString number)

fetchCommentsForIssue : String -> String -> Int -> Effects Action
fetchCommentsForIssue user repo issueNumber =
  Http.get commentListDecoder (commentListUrl user repo issueNumber)
    |> Task.toMaybe
    |> Task.map (CommentListLoaded issueNumber)
    |> Effects.task

commentListUrl : String -> String -> Int -> String
commentListUrl user repo number =
  "https://api.github.com" ++ "/repos/" ++ user ++ "/" ++ repo ++ "/issues/" ++ (toString number) ++ "/comments"
