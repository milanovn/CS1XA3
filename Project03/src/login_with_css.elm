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

--CSS stylesheet for login.
stylesheet = node "link" [attribute "rel" "stylesheet",
                          href "assets/login.css"]
                          []

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
                        UpdateName givenName -> ({model|username=givenName},Cmd.none) --This gets called onInput on text box and updates our model username.
                        UpdatePassword givenPassword -> ({model|password=givenPassword},Cmd.none) --Same as the above except for the model password.
                        CreateUser -> (model,createUserPost model) --Calls a CMD msg to send the model to the server and create a new user in the database.
                        GotCreateResponse result -> case result of --Error if input fields are invalid.
                                                      Ok "Please provide a username" -> ({model|error="Username required."},Cmd.none)
                                                      Ok "Please provide a password" -> ({model|error="Password required."},Cmd.none)
                                                      Ok _ -> ({model|error="USER CREATED"},Cmd.none)
                                                      Err error -> (handleError model error, Cmd.none)
                        Login -> (model,loginUserPost model) --Requests login to main menu.
                        LoginResponse result -> case result of
                                                  Ok "Invalid login" -> ({model|error="Invalid login"},Cmd.none)
                                                  Ok "Authentication Failed" ->({model|error="Authentication Failed"},Cmd.none)
                                                  Ok "Success"               -> ({model|error="Successfully logged in"},Browser.Navigation.load ("https://mac1xa3.ca/e/milanovn/" ++ "static/game_menu.html"))
                                                  Ok _ -> ({model|error="ERROR"},Cmd.none)
                                                  Err error -> (handleError model error,Cmd.none)
view : Model -> Html Msg
view model = div [] [stylesheet,
                     div [class "title"] [h1 [] [text "Welcome to our casino! Login/Create an account to get started."]],div [class "image"] [img [src "assets/poker.jpg"] []],
                     div [class "login"] [h2 [] [text "Sign in"],input [placeholder "Username",type_ "text",onInput UpdateName] [],input [type_ "password",placeholder "Password",onInput UpdatePassword] [],button [type_ "submit",onClick Login] [text "Sign in"]
                                         ,button [type_ "submit",onClick CreateUser] [text "Create user"],button [type_ "response"] [text model.error]]
                    ]

createUserPost : Model -> Cmd Msg --Encodes the model and sends it as a json body to the url which will then createa a user in the database if valid.
createUserPost model = Http.post {url = "https://mac1xa3.ca/e/milanovn/casinoapp/addUser/"
                              ,body=Http.jsonBody <| (userCredentials model)
                              ,expect = Http.expectString GotCreateResponse}

loginUserPost : Model -> Cmd Msg --Also encodes the model but this time requests a login  with the given inputs.
loginUserPost model = Http.post{url = "https://mac1xa3.ca/e/milanovn/casinoapp/loginUser/"
                               ,body=Http.jsonBody <| (userCredentials model)
                               ,expect = Http.expectString LoginResponse}

userCredentials : Model -> JEncode.Value --Encodes username and password in order to communicate with server.
userCredentials model = JEncode.object [("username", JEncode.string model.username),("password", JEncode.string model.password)]

--Error handling.
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

