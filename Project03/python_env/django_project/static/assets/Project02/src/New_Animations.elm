--Module to create the RPS animations out of Graphics SVG if possible. If not might have to import another module.
module New_Animations exposing (..)
import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url

main : AppWithTick () Model Msg
main =
  appWithTick Tick { init = init , update = update , view = view , subscriptions = subscriptions , onUrlRequest = MakeRequest , onUrlChange = UrlChange}

type Msg
 = Tick Float GetKeyState
 | MakeRequest Browser.UrlRequest
 | UrlChange Url.Url
 | Debug --Do nothing (debug for button)

type alias Model = {size:Float}

init : () -> Url.Url -> Key -> (Model, Cmd Msg)
init flags url key = ({size=10.0}, Cmd.none)

view : Model -> {title: String, body : Collage Msg}
view model = {title="something",body = body}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Tick time getKeyState ->
          ( { model | size = model.size + 1 }, Cmd.none )

      MakeRequest req ->
          ( model, Cmd.none )

      UrlChange url ->
          ( model, Cmd.none )

      Debug ->
        (model,Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

body=collage 500 500 [rock,rockButton Debug Debug Debug,paperButton Debug Debug Debug,scissorsButton Debug Debug Debug,scores (0,0)]

--Animations as functions
scissors = group [circle 10 |> filled red |> move(-20,0) |> addOutline (solid 5) black
                                  ,circle 10 |> filled red |> move(20,0) |> addOutline (solid 5) black
                                  ,openPolygon [(-15,5),(10,100),(20,95),(-15,5)] |> filled red |> addOutline (solid 3) black
                                  ,openPolygon [(15,5),(-10,100),(-20,95),(15,5)] |> filled red |> addOutline (solid 3) black
                                  ,circle 3 |> filled black |> move(0,50) |> addOutline (solid 1) red
                                  ,circle 5 |> filled white |> move(-20,0) |> addOutline (solid 3) black
                                  ,circle 5 |> filled white |> move(20,0) |> addOutline (solid 3) black
                                  ] |> move (200,50)

rock = group [ openPolygon [(-50,0),(50,0),(45,30),(35,32),(33,50),(10,55),(5,68),(-30,55),(-40,33),(-47,31),(-50,0)] |> filled red |> addOutline (solid 4) black
                              , openPolygon [(-40,33),(-20,40),(-10,33)] |> filled red |> addOutline (solid 3) black
                              , openPolygon [(10,55),(0,45),(-5,50)] |> filled red |> addOutline (solid 3) black
                              , openPolygon [(-50,5),(-20,12),(-30,25)] |> filled red |> addOutline (solid 3) black
                              , openPolygon [(0,0),(12,20),(15,5)] |> filled red |> addOutline (solid 3) black
                              ] |> move(200,50)
paper = group [rect 68.75 110 |> filled red |> addOutline (solid 3) black
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(-30,45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(30,45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(30,-45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(-30,-45)
              ,line (-30,35) (30,35) |> outlined (solid 3) black
              ,line (-30,-35) (30,-35) |> outlined (solid 3) black
              ,text "PAPER" |> size 14 |> filled black |> addOutline (solid 0.6) black |> move (-20,0)
              ] |> move (200,70)

o_scissors = group [circle 10 |> filled blue |> move(-20,0) |> addOutline (solid 5) black
                                  ,circle 10 |> filled blue |> move(20,0) |> addOutline (solid 5) black
                                  ,openPolygon [(-15,5),(10,100),(20,95),(-15,5)] |> filled blue |> addOutline (solid 3) black
                                  ,openPolygon [(15,5),(-10,100),(-20,95),(15,5)] |> filled blue |> addOutline (solid 3) black
                                  ,circle 3 |> filled blue |> move(0,50) |> addOutline (solid 1.5) black
                                  ,circle 5 |> filled white |> move(-20,0) |> addOutline (solid 3) black
                                  ,circle 5 |> filled white |> move(20,0) |> addOutline (solid 3) black
                                  ] |> move (200,50)

o_rock = group [ openPolygon [(-50,0),(50,0),(45,30),(35,32),(33,50),(10,55),(5,68),(-30,55),(-40,33),(-47,31),(-50,0)] |> filled blue |> addOutline (solid 4) black
                              , openPolygon [(-40,33),(-20,40),(-10,33)] |> filled blue |> addOutline (solid 3) black
                              , openPolygon [(10,55),(0,45),(-5,50)] |> filled blue |> addOutline (solid 3) black
                              , openPolygon [(-50,5),(-20,12),(-30,25)] |> filled blue |> addOutline (solid 3) black
                              , openPolygon [(0,0),(12,20),(15,5)] |> filled blue |> addOutline (solid 3) black
                              ] |> move(200,50)
o_paper = group [rect 68.75 110 |> filled blue |> addOutline (solid 3) black
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(-30,45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(30,45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(30,-45)
              ,oval 10 20 |> filled grey |> addOutline (solid 3) black |> move(-30,-45)
              ,line (-30,35) (30,35) |> outlined (solid 3) black
              ,line (-30,-35) (30,-35) |> outlined (solid 3) black
              ,text "PAPER" |> size 14 |> filled blue |> addOutline (solid 0.6) black |> move (-20,0)
              ] |> move (200,70)
--Buttons
rockButton msg msg2 msg3 = group [rect 80 30 |> filled grey |> addOutline (solid 3) black, text "ROCK" |> size 14 |> filled black |> move(-18,0)] |> move (0,-10) |> notifyTap msg |> notifyTap msg2 |> notifyTap msg3

paperButton msg msg2 msg3 = group [rect 80 30 |> filled grey |> addOutline (solid 3) black, text "PAPER" |> size 14 |> filled black |> move(-18,0)] |> move(0,-40) |> notifyTap msg |> notifyTap msg2 |> notifyTap msg3

scissorsButton msg msg2 msg3 = group [rect 80 30 |> filled grey |> addOutline (solid 3) black, text "SCISSORS" |> size 14 |> filled black |> move(-30,0)] |> move(0,-70) |> notifyTap msg |> notifyTap msg2 |> notifyTap msg3

--Score (Currently text might update later.)
scores scoreTable = group [text ("Opponent "++String.fromInt(Tuple.first scoreTable) ++ " : You " ++ String.fromInt(Tuple.second scoreTable)) |> size 14 |> filled darkGreen |> addOutline (solid 0.2) black ] |> move(-57,180)
