module CorePage.Update where

import API exposing (..)
import Routes
import Effects exposing (Effects, none)
import CorePage.Model exposing (..)

initialModel : String -> String -> Int -> Model
initialModel initialUser initialRepo initialPage =
  CorePage.Model.Model initialUser initialRepo (IssuesPageData initialPage []) []

init : String -> String -> Int -> (Model, Effects Action)
init user repo page =
  ( initialModel user repo page
  , fetchIssues user repo page
  )

actions : Signal Action
actions = mailbox.signal

actionsAddress : Signal.Address Action
actionsAddress = mailbox.address

{-| Private. -}
mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox NoOp

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    LoadIssuesCommand page ->
      (model, fetchIssues model.currentUser model.currentRepo page)
    IssueListLoaded pageNumber maybeIssues ->
      let
        issues = Maybe.withDefault [] maybeIssues
        newPageData = IssuesPageData pageNumber issues
      in
        ( Model model.currentUser model.currentRepo newPageData issues
        , Effects.map (\_ -> NoOp) (Routes.redirect (Routes.IssuesPage pageNumber))
        )
    LoadSingleIssueCommand issueNumber ->
      ( model,
        (Effects.batch
          [ API.fetchSingleIssue model.currentUser model.currentRepo issueNumber
          , API.fetchCommentsForIssue model.currentUser model.currentRepo issueNumber ]
        )
      )
    SingleIssueLoaded maybeIssue ->
      let
        issue = Maybe.withDefault emptyIssue maybeIssue
        comments =
          case model.currentPage of
            IssuesPageData _ _ -> []
            CommentsPageData _ currentComments -> currentComments
        newPageData = CommentsPageData issue comments
      in
        ( Model model.currentUser model.currentRepo newPageData model.issues
        , Effects.map (\_ -> NoOp) (Routes.redirect (Routes.CommentsPage issue.number))
        )
    CommentListLoaded issueNumber maybeComments ->
      let
        comments = Maybe.withDefault [] maybeComments
        issue =
          case model.currentPage of
            IssuesPageData _ _ -> emptyIssue
            CommentsPageData currentIssue _ -> currentIssue
        newPageData = CommentsPageData issue comments
        -- issue = List.filter (\issue -> issue.number == issueNumber) model.issues
        --   |> List.head
        --   |> Maybe.withDefault emptyIssue
      in
        ( Model model.currentUser model.currentRepo newPageData model.issues
        , Effects.map (\_ -> NoOp) (Routes.redirect (Routes.CommentsPage issueNumber))
        )
    _ ->
      (model, Effects.none)
