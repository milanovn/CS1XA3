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
init _ = ({username="",points=0,error=""},requestInfo) --Request username and points (also error) from server on load.

--CSS stylesheet used for main_menu.
stylesheet = node "link" [attribute "rel" "stylesheet",
                          href "assets/menu.css"]
                          []

update : Msg -> Model -> (Model,Cmd Msg)
update msg model = case msg of
                        LoadRoullete -> (model,load "http://mac1xa3.ca/e/milanovn/static/roulette.html") --redirect user to roulette app.
                        InfoResponse result -> case result of
                                               Ok updatedModel -> (updatedModel,Cmd.none)
                                               Err error -> (handleError model error,Cmd.none)
                        Logout -> (model,logout)
                        LogoutResponse result -> case result of --If no error with logging out, the user will be re-directed to the login_menu.
                                          Ok "Successfully Logged Out" -> (model,load "http://mac1xa3.ca/e/milanovn/static/login_menu.html")
                                          Ok _                         -> (model,Cmd.none)
                                          Err error -> (model,Cmd.none)
view : Model -> Html Msg
view model = div [] [stylesheet
                    ,div [class "accordion"] [section [class "accordion-item"] [h1 [] [text "User:"], div [class "accordion-item-content"] [p [] [text model.username]]]
                                             ,section [class "accordion-item"] [h1 [] [text "Points:"],div [class "accordion-item-content"] [p [] [text (Debug.toString model.points)]]]
                                             ,section [class "accordion-item"] [h1 [] [text "Play:"],div [class "accordion-item-content"] [p [] [button [onClick LoadRoullete] [text "Roulette"]]]]
                                             ,section [class "accordion-item",onClick Logout] [h1 [] [text "Logout"]]
                                             ]
                    ]
requestInfo : Cmd Msg
requestInfo = Http.get{url="https://mac1xa3.ca/e/milanovn/casinoapp/requestPoints/",
                       expect = Http.expectJson InfoResponse modelDecoder}
logout : Cmd Msg
logout = Http.get{url="https://mac1xa3.ca/e/milanovn/casinoapp/logout/",
                       expect = Http.expectString LogoutResponse}
modelDecoder : JDecode.Decoder Model --Our model recieved from server has username, points, and error, this function decodes the json into an elm model.
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

