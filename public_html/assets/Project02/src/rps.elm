import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
--import Animations exposing (..)
import Debug
import New_Animations exposing (..)
import Random
import RefinedStrat
-- import for rock, paper and scissors SVG images created in a seperate module.
main : AppWithTick () Model Msg
main =
  appWithTick Tick { init = init , update = update , view = view , subscriptions = subscriptions , onUrlRequest = MakeRequest , onUrlChange = UrlChange}

---Strategy implementation---------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------

type Msg
 = Tick Float GetKeyState
 | MakeRequest Browser.UrlRequest
 | UrlChange Url.Url
 | RockButton
 | PaperButton
 | ScissorButton
 | Cycle
 | GenerateRandom
 | GetRandom Int
--t is currently only used for DEBUG
type alias Model = {increment : Int,strat:Int,
                   user_shapes: List (Shape Msg),
                   show_scores : Shape Msg,
                   user_move:Int,opponent_move:Int,
                   pScore : Int, oScore :Int,
                   opponent_played : List (Int),player_played : List (Int), --Moveset of moves played --> used for strategies.
                   cycle_complete:Bool, --This is to make sure score gets updated AFTER cycle is complete.
                   buttons: List (Shape Msg), opp_shapes: List (Shape Msg),
                   cycle_shapes:Bool}

init : () -> Url.Url -> Key -> (Model, Cmd Msg)
init flags url key = ({increment=0,cycle_shapes=False,strat=4,
                     buttons=[rockButton RockButton Cycle GenerateRandom,paperButton PaperButton Cycle GenerateRandom,
                     scissorsButton ScissorButton Cycle GenerateRandom],
                     cycle_complete=True,
                     user_move=-1,opponent_move=-1,
                     opponent_played=[], player_played=[],
                     show_scores = scores (0,0),
                     pScore = 0, oScore = 0,
                     user_shapes=[],opp_shapes=[]}, Cmd.none)

view : Model -> {title: String, body : Collage Msg}
view model = {title="RPS Game",body = collage 500 500 (model.buttons ++ model.user_shapes ++ model.opp_shapes ++ [model.show_scores])}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Tick time getKeyState ->
        if model.cycle_shapes && model.increment/=200 then
          let
            i=model.increment
            cycle_time = cycles model.increment
          in
            if cycle_time == 1 then ({model | opp_shapes=[opp_scissors],user_shapes=[scissors],increment=i+1},Cmd.none)
            else if cycle_time == 0 then ({model | opp_shapes=[opp_paper],user_shapes=[paper],increment=i+1},Cmd.none)
            else ({model | opp_shapes=[opp_rock],user_shapes=[rock],increment=i+1},Cmd.none)
        else if model.cycle_shapes==True then --This is where the scores are processed
          let
            opponent=model.oScore
            player=model.pScore
            userPlay=model.user_move
            oppPlay=model.opponent_move
            updateTable=updateScore(opponent,player) oppPlay userPlay--Change these zero values to determine who wins.
          in
            ({model|cycle_shapes=False,show_scores = scores (updateTable),oScore=Tuple.first(updateTable),pScore=Tuple.second(updateTable)},Cmd.none) --State after cycle is complete. DEBUG add a function that compares and updates score rather than PlayOpponent Msg.
        else --This is where the animations are processed.
          let
            userPlay=model.user_move
            oppPlay=model.opponent_move
          in
            ({model | opp_shapes=displayMove oppPlay ,user_shapes=displayMove userPlay},Cmd.none) --Default state. DEBUG add final result of cycle instead of blank.

      MakeRequest req ->
          ( model, Cmd.none )

      UrlChange url ->
          ( model, Cmd.none )
