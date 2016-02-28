module Decoders where

import Json.Decode as Json
import Json.Decode as Json exposing ((:=))
import CorePage.Model exposing (..)

issueListDecoder : Json.Decoder (List Issue)
issueListDecoder =
  Json.list issueDecoder

issueDecoder : Json.Decoder Issue
issueDecoder =
  Json.object8 Issue
    ("number" := Json.int)
    ("title" := Json.string)
    ("body" := nullOr Json.string)
    ("labels" := Json.list labelDecoder)
    ("state" := Json.string)
    (Json.at ["user", "login"] Json.string)
    (Json.at ["user", "avatar_url"] Json.string)
    ("comments" := Json.int)

nullOr : Json.Decoder a -> Json.Decoder (Maybe a)
nullOr decoder =
    Json.oneOf
    [ Json.null Nothing
    , Json.map Just decoder
    ]

labelDecoder : Json.Decoder Label
labelDecoder =
  Json.object3 Label
    ("url" := Json.string)
    ("name" := Json.string)
    ("color" := Json.string)

commentListDecoder: Json.Decoder (List Comment)
commentListDecoder =
  Json.list commentDecoder

commentDecoder : Json.Decoder Comment
commentDecoder =
  Json.object3 Comment
    ("body" := Json.string)
    (Json.at ["user", "login"] Json.string)
    (Json.at ["user", "avatar_url"] Json.string)
