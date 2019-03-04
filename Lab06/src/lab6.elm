import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
  Browser.sandbox{init = init, update = update, view = view}

type alias Model = {box1 : String, seperator : String, box2 : String}
type Msg = Change1 String | Change2 String

init : Model
init = {box1 = "", seperator = " : ", box2=""}

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "string1", value model.box1, onInput Change1 ] [],
      input [placeholder "string2", value model.box2, onInput Change2] [],
      div [] [text (model.box1), text (model.seperator), text (model.box2)]
    ]

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change1 newContent ->
      {model | box1 = newContent}
    Change2 newContent ->
      {model | box2 = newContent}

