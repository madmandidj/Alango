#include <stdio.h>
#include <stdlib.h>
#ifdef __linux__ 
    #include <unistd.h>
#elif _WIN32
    #include<Windows.h>
#elif __APPLE__
    /*TODO*/
#endif
#include <math.h>
#include "BSPlayer.h"

/* #define BS_BOARD_SIZE 10                                    /* BSEngine_board.h */
/* typedef int BS_Board_t[BS_BOARD_SIZE][BS_BOARD_SIZE];       /* BSEngine_board.h */
#define NUM_OF_SEARCH_BLOCKS 25
#define SIDE_LENGTH_IN_BLOCKS 5 /* because 5 * 5 = 25 */
#define NUM_OF_COORDINATES ((BS_BOARD_SIZE * BS_BOARD_SIZE))
#define NUM_OF_COORD_PER_BLOCK ((NUM_OF_COORDINATES / NUM_OF_SEARCH_BLOCKS))
/*********************************************
TYPEDEFS AND ENUMS
*********************************************/
typedef struct 
{
    BS_Coortinates_t m_searchBlock[NUM_OF_COORD_PER_BLOCK/2][NUM_OF_COORD_PER_BLOCK/2];
}EA_SearchBlock;

typedef EA_SearchBlock EA_SearchBlockBoard[SIDE_LENGTH_IN_BLOCKS][SIDE_LENGTH_IN_BLOCKS];

typedef enum 
{
    SEARCH_ATTACK,
    DESTROY_ATTACK,
}AttackMode;
typedef enum
{
	EMPTY,
	EMPTYMISS,
	HITSHIP,
	SUNKSHIP,
} EA_Status;
typedef struct EA_StatusBoard
{
	EA_Status m_eaStatusBoard[BS_BOARD_SIZE][BS_BOARD_SIZE];
}EA_StatusBoard;
/*********************************************
STATIC FUNCTION DECLARATIONS
*********************************************/
static void InitAttackBoard();
static void InitSearchBoard();
static void PlaceAllShips(BS_Board_t* p_board);
static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship);
static BS_Coortinates_t CalculateAttackCoordinate();
static BS_HitStatus_t GetBCHitStatus(unsigned int _x, unsigned int _y);
// static EA_SearchBlock GetNextSearchBlock();
static BS_Coortinates_t GetNextSearchCoord();
static BS_Coortinates_t GetFirstHitCoordinateFound();
static BS_Coortinates_t GetNextDestroyCoord(BS_Coortinates_t _attackAndDestroyCoord);
void Sleep_Wrapper(unsigned int _sleepTimeSecs);
/*********************************************
STATIC GLOBALS INSTANTIATION
*********************************************/
static const unsigned int s_ship_sizes[] = {0,2,3,3,4,5};
//static BS_Board_t s_attackBoard = { 0 };
static EA_StatusBoard s_statusBoard;
static int s_myAttackResult[2] = { 0 };
static BS_Coortinates_t s_myAttackCoord;
static unsigned int s_numOfShips = 5;
static EA_SearchBlockBoard s_searchBoard = { 0 };
static unsigned int s_attackMode = 0;
static unsigned int s_currentSearchBlock = 0;
/*********************************************
API FUNCTIONS DEFINITIONS
*********************************************/
void staging_cb(BS_Board_t* p_board)
{
	InitAttackBoard();
	// InitSearchBoard();
	PlaceAllShips(p_board);
}

void turn_cb(BS_Coortinates_t* p_coordinates)
{
	BS_Coortinates_t myCoord = { 0 };
	myCoord = CalculateAttackCoordinate();
	s_myAttackCoord.x = myCoord.x;
	s_myAttackCoord.y = myCoord.y;
	p_coordinates->x = myCoord.x;
	p_coordinates->y = myCoord.y;
}



/*/
typedef enum {
	BS_HS_MISS,
	BS_HS_HIT,
	BS_HS_DESTROYER_SUNK,
	BS_HS_SUBMARINE_SUNK,
	BS_HS_CRUISER_SUNK,
	BS_HS_BATTLESHIP_SUNK,
	BS_HS_CARRIER_SUNK
} BS_HitStatus_t;
*/


void status_cb(BS_HitStatus_t status)
{
	unsigned int areAllShipsSunk = 0;
	BS_Coortinates_t coord;
	unsigned int curRow;

	switch (status)
	{
	case BS_HS_MISS:
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = EMPTYMISS;
		break;
	case BS_HS_HIT:
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = HITSHIP;
		break;
	default:
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = HITSHIP;
		break;
	}
}

/*********************************************
STATIC FUNCTIONS DEFINITIONS
*********************************************/
static void InitAttackBoard()
{
	size_t xPos;
	size_t yPos;

	for (xPos = 0; xPos < BS_BOARD_SIZE; ++xPos)
	{
		for (yPos = 0; yPos < BS_BOARD_SIZE; ++yPos)
		{
			s_statusBoard.m_eaStatusBoard[xPos][yPos] = EMPTY;
		}
	}
}

// static void InitSearchBoard()
// {
//     unsigned int curCol;
//     unsigned curRow;
//     unsigned int shouldStartSecondRow = 1;

