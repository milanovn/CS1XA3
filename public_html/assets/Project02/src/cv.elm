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
challenges that help me grow""",co = """Learned theoretical concepts regarding comptuers with topics ranging from numbers, graphics, sound bytes, and much more! Aswell as exposure to
to Haskell - A functional programming language.""",co2="""A course that works with Python3 3 to introduce basic algorithms and provides practice and knowledge about Python.""",co3="""Introduction to
many applicable topics including Bash scripting, working with Unix environments, Server & Client-Side Coding, and Version-Control with Git."""}


view : Model -> Html Msg
view model = div [] [ stylesheet
                    , header [] [h1 [] [text "Nikola Milanovic"]
                                ,section [] [p [] [text model.intro],p [] [text "Email: milanovn@mcmaster.ca"]]
                                ,a [href "https://github.com/milanovn"] [img [src "img/Git2.png",height 30] []]
                                ,a [href "https://www.linkedin.com/in/milanovic-n?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BOQ1AoCDoQ1SAk%2BSYijtAYQ%3D%3D"] [img [src "img/Linkind.png",height 30] []]
                                ]
                    , main_ [] [section [] [h3 [] [text "Programming Courses Taken"]
                               , article [class "course"] [div [class "title"] [h4 [] [text "Introduction to Computational Thinking"]]
                                                          ,div [class "description"] [p [] [text model.co]]]
                               , article [class "course"] [div [class "title"] [h4 [] [text "Introduction to Programming"]]
                                                          ,div [class "description"] [p [] [text model.co2]]]
                               , article [class "course"] [div [class "title"] [h4 [] [text " Computer Science Practice and Experience: Basic Concepts"]]
                                                          ,div [class "description"] [p [] [text model.co3]]]
                                           ]
                              , section [] [h3 [] [text "Skills"]
                              , h4 [] [text "Basic Knowledge"]
                              , ul [] [li [] [text "Python"]
                                      ,li [] [text "Haskell"]
                                      ,li [] [text "Html & JavaScript"]
                                      ,li [] [text "Bash scripting"]
                                      ,li [] [text "Elm"]
                                      ]
                                           ]
                              , section [] [h3 [] [text "Education"]
                              , article [class "school"] [span [] [text "2018-2022   "]
                              , strong [] [text "McMaster University "]]
                              , div [class "school"] [text "Bachelor of Computer Science"]
                                           ]

                               ]
                    ]
update : Msg -> Model -> Model
update msg model =
  case msg of
    N -> model
