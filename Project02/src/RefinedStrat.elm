module RefinedStrat exposing (..)

--chooseStrategy : (opponent_moves,player_moves) -> randomNumber -> (3 4 or 5) analogus to Rock Paper or Scissors
chooseStrategy : ((List Int),(List Int)) -> Int -> Int
chooseStrategy playedList random = let
                                      player = Tuple.second playedList
                                      computer = Tuple.first playedList
                                      number_of_moves = List.length player
                                   in
                                    if number_of_moves < 4 then chooseRandom random
                                    else
                                      if remainderBy 3 number_of_moves == 1 then prime computer random
                                      else oppositeLast player




chooseRandom : Int -> Int
chooseRandom random = random

oppositeLast : (List Int) -> Int
oppositeLast playerMoves = let recentMoves = List.reverse playerMoves
                           in case recentMoves of
                            [] -> -100 --This case will never be reached since we will only play this strategy after 4 moves have been played. (First four moves are random.)
                            (x::xs) -> case x of
                                        0 -> 4 --Player.Rock = Opponent.paper (4)
                                        1 -> 5 --Player.Paper = Opponent.scissors (5)
                                        2 -> 3 --Player.scissors = Opponent.rock (3)
                                        _ -> -100

prime : (List Int) -> Int -> Int
prime computerMoves random = let
                                l = List.length computerMoves
                             in
                                if isPrime l (List.range 2 (l-1)) then 4
                                else chooseRandom random

isPrime : Int -> List Int -> Bool --Helper for prime strategy
isPrime n list =
              case list of
                [] -> True
                (x::xs) -> if remainderBy x n == 0 then False
                           else isPrime n xs
