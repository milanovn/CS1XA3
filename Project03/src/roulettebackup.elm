import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Browser
import Browser.Navigation exposing (Key(..),load)
import Url

main : AppWithTick () Model Msg
main =
  appWithTick Tick { init = init , update = update , view = view , subscriptions = subscriptions , onUrlRequest = MakeRequest , onUrlChange = UrlChange}

type Msg
 = Tick Float GetKeyState
 | MakeRequest Browser.UrlRequest
 | UrlChange Url.Url
 | Spin
 | Red
 | Black
 | Green
 | Back

type alias Model = {rotate:Bool,rotateAmount:Float,time:Float}

init : () -> Url.Url -> Key -> (Model, Cmd Msg)
init flags url key = ({rotate=False,rotateAmount=0,time=0.0}, Cmd.none)

view : Model -> {title: String, body : Collage Msg}
view model = {title="roulette",body = body model.rotateAmount 350}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Tick time getKeyState ->
        let start_rotate = model.rotate
        in if start_rotate then
          if model.time <= 5 then ({model|rotateAmount=model.time*1.5,time=model.time+0.03},Cmd.none)
          else if model.time >= 5 && model.time <= 7 then ({model|rotateAmount=model.time*1.5,time=model.time+0.009},Cmd.none) else ({model|time=0.0,rotate=False},Cmd.none)
          else (model,Cmd.none)

      MakeRequest req ->
          ( model, Cmd.none )

      UrlChange url ->
          ( model, Cmd.none )

      Spin ->
        ({model|rotate=True,time=0.0},Cmd.none)

      Red ->
        (model,Cmd.none)
      Black ->
        (model,Cmd.none)
      Green ->
        (model,Cmd.none)
      Back ->
        (model,load "http://mac1xa3.ca/e/milanovn/static/game_menu.html")

subscriptions model = Sub.none

body ro crSize = collage 1000 1000 [wedge crSize 0.0625 |> filled black |> rotate (degrees 0 + ro),wedge crSize 0.0625 |> filled red |> rotate (degrees 22.5 + ro),wedge crSize 0.0625 |> filled black |> rotate (degrees 45 + ro)
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 67.5 + ro),wedge crSize 0.0625 |> filled black |> rotate (degrees 90 + ro)
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 112.5 + ro),wedge crSize 0.0625 |> filled black |> rotate (degrees 135+ro),wedge crSize 0.0625 |> filled red |> rotate (degrees 157.5+ro),wedge crSize 0.0625 |> filled black |> rotate (degrees 180+ro),wedge crSize 0.0625 |> filled red |> rotate (degrees 202.5+ro)
                         ,wedge crSize 0.0625 |> filled black |> rotate (degrees 225+ro),wedge crSize 0.0625 |> filled red |> rotate (degrees 247.5+ro),wedge crSize 0.0625 |> filled darkGreen |> rotate (degrees 270+ro),wedge crSize 0.0625 |> filled red |> rotate (degrees 292.5+ro),wedge crSize 0.0625 |> filled black |> rotate (degrees 315+ro)
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 337.5+ro),circle 10 |> filled black,openPolygon [(-25,crSize),(25,crSize),(0,450)] |> filled white,rouletteButtons Red Black Green,rect 150 50 |> filled grey |> move(0,-400) |> notifyTap Back |> addOutline (solid 3) black, text "Back" |> size 36 |> filled black |> move (-35,-405)]
--Group text and back rectangle together to fix bug.
rouletteButtons redB blackB greenB= group [rect 150 50 |> filled black |> move (0,-400) |> notifyTap blackB, rect 150 50 |> filled red |> move (150,-400) |> notifyTap redB,rect 150 50 |> filled green |> move (300,-400) |> notifyTap greenB] |> move (-160,850) |> addOutline (solid 3) black

