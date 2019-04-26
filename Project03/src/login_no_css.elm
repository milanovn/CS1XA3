import Browser
import Http exposing (..)
import Browser.Navigation
import Json.Encode as JEncode
import Json.Decode as JDecode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main = Browser.element{init=init,update=update,subscriptions=\_->Sub.none,view=view}

type alias Model = {username:String,password:String,error:String}

root = "http://mac1xa3.ca/e/milanovn/"

type Msg = UpdateName String
          |UpdatePassword String
          |CreateUser
          |GotCreateResponse (Result Http.Error String)
          |Login
          |LoginResponse (Result Http.Error String)

init : () -> (Model,Cmd Msg)
init _ = ({username="",password="",error=""},Cmd.none)

update : Msg -> Model -> (Model,Cmd Msg)
update msg model = case msg of
                        UpdateName givenName -> ({model|username=givenName},Cmd.none)
                        UpdatePassword givenPassword -> ({model|password=givenPassword},Cmd.none)
                        CreateUser -> (model,createUserPost model)
                        GotCreateResponse result -> case result of
                                                      Ok "Please provide a username" -> ({model|error="Username required."},Cmd.none)
                                                      Ok "Please provide a password" -> ({model|error="Password required."},Cmd.none)
                                                      Ok _ -> ({model|error="USER CREATED"},Cmd.none)
                                                      Err error -> (handleError model error, Cmd.none)
                        Login -> (model,loginUserPost model)
                        LoginResponse result -> case result of
                                                  Ok "Invalid login" -> ({model|error="Invalid login"},Cmd.none)
                                                  Ok "Authentication Failed" ->({model|error="Authentication Failed"},Cmd.none)
                                                  Ok "Success"               -> ({model|error="Successfully logged in"},Browser.Navigation.load ("https://mac1xa3.ca/e/milanovn/" ++ "static/game_menu.html"))
                                                  Ok _ -> ({model|error="ERROR"},Cmd.none)
                                                  Err error -> (handleError model error,Cmd.none)
view : Model -> Html Msg
view model = div [] [h1 [] [text "Welcome to the Madhouse Casino!"]
                    ,p [] [text "Currently our games available include roullete."]
                    ,h2 [] [text "Rules for Roulette:"]
                    ,p [] [text "This roulette game does not include numbers, simply place your bet on either black, red or green. Red and black will double your bet and green will quadruple your bet."]
                    ,h3 [] [text "Login to have fun!"]
                    ,input [placeholder "Username", value model.username, onInput UpdateName] [], input [placeholder "Password", value model.password, onInput UpdatePassword] [], button [onClick Login] [text "Submit"]
                    ,button [onClick CreateUser] [text "Create User"]
                    ,h4 [] [text ("DEBUG: " ++ model.username ++ "      " ++ model.password)]
                    ,h4 [] [text model.error]
                    ]
createUserPost : Model -> Cmd Msg
createUserPost model = Http.post {url = "https://mac1xa3.ca/e/milanovn/casinoapp/addUser/"
                              ,body=Http.jsonBody <| (userCredentials model)
                              ,expect = Http.expectString GotCreateResponse}
loginUserPost : Model -> Cmd Msg
loginUserPost model = Http.post{url = "https://mac1xa3.ca/e/milanovn/casinoapp/loginUser/"
                               ,body=Http.jsonBody <| (userCredentials model)
                               ,expect = Http.expectString LoginResponse}

userCredentials : Model -> JEncode.Value
userCredentials model = JEncode.object [("username", JEncode.string model.username),("password", JEncode.string model.password)]


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
