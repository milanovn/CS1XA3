import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import String

-- MAIN
main =
  Browser.element { init = init, update = update, subscriptions=\_ -> Sub.none, view = view }

-- MODEL
type alias Model =
  { name : String , password : String, postResponse : String, queryString : String}

init : () -> (Model,Cmd Msg)
init _ = ({name="",password="",postResponse="",queryString=""},Cmd.none)
root = "https://mac1xa3.ca/e/milanovn/"
-- UPDATE
type Msg
  = Name String
  | Password String
  | PostResponse (Result Http.Error String)
  | PostButton
  | OkButton

update : Msg -> Model -> (Model,Cmd Msg)
update msg model =
  case msg of
    Name name ->
      ({ model | name = name },Cmd.none)

    Password password ->
      ({ model | password = password},Cmd.none)

    PostResponse result ->
      case result of
        Ok val -> ({model | postResponse = val},Cmd.none)
        Err error -> (handleError model error,Cmd.none)

    OkButton -> ({model | queryString="name="++model.name++"&password="++model.password},Cmd.none)

    PostButton -> (model, performPost model.queryString)
   -- PostButton -> ({model | queryString = "name="++model.name++"&password="++model.password},performPost model.queryString)

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "text" "Password" model.password Password
    , button [Html.Events.onClick OkButton] [text "OK"]
    , button [Html.Events.onClick PostButton] [text "Perform POST"]
    , div [] [text ("Post Response: " ++ model.postResponse)]
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

handleError: Model -> Http.Error -> Model
handleError model error =
  case error of Http.BadUrl url -> {model | postResponse = "Error, bad url "++url}
                Http.Timeout -> {model | postResponse = "Timeout"}
                Http.NetworkError -> {model | postResponse = "Network Error"}
                Http.BadStatus status -> {model | postResponse = "Bad status. Status code: "++String.fromInt(status)}
                Http.BadBody body ->  {model | postResponse = "Bad Body "++body}

performPost : String -> Cmd Msg
performPost input = Http.post
              { url = root ++ "lab7/"
               ,body = Http.stringBody "application/x-www-form-urlencoded" input
               ,expect = Http.expectString PostResponse
              }
