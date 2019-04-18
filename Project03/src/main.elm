import Browser
import Http exposing (..)
import Json.Encode as JEncode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
main = Browser.sandbox{init=init,update=update,view=view}

type alias Model = {username:String,password:String}

type Msg = UpdateName String
          |UpdatePassword String
          |GotText (Result Http.Error String)

init : Model
init = {username="",password=""}

update : Msg -> Model -> Model
update msg model = case msg of
                        UpdateName givenName -> {model|username=givenName}
                        UpdatePassword givenPassword -> {model|password=givenPassword}
                        GotText error -> model

view : Model -> Html Msg
view model = div [] [h1 [] [text "Welcome to the Madhouse Casino!"]
                    ,img [src "xqcM.png"] []
                    ,p [] [text "Currently our games available include roullete."]
                    ,h2 [] [text "Rules for Roulette:"]
                    ,p [] [text "This roulette game does not include numbers, simply place your bet on either black, red or green. Red and black will double your bet and green will quadruple your bet."]
                    ,h3 [] [text "Login to have fun!"]
                    ,input [placeholder "Username", value model.username, onInput UpdateName] [], input [placeholder "Password", value model.password, onInput UpdatePassword] [], button [] [text "Submit"]
                    ,button [] [text "Create User"]
                    ,h4 [] [text ("DEBUG: " ++ model.username ++ "      " ++ model.password)]
                    ]

performPost model = Http.post {url = ""
                              ,body=Http.jsonBody (loginCredentials model)
                              ,expect = Http.expectString GotText}

loginCredentials : Model -> JEncode.Value
loginCredentials model = JEncode.object [("username", JEncode.string model.username),("password", JEncode.string model.password)]

