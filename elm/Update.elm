module Update where

import Effects exposing (Effects, none)
import RoutedModel exposing (..)
import CorePage.Update exposing (..)
import Routes exposing (..)
import TransitRouter


initialModel : Model
initialModel =
  { transitRouter = TransitRouter.empty Home
  , coreModel = CorePage.Update.initialModel "npm" "npm" 1
  }

actions : Signal Action
actions =
  -- use mergeMany if you have other mailboxes or signals to feed into StartApp
  Signal.merge
    (Signal.map CoreAction CorePage.Update.actions)
    (Signal.map RouterAction TransitRouter.actions)

routerConfig : TransitRouter.Config Route Action Model
routerConfig =
  { mountRoute = mountRoute
  , getDurations = \_ _ _ -> (50, 200)
  , actionWrapper = RouterAction
  , routeDecoder = Routes.decode
  }

init : String -> (Model, Effects Action)
init path =
  TransitRouter.init routerConfig path initialModel

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    CoreAction subAction ->
      let
        (model', effects) = CorePage.Update.update subAction model.coreModel
      in
        ( { model | coreModel = model' }
        , Effects.map CoreAction effects )
    RouterAction routeAction ->
      TransitRouter.update routerConfig routeAction model

mountRoute : Route -> Route -> Model -> (Model, Effects Action)
mountRoute prevRoute route model =
  if route == prevRoute then (model, Effects.none)
  else
    let debugRoute = Debug.log "prev route" prevRoute in
    case route of
      -- in a typical SPA, you might have to trigger tasks when landing on a page,
      -- like an HTTP request to load specific data
      Home ->
        (model, Effects.none)
      IssuesPage pageNumber ->
        let
          core = model.coreModel
        in
          -- (model, Effects.map CoreAction (API.fetchIssues core.currentUser core.currentRepo pageNumber))
          (model, Effects.none)
      CommentsPage issueNumber ->
        let
          core = model.coreModel
        in
          -- (model,
          --   Effects.map CoreAction
          --     (Effects.batch
          --       [ API.fetchSingleIssue core.currentUser core.currentRepo issueNumber
          --       , API.fetchCommentsForIssue core.currentUser core.currentRepo issueNumber ]
          --     )
          -- )
          (model, Effects.none)
      EmptyRoute ->
        (model, Effects.none)
