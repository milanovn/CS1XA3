import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Browser
import Browser.Navigation exposing (Key(..),load)
import Url
import Debug
import Random
import Http
import Json.Decode as JDecode
import String

main : AppWithTick () Model Msg
main =
  appWithTick Tick { init = init , update = update , view = view , subscriptions = subscriptions , onUrlRequest = MakeRequest , onUrlChange = UrlChange}

type Msg
 = Tick Float GetKeyState
 | MakeRequest Browser.UrlRequest
 | UrlChange Url.Url
 | Spin
 | Result
 | Black
 | Red
 | Green
 | Back
 | Increment Int
 | Decrement Int
 | GenerateRandom
 | GetRandom Float
 | GetPoints (Result Http.Error String)
 | DoNothing (Result Http.Error String)
 | SyncPoints

type alias Model = {rotate:Bool,rotateAmount:Float,time:Float,points:Int,betAmount:Int,random:Float,rootAngle:Int,betColor:Int,denyAnimations:Bool}

--On init the function requestInfo is called to retreive load data from server.
init : () -> Url.Url -> Key -> (Model, Cmd Msg)
init flags url key = ({rotate=False,rotateAmount=0,time=0.0,points=0,betAmount=0,random=0.0,rootAngle=0,betColor=0,denyAnimations=False},requestInfo)

--Routes to the url that sends the amount of points the user has (retrieved from database)
requestInfo :Cmd Msg
requestInfo = Http.get{url="https://mac1xa3.ca/e/milanovn/casinoapp/roulettePoints/"
                            ,expect=Http.expectString GetPoints}
--convertPoints is used for converting the String recieved from the server into an Int since we cannot have a Maybe Int.
convertPoints arg = case (String.toInt(arg)) of
                    Just a -> a
                    Nothing -> 0
--Performs a get to the url which takes the points and updates the database.
sendUpdate : Int -> Cmd Msg
sendUpdate points = Http.post{url="https://mac1xa3.ca/e/milanovn/casinoapp/updatePoints/",
                              body = Http.stringBody "application/x-www-form-urlencoded" ("points="++Debug.toString points),
                              expect=Http.expectString DoNothing}
--Note that 350 is the circle size.
view : Model -> {title: String, body : Collage Msg}
view model = {title="roulette",body = body model.rotateAmount 350 model.points model.betAmount} --On server create a custom url and view to retrieve points.

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Tick time getKeyState ->
        let start_rotate = model.rotate
        in if start_rotate then
          if model.time <= 5 then ({model|rotateAmount=model.time*100+model.random,time=model.time+0.03},Cmd.none)
          else if model.time >= 5 && model.time <= 7 then ({model|rotateAmount=model.time*100+model.random,time=model.time+0.009},Cmd.none) else (update Result ({model|time=0.0,rotate=False,denyAnimations=False,rootAngle= modBy 360 (round model.rotateAmount)}))
          else (model,Cmd.none)
--We want the wheel to spin faster at the start and then slower towards the end. This is done by increasing time by 0.03 first and then 0.009 later to slow it down.
--ONLY once the spin is complete (after 7 seconds) we want to determine the result and manually call the update funciton with the Result Msg.
      MakeRequest req ->
          ( model, Cmd.none )

      UrlChange url ->
          ( model, Cmd.none )
      DoNothing result -> (model,Cmd.none) --We don't care about a response when sending an update from the server because the client isn't recieving any info from the server.
      SyncPoints -> (model,sendUpdate model.points)
      GetPoints result -> case result of
                          Ok "Logged out" -> (model,Cmd.none)
                          Ok response -> ({model|points=convertPoints response},Cmd.none)
                          Err error -> (model,Cmd.none) --This message is called upon load with the init function, and we expect to recieve the points IF the user is logged in.
      Spin -> --We do not want to be able to spin the wheel when it is already in motion which is what model.denyAnimations determines.
        if model.denyAnimations then (model,Cmd.none) else ({model|rotate=True,time=0.0,denyAnimations=True},Cmd.none)
      Result -> --Calculates the result of the spin, depending on what colour the user chooses and what section the wheel stops on.
        case (colorLanded model.rootAngle) of
          0 -> if model.betColor==0 then (update SyncPoints {model|points=model.points+model.betAmount}) else (update SyncPoints {model|points=model.points-model.betAmount})
          1 -> if model.betColor==1 then (update SyncPoints {model|points=model.points+model.betAmount}) else (update SyncPoints {model|points=model.points-model.betAmount})
          2 -> if model.betColor==2 then (update SyncPoints {model|points=model.points+(model.betAmount*4)}) else (update SyncPoints {model|points=model.points-model.betAmount})
          _ -> (model,Cmd.none)
      Black ->
        ({model|betColor=0},Cmd.none)
      Red ->
        ({model|betColor=1},Cmd.none)
      Green ->
        ({model|betColor=2},Cmd.none)
      Back ->
        if model.denyAnimations then (model,Cmd.none) else (model,load "http://mac1xa3.ca/e/milanovn/static/game_menu.html")
      Increment amount -> let i = model.betAmount
                   in  if model.denyAnimations then (model,Cmd.none) else if  model.points<=100 then (model,Cmd.none) else if model.betAmount>=model.points then (model,Cmd.none) else ({model | betAmount = amount + i},Cmd.none)
      Decrement amount -> let i = model.betAmount
                   in if model.denyAnimations then (model,Cmd.none) else if model.betAmount<=0 then (model,Cmd.none) else ({model | betAmount = i-amount},Cmd.none)
      --Random
      GenerateRandom -> if model.denyAnimations then (model,Cmd.none) else (model,Random.generate GetRandom (Random.float 0 360))
      GetRandom randomFloat -> ({model |random=randomFloat},Cmd.none)