//     for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
//     {
//         curRow = shouldStartSecondRow ? 0 : 1;
//         while (curRow < BS_BOARD_SIZE)
//         {
//             s_searchBoard[curCol][curRow] = (0 == (curRow % 2)) ? (shouldStartSecondRow ? 0 : 1) : (shouldStartSecondRow ? 1 : 0); 
//             ++curRow;
//         } 
//     }
// }

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
    BS_Coortinates_t attackAndDestroyCoord;
    //EA_SearchBlock searchBlock;
    unsigned int isAttackCoordValid = 0;

    switch (s_attackMode)
    {
        case SEARCH_ATTACK:
                // searchBlock = GetNextSearchBlock();
                attackCoord = GetNextSearchCoord();
            break;

        case DESTROY_ATTACK:
            while (!isAttackCoordValid)
            {
                attackAndDestroyCoord = GetFirstHitCoordinateFound();
				if (attackAndDestroyCoord.x > BS_BOARD_SIZE)
				{
					attackCoord = GetNextSearchCoord();
					break;
				}
                attackCoord = GetNextDestroyCoord(attackAndDestroyCoord);
            } 
            break;

        default:
            printf("\n\nI cannot play anything other than search and destroy. Mua ha ha. This game will self destruct in\n\n 5\n");

            Sleep_Wrapper(1);
            printf("4\n");
            Sleep_Wrapper(1);
            printf("3\n");
            Sleep_Wrapper(1);
            printf("2\n");
            Sleep_Wrapper(1);
            printf("1\n");
            Sleep_Wrapper(1);
            printf("KaBooM ! ! !\n");
            Sleep_Wrapper(1);
            exit(0);
    }

    return attackCoord;
}

// static EA_SearchBlock GetNextSearchBlock()
// {
//     EA_SearchBlock searchBlock;
//     size_t isFound = 0;

//     while (!isFound)
//     {
//         searchBlock = *(s_searchBoard[s_currentSearchBlock]);
        
//         ++s_currentSearchBlock;
//     }
//     ++s_currentSearchBlock;
//     return searchBlock;
// }


static BS_Coortinates_t GetNextSearchCoord()
{
    unsigned int curCoord = 0;
    unsigned int isFound = 0;
    unsigned int isValidCheckerSpot = 0;
    unsigned int curRow;
    unsigned int curCol;
    BS_Coortinates_t searchCoord;


    while (!isFound)
    {
        isValidCheckerSpot = 0;
        while(!isValidCheckerSpot)
        {
            curCoord = rand() % 11;
            curRow = curCoord > 9 ? 0 : curCoord;
            curCoord = rand() % 11;
            curCol = curCoord > 9 ? 0 : curCoord;
            if((curRow % 2) && (curCol % 2))
            {
                isValidCheckerSpot = 1;
            }
            else if (!(curRow % 2) && !(curCol % 2))
            {
                isValidCheckerSpot = 1;
            }
            if (EMPTY != s_statusBoard.m_eaStatusBoard[curRow][curCol])
            {
                isValidCheckerSpot = 0;
            }
            else
            {
                isFound = 1;
            }
        }
    }
    searchCoord.x = curRow;
    searchCoord.y = curCol;
    return searchCoord;
}




static BS_Coortinates_t GetFirstHitCoordinateFound()
{
	BS_Coortinates_t firstHitCoordFound;
	unsigned int isFound = 0;
	unsigned int curRow;
	unsigned int curCol;

	for (curRow = 0; curRow < BS_BOARD_SIZE; ++curRow)
	{
		for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
		{
			if ( HITSHIP == s_statusBoard.m_eaStatusBoard[curRow][curCol])
			{
				firstHitCoordFound.x = curRow;
				firstHitCoordFound.y = curCol;
				return firstHitCoordFound;
			}
		}
	}
	firstHitCoordFound.x = BS_BOARD_SIZE + 1;
	firstHitCoordFound.y = BS_BOARD_SIZE + 1;
	return firstHitCoordFound;
}


static BS_Coortinates_t GetNextDestroyCoord(BS_Coortinates_t _attackAndDestroyCoord)
{
	BS_Coortinates_t north;
	BS_Coortinates_t south;
	BS_Coortinates_t east;
	BS_Coortinates_t west;
	unsigned int curCoordNum;

	north.x = _attackAndDestroyCoord.x + 1;
	north.y = _attackAndDestroyCoord.y;
	south.x = _attackAndDestroyCoord.x - 1;
	south.y = _attackAndDestroyCoord.y;
	east.x = _attackAndDestroyCoord.x;
	east.y = _attackAndDestroyCoord.y + 1;
	west.x = _attackAndDestroyCoord.x;
	west.y = _attackAndDestroyCoord.y - 1;
	
	if (north.x < BS_BOARD_SIZE)
	{
		if (EMPTY == s_statusBoard.m_eaStatusBoard[north.x][north.y])
		{
			return north;
		}
	}
	if (south.x < BS_BOARD_SIZE)
	{
		if (EMPTY == s_statusBoard.m_eaStatusBoard[south.x][south.y])
		{
			return south;
		}
	}
	if (east.x < BS_BOARD_SIZE)
	{
		if (EMPTY == s_statusBoard.m_eaStatusBoard[east.x][east.y])
		{
			return east;
		}
	}
	if (west.x < BS_BOARD_SIZE)
	{
		if (EMPTY == s_statusBoard.m_eaStatusBoard[west.x][west.y])
		{
			return west;
		}
	}

}




void Sleep_Wrapper(unsigned int _sleepTimeSecs)
{
    #ifdef __linux__ 
        sleep(_sleepTimeSecs);
    #elif _WIN32
        Sleep(1);
    #elif __APPLE__
        /*TODO*/
    #endif
}