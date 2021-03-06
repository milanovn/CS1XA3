import Browser
import Http exposing (..)
import Browser.Navigation exposing (load)
import Html exposing (..)
import Json.Decode as JDecode
import Html.Attributes exposing (..)
import Debug exposing (toString)
import Html.Events exposing (..)

main = Browser.element{init=init,update=update,subscriptions=\_->Sub.none,view=view}

type alias Model = {username:String, points:Int,error:String}

type Msg = LoadRoullete
           | InfoResponse (Result Http.Error Model)
           | Logout
           | LogoutResponse(Result Http.Error String)
init : () -> (Model,Cmd Msg)
init _ = ({username="",points=0,error=""},requestInfo)

update : Msg -> Model -> (Model,Cmd Msg)
update msg model = case msg of
                        LoadRoullete -> (model,load "http://mac1xa3.ca/e/milanovn/static/roulette.html")
                        InfoResponse result -> case result of
                                               Ok updatedModel -> (updatedModel,Cmd.none)
                                               Err error -> (handleError model error,Cmd.none)
                        Logout -> (model,logout)
                        LogoutResponse result -> case result of
                                          Ok "Successfully Logged Out" -> (model,load "http://mac1xa3.ca/e/milanovn/static/login_menu.html")
                                          Ok _                         -> (model,Cmd.none)
                                          Err error -> (model,Cmd.none)
view : Model -> Html Msg
view model = div [] [h1 [] [text ("Welcome " ++ model.username ++ ". You have " ++ toString(model.points) ++ " points.")]
                    ,h2 [] [text "Play Roulette"] , button [onClick LoadRoullete] [text "Play Roulette"]
                    ,h2 [] [text "Play Other Game"], button [onClick LoadRoullete] [text "Play Other Game"]
                    ,button [onClick Logout] [text "Logout"]
                    ]
requestInfo : Cmd Msg
requestInfo = Http.get{url="https://mac1xa3.ca/e/milanovn/casinoapp/requestPoints/",
                       expect = Http.expectJson InfoResponse modelDecoder}
logout : Cmd Msg
logout = Http.get{url="https://mac1xa3.ca/e/milanovn/casinoapp/logout/",
                       expect = Http.expectString LogoutResponse}
modelDecoder : JDecode.Decoder Model
modelDecoder = JDecode.map3 Model
  (JDecode.field "username" JDecode.string)
  (JDecode.field "points" JDecode.int)
  (JDecode.field "error" JDecode.string)

handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "bad url: " ++ url }

        Http.Timeout ->
            { model | error = "timeout" }

        Http.NetworkError ->
            { model | error = "network error" }

        Http.BadStatus i ->
            { model | error = "bad status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "bad body " ++ body }

