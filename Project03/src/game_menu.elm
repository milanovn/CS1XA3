import Browser
import Http exposing (..)
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (toString)
import Html.Events exposing (..)

main = Browser.element{init=init,update=update,subscriptions=\_->Sub.none,view=view}

type alias Model = {username:String, points:Int}

type Msg = LoadRoullete
init : () -> (Model,Cmd Msg)
init _ = ({username="Nikola",points=1000},Cmd.none)

update : Msg -> Model -> (Model,Cmd Msg)
update msg model = case msg of
                        LoadRoullete -> (model,load "http://mac1xa3.ca/e/milanovn/static/roulette.html")
view : Model -> Html Msg
view model = div [] [h1 [] [text ("Welcome " ++ model.username ++ ". You have " ++ toString(model.points) ++ " points.")]
                    ,h2 [] [text "Play Roulette"] , button [onClick LoadRoullete] [text "Play Roulette"]
                    ,h2 [] [text "Play Other Game"], button [onClick LoadRoullete] [text "Play Other Game"]
                    ]