--Need something better for choosing which strategy to play rather than just model.t currently.
      RockButton ->
        let
          current_played = model.player_played
          current_opponent_played = model.opponent_played --USED FOR DEBUG
          computer_move=RefinedStrat.chooseStrategy (current_opponent_played,current_played) model.strat
        in
          ({model | user_move=0,player_played = current_played ++ [0],opponent_move=computer_move,opponent_played=current_opponent_played ++ [computer_move]},Cmd.none) --0 = rock, 1= paper, 2 = scissors (Encoding for RPS)

      PaperButton ->
        let
          current_played = model.player_played
          current_opponent_played = model.opponent_played --USED FOR DEBUG
          computer_move=RefinedStrat.chooseStrategy (current_opponent_played,current_played) model.strat
        in
          ({model | user_move=1,player_played=current_played++[1],opponent_move=computer_move,opponent_played=current_opponent_played ++ [computer_move]},Cmd.none)

      ScissorButton ->
        let
          current_played = model.player_played
          current_opponent_played = model.opponent_played --USED FOR DEBUG
          computer_move=RefinedStrat.chooseStrategy (current_opponent_played,current_played) model.strat
        in
          ({model | user_move=2,player_played=current_played++[2],opponent_move=computer_move,opponent_played=current_opponent_played ++ [computer_move]},Cmd.none)

      Cycle ->
        ({model | cycle_shapes = True,increment=0},Cmd.none)
---------------------------------------------------------------------**RANDOM GENERATION**-----------------------------------------------------------------------------------------------------------------------------
      GenerateRandom ->
        (model,Random.generate GetRandom (Random.int 3 5))

      GetRandom randomNum ->
        ({model | strat=randomNum},Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

--Computer Objects for Opponent labeled opp_*
opp_scissors = o_scissors |> move (-400,0)
opp_rock = o_rock |> move (-400,0)
opp_paper = o_paper |> move (-400,0)

--Function to assist with cycle animation.
cycles : Int -> Int
cycles increment = if increment <=66 then -1
                   else if (increment >66 && increment <=133) then 0
                   else 1
updateScore : (Int,Int)->Int -> Int -> (Int,Int) --Starting score (opponent,player) -> Encodings for [Rock,Paper,Scissors] -> Returns tuple (opponent,player) incremented accordingly.
updateScore start_score opponent_move player_move =
  let
    opponentScore = Tuple.first start_score
    playerScore = Tuple.second start_score
  in
    if player_move==0 then  --Rock
      case opponent_move of
        3 -> (opponentScore,playerScore) --Rock = Tie
        4 -> (opponentScore+1,playerScore) --Opponent plays paper = Opponent wins
        5 -> (opponentScore,playerScore+1) --Opponent plays scissors = PlayerWins
        _ -> (opponentScore,playerScore)
   else if player_move==1 then --Paper
     case opponent_move of
       3 -> (opponentScore,playerScore+1) --Rock= Player Wins
       4 -> (opponentScore,playerScore) --Opponent plays paper = Tie
       5 -> (opponentScore+1,playerScore) --Opponent plays Scissors = Opponent wins
       _ -> (opponentScore,playerScore)
  else if player_move==2 then --Scissors
    case opponent_move of
      3 -> (opponentScore+1,playerScore) --Rock = Opponent wins
      4 -> (opponentScore,playerScore+1) --Opponent plays paper = player wins
      5 -> (opponentScore,playerScore) --Opponent plays scissors = Tie
      _ -> (opponentScore,playerScore)
  else --Case where opponent move and player move are (-1)
    (opponentScore,playerScore)

--Notes
displayMove : Int -> List (Shape Msg) --Encodings for displaying user and opponent plays at appropriate times after cycle.
displayMove choice = if choice==0 then [rock]
                     else if choice==1 then [paper]
                     else if choice==2 then [scissors]
                     else if choice==3 then [opp_rock]
                     else if choice==4 then [opp_paper]
                     else if choice==5 then [opp_scissors]
                     else []
displayZ z = group [text (String.fromInt z) |> size 14 |> filled red] |> move(0,60)

--Debug Functions --
showStrategy input = group [text ("STRAT:"++(String.fromInt input)) |> size 14 |> filled red] |> move(0,75)
displayPlayerM input = group [text ("PLAYER MOVES " ++ String.fromList (convertToChar input)) |> size 14 |> filled blue] |> move(-50,100)
displayComputerM input = group [text ("COMPUTER MOVES " ++ String.fromList (convertToChar input)) |> size 14 |> filled blue] |> move(-50,150)
convertToChar : List (Int) -> List (Char)
convertToChar list = case list of
                      [] -> []
                      (x::xs) -> (Char.fromCode (x + 48)) :: convertToChar xs
