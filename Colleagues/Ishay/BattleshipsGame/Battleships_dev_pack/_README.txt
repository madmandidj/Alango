The Awesome Battleship Battlebot Challenge!
=============================================

Table of contents:
1. Rules of the game.
	a. Rules of the classic 'Battleship' game.
	b. Rules of the Awesome Battleship Battlebot Challenge.
2. The game engine.
	a. Responsibilities of the game engine.
	b. Anatomy of the game engine.
3. The Battlebot.
	a. Responsibilities of the Battlebot.
	b. Anatomy of the Battlebot.
4. Development package structure.
5. Release history and change log.
6. Future development (TODO list).

1. Rules of the game
--------------------
	a. Rules of the classic 'Battleship' game.
		'Battleship' is a 2 player, turn based board game played on 10x10 gridded boards.
		Each player's fleet of ships is place on the player's board.
		The locations of the fleets are concealed from the other player.
		Players alternate turns calling 'shots' at the other player's ships.
		The objective of the game is to destroy the opposing player's fleet.
		
		Classes of ships:
		The game uses a total of 5 ships per player. The ships differ in size and represent different ship classes.
		Destroyer  - 2 squares
		Submarine  - 3 squares
		Cruiser    - 3 squares
		Battleship - 4 squares
		Carrier    - 5 squares
		
		Rules of ship placement:
		Ships can be placed anywhere on the 10x10 board with the following constraints:
			- The entire fleet must be placed on the board before the start of the game.
			- Ships must be places horizontally or vertically but not diagonally.
			- Ships must fit into the board completely.
			- Ships must not overlap.
			- Ships cannot be moved after the game starts.
			
		Rules of 'shot' calling:
		The players take turns calling 'shots' trying to guess the location of the other player's fleet.
		The attacking player calls a 'shot' by specifying the board coordinates e.g. "D5" or "C9".
		The defending player must respond with either 'Hit', 'Miss' or 'Sunk' based on whether there was a ship at the specified coordinates and how many hits it already had.
		
		For example:
		Player 1 calls "D5".
		If there are no ships at "D5", player 2 responds with 'Miss'.
		If there is a ship at "D5" then:
			If this was the last square of the chip, player 2 responds with 'My <ship class> is sunk'.
			Otherwilse, player 2 simply responds with 'Hit' without specifying the ship class that was hit.
		
		The game ends when all of one of the player's ships are sunk.
		
	b. Rules of the Awesome Battleship Battlebot Challenge.
		'The Awesome Battleship Battlebot Challenge' is a software version of the classic 'Battleship' game with a twist: the goal is not to sink the opponents fleet but to write a peice of software - a Battlebot, that does it for you.
		The rules of the game remain the same with some obvious additions and alterations to make them software-friendly:
			- Since a single game can last as little as a few microseconds, the game is played over multiple rounds and arbitrary scores are awarded for hits, wins etc...
			  The winner is decided by the accumulated score at the end of the game set.
			- Negative scores are awarded for technical mistakes like illegal ship placement, illegal 'shots' etc...
			- Unlike the classic board game player, when frustrated, the bot is allowed to travel back in time and kill it's opponent. Negative points may be awarded for the attempt.
			
