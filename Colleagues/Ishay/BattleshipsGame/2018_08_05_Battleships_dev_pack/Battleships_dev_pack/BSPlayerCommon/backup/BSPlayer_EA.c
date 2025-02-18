#include <stdlib.h>
#include "BSPlayer.h"
/*Globals and Function Declarations*/
/*********************************************/
/*
#define BS_BOARD_SIZE 10
typedef int BS_Board_t[BS_BOARD_SIZE][BS_BOARD_SIZE];
*/
// void staging_cb(BS_Board_t* p_board);
// void turn_cb(BS_Coortinates_t* p_coordinates);
// void status_cb(BS_HitStatus_t hit_status);

static void InitAttackBoard();
static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship);
static void PlaceAllShips(BS_Board_t* p_board);
static BS_Coortinates_t CalculateAttackCoordinate();
static GetAttack

static const unsigned int s_ship_sizes[] = { 0,2,3,3,4,5 };
static BS_Board_t s_attackBoard = { 0 };
static int s_myAttackResult[2] = { 0 };
static s_numOfShips = 5;

static BS_Board_t s_checkerBoard = { 0 };



void staging_cb(BS_Board_t* p_board)
{
	InitAttackBoard();
	InitCheckerBoard();
	PlaceAllShips(p_board);
}


void turn_cb(BS_Coortinates_t* p_coordinates)
{
	BS_Coortinates_t myCoord = { 0 };
	myCoord = CalculateAttackCoordinate();
	p_coordinates->x = myCoord.x;
	p_coordinates->y = myCoord.y;
}

void status_cb(BS_HitStatus_t status)
{
	if (status)
		s_attackBoard[s_myAttackResult[1]][s_myAttackResult[0]] = 1;
	else
		s_attackBoard[s_myAttackResult[1]][s_myAttackResult[0]] = -1;
}

/*********************************************/


static void InitAttackBoard()
{
	size_t xPos;
	size_t yPos;

	for (xPos = 0; xPos < BS_BOARD_SIZE; ++xPos)
	{
		for (yPos = 0; yPos < BS_BOARD_SIZE; ++yPos)
		{
			s_attackBoard[xPos][yPos] = 0;
		}
	}
}

static void PlaceAllShips(BS_Board_t* p_board)
{
	BS_ShipClass_t curShip = 0;
	BS_ShipCoordinates_t curShipCoordinate;
	BS_BoardError_t bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;

	for (curShip = 1; curShip <= s_numOfShips; ++curShip)
	{
		while (BS_BE_OK != bsBoardError)
		{
			curShipCoordinate = CalculateShipPlacement(p_board, curShip);
			bsBoardError = BS_Board_PlaceShip(p_board, curShip, &curShipCoordinate);
		}
		bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;
	}
}

static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship)
{
	BS_ShipCoordinates_t shipCoord;
	shipCoord.ship_start.x = _ship;
	shipCoord.ship_start.y = 0;
	shipCoord.ship_end.x = _ship;
	shipCoord.ship_end.y = s_ship_sizes[_ship] - 1;
	return shipCoord;
}

static BS_Coortinates_t CalculateAttackCoordinate()
{
	BS_Coortinates_t attackCoord;
	unsigned int isCoordValid = 0;

	while (1)
	{
		attackCoord.x = rand() % 10;
		attackCoord.y = rand() % 10;
		if (s_attackBoard[attackCoord.x][attackCoord.y] != 0)
		{
			continue;
		}
		return attackCoord;
	}
}