subscriptions model = Sub.none
--Note we rotated each point in body by 11.25 degrees so that our sections range from 0,22.5 instead of -11.25,11.25.
--Determines what color the spin lands on.
colorLanded : Int -> Int
colorLanded rootAngle = let argument = 90 - (modBy 90 rootAngle)
                        in if rootAngle+90>=247&&rootAngle+90<=270 then 2 else if argument >=(0)&&argument<=22 then 0 else if argument>22&&argument<=45 then 1 else if argument>45&&argument<=67 then 0 else if argument>67&&argument<=90 then 1 else 2

body ro crSize points betAmount = collage 1000 1000 [wedge crSize 0.0625 |> filled black |> rotate (degrees 0 + (degrees (ro+11.25))),wedge crSize 0.0625 |> filled red |> rotate (degrees 22.5 + (degrees (ro+11.25))),wedge crSize 0.0625 |> filled black |> rotate (degrees 45 + (degrees (ro+11.25)))
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 67.5 + (degrees (ro+11.25))),wedge crSize 0.0625 |> filled black |> rotate (degrees 90 + (degrees (ro+11.25)))
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 112.5 + (degrees (ro+11.25))),wedge crSize 0.0625 |> filled black |> rotate (degrees 135+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled red |> rotate (degrees 157.5+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled black |> rotate (degrees 180+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled red |> rotate (degrees 202.5+(degrees (ro+11.25)))
                         ,wedge crSize 0.0625 |> filled black |> rotate (degrees 225+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled red |> rotate (degrees 247.5+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled darkGreen |> rotate (degrees 270+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled red |> rotate (degrees 292.5+(degrees (ro+11.25))),wedge crSize 0.0625 |> filled black |> rotate (degrees 315+(degrees (ro+11.25)))
                         ,wedge crSize 0.0625 |> filled red |> rotate (degrees 337.5+(degrees (ro+11.25))),circle 10 |> filled black,openPolygon [(-25,crSize),(25,crSize),(0,300)] |> filled blue,rouletteButtons,group [rect 150 50 |> filled grey |> move(0,-400) |> addOutline (solid 3) black, text "Back" |> size 36 |> filled black |> move (-35,-405)] |> notifyTap Back
                         ,text ("Points: " ++ Debug.toString(points)) |> size 36 |> filled blue |> addOutline (solid 0.5) black |> move (200,340)
                         ,betButtons betAmount |> move (-125,390)
                         ]
--Group text and back rectangle together to fix bug.
rouletteButtons = group [rect 150 50 |> filled black |> move (0,-400) |>notifyTap Black |> notifyTap GenerateRandom |> notifyTap Spin, rect 150 50 |> filled red |> move (150,-400) |> notifyTap Red |> notifyTap GenerateRandom |> notifyTap Spin,rect 150 50 |> filled green |> move (300,-400) |>notifyTap Green |> notifyTap GenerateRandom |> notifyTap Spin] |> move (-160,850) |> addOutline (solid 3) black

betButtons betAmount = group [group [square 50 |> filled black |> addOutline (solid 3) red,line (0,-10)(0,10) |> outlined (solid 3) red,line (-10,0) (10,0) |> outlined (solid 3) red] |> notifyTap (Increment 100),
                                           text (Debug.toString betAmount) |> size 30 |> filled black |> addOutline (solid 0.5) red |> move (30,0),group [square 50 |> filled black |> addOutline (solid 3) red,line (-10,0) (10,0) |> outlined (solid 3) red,line (-10,0) (10,0) |> outlined (solid 3) red]|> move (250,0) |> notifyTap (Decrement 100)]

