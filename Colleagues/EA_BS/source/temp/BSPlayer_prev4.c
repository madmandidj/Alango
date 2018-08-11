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

#define NUM_OF_SEARCH_BLOCKS 25
#define SIDE_LENGTH_IN_BLOCKS 5 /* because 5 * 5 = 25 */
#define NUM_OF_COORDINATES ((BS_BOARD_SIZE * BS_BOARD_SIZE))
#define NUM_OF_COORD_PER_BLOCK ((NUM_OF_COORDINATES / NUM_OF_SEARCH_BLOCKS))
#define NUM_OF_CHECKERED_COORD ((NUM_OF_COORDINATES) / (2))
#define NUM_OF_SHIPS 5
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
    DESTROY_DIRECTION
}AttackMode;
typedef enum
{
	EMPTY,
	EMPTYMISS,
	HITSHIP,
	SUNKSHIP,
	LASTHIT,
	LASTMISS
} EA_Status;
typedef enum
{
	NORTH,
	SOUTH,
	EAST,
	WEST
}PotentialDestroyDirections;
typedef unsigned int DestroyedDirectionsResults[4];
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
static BS_Coortinates_t GetDestroyDirectionCoord();
void Sleep_Wrapper(unsigned int _sleepTimeSecs);
static unsigned int IsCheckeredCoordinate(unsigned int _row, unsigned int _col);
static unsigned int IsValidAttackCoordinate(BS_Coortinates_t _coord);
/*********************************************
STATIC GLOBALS INSTANTIATION
*********************************************/
static const unsigned int s_ship_sizes[] = {0,2,3,3,4,5};
//static BS_Board_t s_attackBoard = { 0 };
static EA_StatusBoard s_statusBoard;
static int s_myAttackResult[2] = { 0 };
static BS_Coortinates_t s_myAttackCoord;
static BS_Coortinates_t s_firstHitCoord;
static BS_Coortinates_t s_prevDestroyCoord;
static PotentialDestroyDirections s_curDestroyDirection;
static unsigned int s_numOfShips = 5;
static EA_SearchBlockBoard s_searchBoard = { 0 };
static unsigned int s_attackMode = 0;
static unsigned int s_prevAttackMode = 0;
static unsigned int s_currentSearchBlock = 0;
static BS_ShipCoordinates_t s_shipsCoordContainer[NUM_OF_SHIPS];
static unsigned int s_numOfAttackedSearchCheckers = 0;
static DestroyedDirectionsResults s_destroyedDirectionResults;
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
	unsigned int isCheckered;
	myCoord = CalculateAttackCoordinate();
	s_myAttackCoord.x = myCoord.x;
	s_myAttackCoord.y = myCoord.y;
	if (isCheckered = IsCheckeredCoordinate(s_myAttackCoord.x, s_myAttackCoord.y))
	{
		if (NUM_OF_CHECKERED_COORD > s_numOfAttackedSearchCheckers)
		{
			++s_numOfAttackedSearchCheckers;
		}
	}
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
	BS_Coortinates_t curStart;
	BS_Coortinates_t curEnd;
	unsigned int curPos;
	unsigned int curShip;
	unsigned int curRow;
	unsigned int finalCurPos;

	switch (status)
	{
	case BS_HS_MISS:
		if (DESTROY_ATTACK == s_attackMode)
		{
			s_destroyedDirectionResults[s_curDestroyDirection] = 1;
		}
		else if (DESTROY_DIRECTION == s_attackMode)
		{
			s_attackMode = DESTROY_ATTACK;
		}
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = EMPTYMISS;
		break;
	case BS_HS_HIT:
		if (SEARCH_ATTACK == s_attackMode)
		{
			s_attackMode = DESTROY_ATTACK;
			s_firstHitCoord = s_myAttackCoord;
		}
		else if (DESTROY_ATTACK == s_attackMode)
		{
			s_prevDestroyCoord = s_myAttackCoord;
			s_attackMode = DESTROY_DIRECTION;
		}
		else if (DESTROY_DIRECTION == s_attackMode)
		{
			s_prevDestroyCoord = s_myAttackCoord;
		}
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = HITSHIP;
		break;
	default:
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = SUNKSHIP;
		s_attackMode = SEARCH_ATTACK;
		s_destroyedDirectionResults[0] = 0;
		s_destroyedDirectionResults[1] = 0;
		s_destroyedDirectionResults[2] = 0;
		s_destroyedDirectionResults[3] = 0;
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
		s_shipsCoordContainer[curShip - 1].ship_start = curShipCoordinate.ship_start;
		s_shipsCoordContainer[curShip - 1].ship_end = curShipCoordinate.ship_end;
		bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;
	}
}