2. The game engine
------------------
	a. Responsibilities of the game engine.
		The game engine implements all of the game mechanics, controls the game flow, graphical display and activity logging.
		The battle bot is responsible for:
			- Initialization of all internal structures requited for game-play.
			- Initialization and handling of the graphical display.
			- Initialization and handling of the text logs.
			- Initialization and handling of the Battlebot DLLs.
			- Enforcing the rules of the game and keeping score.
			- Post game clean-up.
		
	b. Anatomy of the game engine. 	
		The game engine implementation is not exposed. Instead the game engine comes as a pre-compiled dynamic link library with 4 exported funtions: 3 core functions that implement internally the entire game flow and 1 helper function for proper ship placement.

		From BSEngine.h:

			- BS_EngineError_t BS_Engine_init(const char* DLL_P1, const char* DLL_P2)
			  This funtion initializes all the game mechanics and loads the 2 Battlebots from the specified DLL names.
			  
			- void BS_Engine_play(unsigned int rounds)
			  This function runs the game for the course of the specified amount of rounds.
			  
			- void BS_Engine_close(void)
			  This funtion is called at the end of the game to clean-up and release the Battlebot DLLs.
			  
		The entire game engine is implemented by simply calling these 3 functions in this exact order which greatly simplifies the Battlebot development process and removes the focus from the internal game mechanics.

		From BSEngine_board.h:

			- BS_BoardError_t BS_Board_PlaceShip(BS_Board_t* board, BS_ShipClass_t ship_class, BS_ShipCoordinates_t* coordinates)
			  This is a helper function that implements the proper placement of the ships on the game board.
			  It accepts the ship type and coordinates for placment and does the necessaty internal checks to make sure the desired placement is legal.
			  The function will return an error code either indicating successful ship placement or the reason for a failed attempt.
			
3. The Battlebot
----------------
The Battlebot is compiled into a dynamic link library that is explicitly linked to the game engine at runtime.
The Battlebot DLL must export 3 functions with a specific signature that implement the various responsibilities of the Battlebot at different stages of the game.

	a. Responsibilities of the Battlebot.
		The Battlebot should be designed to fully replace its human counterpart (evil laugh).
		The Battlebot shall be responsible for:
			- Correct and legal placement of the fleet during the 'Staging'.
			- Legal 'Shots' calling.
			- Keeping track of the board status.

	b. Anatomy of the Battlebot.
		The Battlebot consists (as far as the game engine is concerned) of 3 callback functions:
		
		From BSPlayer.h:
			- void staging_cb(BS_Board_t* p_board)
			  This function is called by the game engine during the 'Staging' of the game. The engine passes a pointer to a temporary game board to be filled by the Battlebot.
			  This function is responsible to populate the game board with the Battlebot's fleet.
			  If the board is not fully or legally populated when this function returns, the game engine will skip the rest of the game attributing a 'technical loss' to the offending Battlebot.
			  
			- void turn_cb(BS_Coortinates_t* p_coordinates)
			  This function is called by the game engine each turn of the game. The engine passes a pointer to a temporary coordinate structure to be filled by the Battlebot.
			  This function is responsible to 'guess' the coordinates of the opposing Battlebot's fleet.
			  If the returned coordinates are illegal (out of bounds), the game engine will skip the rest of the game attributing a 'technical loss' to the offending Battlebot.
			  
			- void status_cb(BS_HitStatus_t hit_status)
			  This function is called by the game engine as a response to the coordinates passed with the 'turn_cb' function.
			  The engine passes the 'hit status' for the last guessed coordinates (hit / miss / sunk).
			  This funtion is responsible for keeping track of the board status for future decision making.
			  
4. Development package structure
------------------------------------
The development package comes as a Visual Studio multi-project solution. All the projects are configured to compile and run 'out-of-the-box' using VS2017 on MS Windows 10.
The package is complete with the pre-compiled game engine libraries and a sample implementation of a Battlebot.

Battleships\			- The 'main' project folder.
	Battleships.c		- Holds the application entry point and implements the 'main' function. Nothing to do here...
	BSEngine.had		- The game engine API.
	
BSPlayerCommon\			- Holds the sample Battlebot implementation.
	BSPlayer.h			- The Battlebot API.
	BSPlayer.c			- Ugly, pseudo-random, brute force implementation of a Battlebot. Better not use that, like, for realz.
	BSEngine_board.h	- The game board API.
	
BSPlayer1\				- Holds the sample Battlebot project files.
BSPlayer2\				- An 'alias' for BSPlayer1. Both projects use the same sources to build 2 differently named targets. Purely for the convenience of building both players at the same time.

5. Release history and change log
---------------------------------
2018-07-31	- Initial release.

6. Future development (TODO list)
---------------------------------
- Implement CLI argument parser to specify player DLL names, number of rounds, display on / off / rate, text log on / off.
- Implement graphic display rate control mechanism.
- Port the whole thing to linux and mac.