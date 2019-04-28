**Accessible at: https://mac1xa3.ca/u/milanovn/project3.html**
**OR**
**https://mac1xa3.ca/e/milanovn/static/project3.html**
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

**Running on server**
To run this code successfully on a server, make sure you install requirements with **pip install -r requirements.txt** in the Project03 folder.

Navigate to **Project03/python_env/django_project/** and run the command **"python3 manage.py runserver localhost:[portnum]"** to get the Django Server running.

**Note** that the elm files used in production are **login_with_css.elm**, **main_menu_css.elm**, and **roulette.elm**. 

The elm files are **already converted into html** and placed in the **static directory.** However, should you wish to make changes to the elm files. You must navigate to **"Project03/"** and run the command **"elm make src/[filename]"**


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

*NOTE:* The minimum amount of points a player can have is 100, not 0. Meaning if the user is at 100 points and they bet 100 and lose, they will **not** actually lose any points.

**Points System**
When the file roulette.html is loaded/refreshed, the **init** function calls a **"Cmd Msg"  requestInfo** that performs a Http.get to receive the user's points from the server.

Points get updated only **after** the spin is completed by waiting 7 seconds and calling the update function with the "Result" Msg **manually**.

	Result Msg --> Determines the win outcome, depending on what colour the bet was placed on. 
	Result Msg--> Calls the update function with the Msg SyncPoints
	SyncPoints Msg --> with the updated model, SyncPoints calls the sendUpdate function which performs a
	Http.post with the updated points to the server to ensure synchronicity with the database

## Server admin:
If you wish to modify or add html files make sure you place them in the **Project03/python_env/django_env/static** directory.

	For testing purposes, note that upon installation,there is a user in the database with (username=admin and password=admin)

CSS files/background images are optional, but found in **Project03/python_env/django_env/static/assets** and are included by default.

## Open-Source Resources (References):

\*\*MODIFIED CSS used for **login_menu.html** borrowed from [here
](https://speckyboy.com/login-pages-html5-css/)

\*\* MODIFIED CSS used for **game_menu.html** borrowed from [here
](https://1stwebdesigner.com/css-accordion-menu-methods/)

**Background image** used for **login screen** downloaded from [here
](https://pixabay.com/photos/poker-game-play-gambling-luck-1564042)

## Documented features (main features only!)
**login_menu.html**

	createUserPost : Model -> Cmd Msg
		Sends a Http.post to the url https://(path)/casinoapp/addUser/ with the model as a jsonBody.
		Calls GotCreateResponse Msg --> If the username or password is empty, user will not be created. If the input is valid, the server will create a Player objects with username and password.

	loginUserPost: Model -> Cmd Msg
		Posts the same way as createUserPost, but to the url https://(path)/casinoapp/loginUser/ which will login the user with the given username and password.
	
		Calls LoginResponse Msg --> If the input is invalid or credentials are invalid, user will not be logged in, otherwise re-route to game_menu.html

**game_menu.html**
	\*\*Created from main_menu_css.elm
	

	On init: ()->(Model,Cmd Msg) call, the function requestInfo gets called.

	requestInfo: Cmd Msg --> performs a Http.get to the url https://(path)/casinoapp/logout/ and returns a model {username:String,points:Int,error:String} if the user is authenticated; replacing our default init model.

	Msg (LoadRoullete) --> This Msg gets called on button click and re-routes to roulette.html.

	logout : Cmd Msg --> performs a Http.get to the url https://(path)/casinoapp/logout/ which will log the user out and re-route to the static page login_menu.html

**roulette.html**

	sendUpdate: Int -> Cmd msg --> performs a Http.post to the url https://(path)/caisnoapp/updatePoints/ takes the current points and updates it on the server database. We do not want to change our model, so we call DoNothing to return (model,Cmd.none)

	Tick time getKeyState -> if model.rotate is true, start the spin. Only once the wheel is done spinning, enable animations and call update with Result Msg to determine outcome and send point update to server.

	**important variable (model.denyAnimations) --> This boolean value is used to ensure no event will be called if the wheel is already spinning, to ensure that the user cannot change their bet or re-spin the wheel while the wheel is spinning.

	**User cannot bet more points than they have and cannot bet bet less than 0.

	**Note that the minimum points a user can have is 100, to ensure the user is never left with 0 points.