static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship)
{
	static unsigned int shipColPos = 0;
	BS_ShipCoordinates_t shipCoord;
	shipCoord.ship_start.x = _ship;
	shipCoord.ship_start.y = 0;
	shipCoord.ship_end.x = _ship;
	shipCoord.ship_end.y = s_ship_sizes[_ship] - 1;
	shipColPos += 2;
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
           /* attackAndDestroyCoord = GetFirstHitCoordinateFound();
			if (attackAndDestroyCoord.x > BS_BOARD_SIZE)
			{
				attackCoord = GetNextSearchCoord();
				break;
			}*/
            attackCoord = GetNextDestroyCoord(s_myAttackCoord);
            break;
		case DESTROY_DIRECTION:
			attackCoord = GetDestroyDirectionCoord();
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

static BS_Coortinates_t GetNextSearchCoord()
{
    unsigned int curCoord = 0;
    unsigned int isFound = 0;
    unsigned int isValidCheckerSpot = 0;
    unsigned int curRow;
    unsigned int curCol;
    BS_Coortinates_t searchCoord;
	BS_Coortinates_t tempCoord;


    while (!isFound)
    {
        isValidCheckerSpot = 0;
        while(!isValidCheckerSpot)
        {
            curCoord = rand() % 11;
            curRow = curCoord > 9 ? 0 : curCoord;
            curCoord = rand() % 11;
            curCol = curCoord > 9 ? 0 : curCoord;
            /*if((curRow % 2) && (curCol % 2))
            {
                isValidCheckerSpot = 1;
            }
            else if (!(curRow % 2) && !(curCol % 2))
            {
                isValidCheckerSpot = 1;
            }*/
			isValidCheckerSpot = IsCheckeredCoordinate(curRow, curCol);
			if (!isValidCheckerSpot)
			{
				continue;
			}
           /* if (EMPTY != s_statusBoard.m_eaStatusBoard[curRow][curCol])
            {
                isValidCheckerSpot = 0;
            }*/
			tempCoord.x = curRow;
			tempCoord.y = curCol;
			if (!(isValidCheckerSpot = IsValidAttackCoordinate(tempCoord)))
			{
				isValidCheckerSpot = 0;
			}
            else
            {
                isFound = 1;
				break;
            }
        }
    }
    searchCoord.x = curRow;
    searchCoord.y = curCol;
    return searchCoord;
}


static unsigned int IsCheckeredCoordinate(unsigned int _row, unsigned int _col)
{
	if (NUM_OF_CHECKERED_COORD == s_numOfAttackedSearchCheckers)
	{
		if ((_row % 2) && (_col % 2))
		{
			return 0;
		}
		else if (!(_row % 2) && !(_col % 2))
		{
			return 0;
		}
		return 1;
	}
	else
	{
		if ((_row % 2) && (_col % 2))
		{
			return 1;
		}
		else if (!(_row % 2) && !(_col % 2))
		{
			return 1;
		}
	}
	return 0;
}



//static BS_Coortinates_t GetFirstHitCoordinateFound()
//{
//	BS_Coortinates_t firstHitCoordFound;
//	unsigned int isFound = 0;
//	unsigned int curRow;
//	unsigned int curCol;
//
//	for (curRow = 0; curRow < BS_BOARD_SIZE; ++curRow)
//	{
//		for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
//		{
//			if ( HITSHIP == s_statusBoard.m_eaStatusBoard[curRow][curCol])
//			{
//				firstHitCoordFound.x = curRow;
//				firstHitCoordFound.y = curCol;
//				return firstHitCoordFound;
//			}
//		}
//	}
//	firstHitCoordFound.x = BS_BOARD_SIZE + 1;
//	firstHitCoordFound.y = BS_BOARD_SIZE + 1;
//	return firstHitCoordFound;
//}


static BS_Coortinates_t GetNextDestroyCoord(BS_Coortinates_t _attackAndDestroyCoord)
{
	BS_Coortinates_t firstHitnorth;
	BS_Coortinates_t firstHitsouth;
	BS_Coortinates_t firstHiteast;
	BS_Coortinates_t firstHitwest;
	BS_Coortinates_t north;
	BS_Coortinates_t south;
	BS_Coortinates_t east;
	BS_Coortinates_t west;
	unsigned int curCoordNum;
	unsigned int index;

	firstHitnorth.x = s_firstHitCoord.x + 1;
	firstHitnorth.y = s_firstHitCoord.y;
	firstHitsouth.x = s_firstHitCoord.x - 1;
	firstHitsouth.y = s_firstHitCoord.y;
	firstHiteast.x = s_firstHitCoord.x;
	firstHiteast.y = s_firstHitCoord.y + 1;
	firstHitwest.x = s_firstHitCoord.x;
	firstHitwest.y = s_firstHitCoord.y - 1;

	if (IsValidAttackCoordinate(firstHitnorth))
	{
		s_curDestroyDirection = NORTH;
		return firstHitnorth;
	}
	else if (IsValidAttackCoordinate(firstHitsouth))
	{
		s_curDestroyDirection = SOUTH;
		return firstHitsouth;
	}
	else if (IsValidAttackCoordinate(firstHiteast))
	{
		s_curDestroyDirection = EAST;
		return firstHiteast;
	}
	else if (IsValidAttackCoordinate(firstHitwest))
	{
		s_curDestroyDirection = WEST;
		return firstHitwest;
	}

	return GetNextSearchCoord();


	//north.x = _attackAndDestroyCoord.x + 1;
	//north.y = _attackAndDestroyCoord.y;
	//south.x = _attackAndDestroyCoord.x - 1;
	//south.y = _attackAndDestroyCoord.y;
	//east.x = _attackAndDestroyCoord.x;
	//east.y = _attackAndDestroyCoord.y + 1;
	//west.x = _attackAndDestroyCoord.x;
	//west.y = _attackAndDestroyCoord.y - 1;

	//if (firstHitnorth.x < BS_BOARD_SIZE)
	//{

	//}

	//for (index = 0; index < 4; ++index)
	//{
	//	if (0 < s_destroyedDirectionResults[index])
	//	{
	//		if (0 == index % 2)
	//		{
	//			if (0 < s_destroyedDirectionResults[index + 1])
	//			{
	//				if (0 < s_destroyedDirectionResults[index + 1])
	//				{

	//				}
	//			}
	//		}
	//	}
	//}





	//if (HITSHIP != s_statusBoard.m_eaStatusBoard[_attackAndDestroyCoord.x][_attackAndDestroyCoord.y])
	//{
	//	
	//}



	//if (north.x < BS_BOARD_SIZE)
	//{
	//	if (EMPTY == s_statusBoard.m_eaStatusBoard[north.x][north.y])
	//	{
	//		return north;
	//	}
	//	if (HITSHIP == s_statusBoard.m_eaStatusBoard[north.x][north.y])
	//	{
	//		if (EMPTY == s_statusBoard.m_eaStatusBoard[south.x][south.y])
	//		{
	//			return south;
	//		}
	//	}
	//}
	//if (south.x < BS_BOARD_SIZE)
	//{
	//	if (EMPTY == s_statusBoard.m_eaStatusBoard[south.x][south.y])
	//	{
	//		return south;
	//	}
	//	if (HITSHIP == s_statusBoard.m_eaStatusBoard[south.x][south.y])
	//	{
	//		if (EMPTY == s_statusBoard.m_eaStatusBoard[north.x][north.y])
	//		{
	//			return north;
	//		}
	//	}
	//}
	//if (east.x < BS_BOARD_SIZE)
	//{
	//	if (EMPTY == s_statusBoard.m_eaStatusBoard[east.x][east.y])
	//	{
	//		return east;
	//	}
	//	if (HITSHIP == s_statusBoard.m_eaStatusBoard[east.x][east.y])
	//	{
	//		if (EMPTY == s_statusBoard.m_eaStatusBoard[west.x][west.y])
	//		{
	//			return west;
	//		}
	//	}
	//}
	//if (west.x < BS_BOARD_SIZE)
	//{
	//	if (EMPTY == s_statusBoard.m_eaStatusBoard[west.x][west.y])
	//	{
	//		return west;
	//	}
	//	if (HITSHIP == s_statusBoard.m_eaStatusBoard[west.x][west.y])
	//	{
	//		if (EMPTY == s_statusBoard.m_eaStatusBoard[east.x][east.y])
	//		{
	//			return east;
	//		}
	//	}
	//}


}




static BS_Coortinates_t GetDestroyDirectionCoord()
{
	BS_Coortinates_t nextCoord;
	BS_Coortinates_t nextNorth;
	BS_Coortinates_t nextSouth;
	BS_Coortinates_t nextEast;
	BS_Coortinates_t nextWest;
	unsigned int isFound = 0;
	unsigned int numOfReps = 0;

	nextNorth.x = s_prevDestroyCoord.x - 1;
	nextNorth.y = s_prevDestroyCoord.y;
	nextSouth.x = s_prevDestroyCoord.x + 1;
	nextSouth.y = s_prevDestroyCoord.y;
	nextEast.x = s_prevDestroyCoord.x;
	nextEast.y = s_prevDestroyCoord.y + 1;
	nextWest.x = s_prevDestroyCoord.x;
	nextWest.y = s_prevDestroyCoord.y - 1;

	while (!isFound)
	{
		++numOfReps;
		if (numOfReps >= 5)
		{
			return GetNextSearchCoord();
		}
		switch (s_curDestroyDirection)
		{
		case NORTH:
			if (IsValidAttackCoordinate(nextNorth))
			{
				return nextNorth;
			}
			else
			{
				++s_curDestroyDirection;
				s_curDestroyDirection %= 4;
				continue;
			}
			break;
		case SOUTH:
			if (IsValidAttackCoordinate(nextSouth))
			{
				return nextSouth;
			}
			else
			{
				++s_curDestroyDirection;
				s_curDestroyDirection %= 4;
				continue;
			}
			break;
		case EAST:
			if (IsValidAttackCoordinate(nextEast))
			{
				return nextEast;
			}
			else
			{
				++s_curDestroyDirection;
				s_curDestroyDirection %= 4;
				continue;
			}
			break;
		case WEST:
			if (IsValidAttackCoordinate(nextWest))
			{
				return nextWest;
			}
			else
			{
				++s_curDestroyDirection;
				s_curDestroyDirection %= 4;
				continue;
			}
			break;
		}
	}
}

static unsigned int IsValidAttackCoordinate(BS_Coortinates_t _coord)
{
	if (BS_BOARD_SIZE > _coord.x && BS_BOARD_SIZE > _coord.y)
	{
		if (EMPTY == s_statusBoard.m_eaStatusBoard[_coord.x][_coord.y])
		{
			return 1;
		}
	}
	return 0;
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