import Html exposing (..)
import Html.Attributes exposing (..)
import Browser


stylesheet = node "link" [attribute "rel" "stylesheet",
                          href "style.css"]
                          []
main =
  Browser.sandbox {init =init, update=update, view=view}

type alias Model = {intro : String, co : String, co2 : String, co3 : String}
type Msg = N

init : Model
init = {intro = """Hello!! My name is Nikola Milanovic and I am a first year CS-Student. I am constantly looking for new oppourtunities and
challenges that help me grow""",co = "Course 1",co2="Course2",co3="Course3"}


view : Model -> Html Msg
view model = div [] [ stylesheet
                    , header [] [h1 [] [text "Nikola Milanovic"]
                                ,section [] [p [] [text model.intro],p [] [text "Email: milanovn@mcmaster.ca"]]
                                ,a [href "https://github.com/milanovn"] [img [src "img/Git2.png",height 30] []]
                                ,a [href "https://github.com/milanovn"] [img [src "img/Linkind.png",height 30] []]
                                ]
                    , main_ [] [section [] [h3 [] [text "Courses Taken"]
                               , article [class "course"] [div [class "title"] [h4 [] [text "Introduction to Computational Thinking"]]
                                                          ,div [class "description"] [p [] [text model.co]]]
                               , article [class "course"] [div [class "title"] [h4 [] [text "Introduction to Programming"]]
                                                          ,div [class "description"] [p [] [text model.co2]]]
                               , article [class "course"] [div [class "title"] [h4 [] [text " Computer Science Practice and Experience: Basic Concepts"]]
                                                          ,div [class "description"] [p [] [text model.co3]]]
                                           ]
                              , section [] [h3 [] [text "Skills"]]
                              , section [] [h3 [] [text "Education"]]

                               ]
                    ]
update : Msg -> Model -> Model
update msg model =
  case msg of
    N -> model
