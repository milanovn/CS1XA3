## Installation:
**Elm installations**

 1. elm/json
 2. elm/http
 3. elm/random
 4. elm/url
 5. elm/MacCASOutreach/graphicsvg

**Download**
Download ["Project03" directory](https://github.com/milanovn/CS1XA3/tree/master/Project03) to your location of choice.
**Python Virtual Environment Installations**
See ["requirements.txt"](https://github.com/milanovn/CS1XA3/blob/master/Project03/requirements.txt) for virtual environment requirements.

## Structure and Usage:
This app consists of 3 (elm-generated) static html files named ***login_menu.hmtl*** ***game_menu.html*** and ***roulette.html***.

**App-Cycle**

 **1. login_menu.html** --> Communicates with the server database which uses the model "Player" in our [casinoapp/models.py](https://github.com/milanovn/CS1XA3/blob/master/Project03/python_env/django_project/casinoapp/models.py) file. From this state, the user has the option to create a user or sign in to an existing account.
 **2. game_menu.hmtl** --> Is the state entered when the user is successfully logged in. From this menu, it will display the **username,** **points,** a **play button,** and a **logout button**.
 **3. roulette.html** --> Is the actual game where the user has the option to place bets and win points!

**Roulette Functionality**
The 3 buttons at the top are used to **place bets** on the corresponding colour.

If the roulette wheel lands on:

 - Black/Red -> Points increase by bet amount.
 - Green -> points increase by **bet amount * 4** if bet placed on green.

*NOTE:* The minimum amount of points a player can have is 100, not 0. Meaning if the user is at 100 points and they bet for 100 and lose, they will **not** actually lose any points.

**Points System**
When the file roulette.html is loaded/refreshed, the **init** function calls a **"Cmd Msg"  requestInfo** that performs a Http.get to receive the user's points from the server.

Points get updated only **after** the spin is completed by waiting 7 seconds and calling the update function with the "Result" Msg **manually**.

	Result Msg --> Determines the win outcome, depending on what colour the bet was placed on. 
	Result Msg--> Calls the update function with the Msg **SyncPoints**
	SyncPoints Msg --> with the *updated* model, SyncPoints calls the sendUpdate function which performs a
	Http.post with the updated points to the server to ensure synchronicity with the database
