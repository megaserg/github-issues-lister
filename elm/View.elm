module View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import TransitRouter
import RoutedModel exposing (..)
import Routes exposing (..)
import CorePage.IssuesPageView exposing (..)
import CorePage.CommentsPageView exposing (..)
import CorePage.Model exposing (PageData)
import CorePage.ViewUtils

view : Address Action -> Model -> Html
view address model =
  let
    coreAddress = forwardTo address CoreAction
  in
    div
      [ ]
      [ h1 [] [ text "Github issues lister" ]
      , div [class "row"]
        [ div [class "col-xs-3"] [ CorePage.IssuesPageView.makeUserInput coreAddress model.coreModel.currentUser ]
        , div [class "col-xs-3"] [ CorePage.IssuesPageView.makeRepoInput coreAddress model.coreModel.currentRepo ]
        , div [class "col-xs-6"] [ CorePage.ViewUtils.renderPagination coreAddress 10 ]
        ]
      , div
          [ class "content"
          -- , style (TransitStyle.fadeSlideLeft 100 (TransitRouter.getTransition model))
          ]
          [ case (TransitRouter.getRoute model) of
              Home ->
                text <| "This is home"
              IssuesPage pageNumber ->
                -- text <| "This is issue page " ++ toString pageNumber
                case model.coreModel.currentPage of
                  CorePage.Model.IssuesPageData pageNumber issues ->
                    CorePage.IssuesPageView.renderIssuesPage coreAddress pageNumber issues
                  CorePage.Model.CommentsPageData issue comments ->
                    -- text <| "PATH IS FOR COMMENTS BUT MODEL IS FOR COMMENTS " ++ toString issue.number
                    CorePage.CommentsPageView.renderCommentsPage coreAddress issue comments
              CommentsPage issueNumber ->
                -- text <| "This is comments page for issue " ++ toString issueNumber
                case model.coreModel.currentPage of
                  CorePage.Model.IssuesPageData pageNumber issues ->
                    -- text <| "PATH IS FOR COMMENTS BUT MODEL IS FOR ISSUES " ++ toString pageNumber
                    CorePage.IssuesPageView.renderIssuesPage coreAddress pageNumber issues
                  CorePage.Model.CommentsPageData issue comments ->
                    CorePage.CommentsPageView.renderCommentsPage coreAddress issue comments
              EmptyRoute ->
                text <| "EMPTY"
                -- TaskPage.view (Signal.forwardTo address TaskPageAction) model.taskModel
                    -- DefaultPage page ->
                    --
                    -- IssuePage issue comments ->
                    --   renderIssuePage address model issue comments
          ]
      ]
