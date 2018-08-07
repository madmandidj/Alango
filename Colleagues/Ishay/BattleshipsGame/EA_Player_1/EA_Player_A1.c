#include <stdlib.h>
#include "BSPlayer.h"
/*Globals and Function Declarations*/
/*********************************************/
/*
#define BS_BOARD_SIZE 10 
typedef int BS_Board_t[BS_BOARD_SIZE][BS_BOARD_SIZE]; 
*/
static const unsigned int s_ship_sizes[] = { 0,2,3,3,4,5 };
static BS_Board_t s_attackBoard = { 0 };
static int s_myAttackResult[2] = { 0 };
void staging_cb(BS_Board_t* p_board);
void turn_cb(BS_Coortinates_t* p_coordinates);
void status_cb(BS_HitStatus_t hit_status);
/*********************************************/
static s_numOfShips = 5;
static void InitAttackBoard(BS_Board_t* _p_board);
static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* _p_board, BS_ShipClass_t _ship);
static void PlaceAllShips(BS_Board_t* _p_board);
static BS_Coortinates_t CalculateAttackCoordinate();


void staging_cb(BS_Board_t* _p_board) 
{
    
    // BS_ShipClass_t curShip = 0;

    InitAttackBoard(_p_board);
    PlaceAllShips(_p_board);
    // for (curShip = 1; curShip <= s_numOfShips; ++curShip)
    // {
    //     while(BS_BE_OK != bsBoardError)
    //     {
    //         bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;
    //         curShipCoordinate = CalculateShipPlacement(_p_board, curShip);
    //         bsBoardError = BS_Board_PlaceShip(_p_board, curShip, &curShipCoordinate);
    //     }
    // }
}


void turn_cb(BS_Coortinates_t* _p_coordinates)
{
    BS_Coortinates_t myCoord = {0};
    
    myCoord = CalculateAttackCoordinate();

    *_p_coordinates = myCoord;
}

void status_cb(BS_HitStatus_t _status)
{
    if (status)
		board[last_guess[1]][last_guess[0]] = 1;
	else
		board[last_guess[1]][last_guess[0]] = -1;
}

/*********************************************/


static void InitAttackBoard()
{
    size_t xPos;
    size_t yPos;

    for(xPos = 0; xPos < BS_BOARD_SIZE; ++xPos)
    {
        for(yPos = 0; ypos < BS_BOARD_SIZE; ++yPos)
        {
            s_attackBoard[x][y] = 0;
        }
    }
}

static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* _p_board, BS_ShipClass_t _ship)
{
    static size_t curShip = 0;
    BS_Coortinates_t shipStart;
    BS_Coortinates_t shipEnd;
    BS_ShipCoordinates_t shipCoord;
    // while(1)
    // {
    //     shipStart.x = rand() % 10;
    //     shipStart.y = rand() % 10;
        
    //     yPos = rand() % 10;
    //     boardCoord[]
    // }
    ++curShip;
    shipStart.x = curShip;
    shipStart.y = 0;
    shipEnd.x = curShip;
    shipEnd.y = s_ship_sizes[curShip];
    shipCoord.ship_start = shipStart;
    shipCoord.ship_end = shipEnd;
    return shipCoord;
}

static void PlaceAllShips(BS_Board_t* _p_board);
{
    BS_ShipClass_t curShip = 0;
    BS_ShipCoordinates_t curShipCoordinate;
    BS_BoardError_t bsBoardError;

    for (curShip = 1; curShip <= s_numOfShips; ++curShip)
    {
        while(BS_BE_OK != bsBoardError)
        {
            bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;
            curShipCoordinate = CalculateShipPlacement(_p_board, curShip);
            bsBoardError = BS_Board_PlaceShip(_p_board, curShip, &curShipCoordinate);
        }
    }
}

static BS_Coortinates_t CalculateAttackCoordinate()
{
    BS_Coortinates_t attackCoord;
    isCoordValid = 0;

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







