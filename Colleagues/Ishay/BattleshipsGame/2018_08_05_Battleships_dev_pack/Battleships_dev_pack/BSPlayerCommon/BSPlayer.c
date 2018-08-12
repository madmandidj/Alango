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

#define NUM_OF_COORDINATES ((BS_BOARD_SIZE * BS_BOARD_SIZE))
#define NUM_OF_CHECKERED_COORD ((NUM_OF_COORDINATES) / (2))
#define NUM_OF_SHIPS 5
#define TOTAL_NUM_OF_EXPECTED_HITS 17
#define SEARCH_NUM_REP_LIMIT 200000
/*********************************************
TYPEDEFS AND ENUMS
*********************************************/
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
//static void InitSearchBoard();
static void PlaceAllShips(BS_Board_t* p_board);
static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship);
static BS_Coortinates_t CalculateAttackCoordinate();
//static BS_HitStatus_t GetBCHitStatus(unsigned int _x, unsigned int _y);
static BS_Coortinates_t GetNextSearchCoord();
//static BS_Coortinates_t GetFirstHitCoordinateFound();
static BS_Coortinates_t GetNextDestroyCoord();
static BS_Coortinates_t GetDestroyDirectionCoord();
void Sleep_Wrapper(unsigned int _sleepTimeSecs);
static unsigned int IsCheckeredCoordinate(unsigned int _row, unsigned int _col);
static unsigned int IsValidAttackCoordinate(BS_Coortinates_t _coord);

/*********************************************
STATIC GLOBALS INSTANTIATION
*********************************************/
static const unsigned int s_ship_sizes[] = {0,2,3,3,4,5};
static EA_StatusBoard s_statusBoard;
static int s_myAttackResult[2] = { 0 };
static BS_Coortinates_t s_myAttackCoord;
static BS_Coortinates_t s_firstHitCoord;
static BS_Coortinates_t s_prevDestroyCoord;
static PotentialDestroyDirections s_curDestroyDirection;
static unsigned int s_numOfShips = 5;
static unsigned int s_attackMode = 0;
static unsigned int s_prevAttackMode = 0;
static unsigned int s_currentSearchBlock = 0;
static BS_ShipCoordinates_t s_shipsCoordContainer[NUM_OF_SHIPS];
static unsigned int s_numOfAttackedSearchCheckers = 0;
static DestroyedDirectionsResults s_destroyedDirectionResults;
static unsigned int s_curTotalNumOfHits = 0;
static unsigned int s_destroyDirectionOffset = 1;
static unsigned int s_curSearchNumRep = 0;
/*********************************************
API FUNCTIONS DEFINITIONS
*********************************************/
void staging_cb(BS_Board_t* p_board)
{
	InitAttackBoard();
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
	//++s_curSearchNumRep;
}

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
			//s_attackMode = DESTROY_ATTACK;
			s_prevDestroyCoord = s_firstHitCoord;
			++s_curDestroyDirection;
			s_curDestroyDirection %= 4;
			s_attackMode = DESTROY_DIRECTION;
		}
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = EMPTYMISS;
		break;
	case BS_HS_HIT:
		if (SEARCH_ATTACK == s_attackMode)
		{
			s_attackMode = DESTROY_ATTACK;
			s_prevDestroyCoord = s_myAttackCoord;
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
		++s_curTotalNumOfHits;
		break;
	default:
		++s_curTotalNumOfHits;
		s_statusBoard.m_eaStatusBoard[s_myAttackCoord.x][s_myAttackCoord.y] = SUNKSHIP;
		s_attackMode = SEARCH_ATTACK;
		s_destroyedDirectionResults[0] = 0;
		s_destroyedDirectionResults[1] = 0;
		s_destroyedDirectionResults[2] = 0;
		s_destroyedDirectionResults[3] = 0;
		s_destroyDirectionOffset = 1;
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
	srand(time(NULL));
	s_curSearchNumRep = 0;
	for (xPos = 0; xPos < BS_BOARD_SIZE; ++xPos)
	{
		for (yPos = 0; yPos < BS_BOARD_SIZE; ++yPos)
		{
			s_statusBoard.m_eaStatusBoard[xPos][yPos] = EMPTY;
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
		s_shipsCoordContainer[curShip - 1].ship_start = curShipCoordinate.ship_start;
		s_shipsCoordContainer[curShip - 1].ship_end = curShipCoordinate.ship_end;
		bsBoardError = BS_BE_SHIP_OUT_OF_BOUNDS;
	}
}

static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship)
{
	static unsigned int shipColPos = 0;
	BS_ShipCoordinates_t shipCoord;
	//unsigned int curShip;
	//while (1)
	//{
	//	for (curShip = 1; curShip <= _ship; ++curShip)
	//	{

	//	}
	//}



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
    unsigned int isAttackCoordValid = 0;

    switch (s_attackMode)
    {
        case SEARCH_ATTACK:
            attackCoord = GetNextSearchCoord();
            break;

        case DESTROY_ATTACK:
            attackCoord = GetNextDestroyCoord();
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
	unsigned int curRow = 0;
	unsigned int curCol = 0;
	BS_Coortinates_t searchCoord;
	BS_Coortinates_t tempCoord;
	unsigned int curSearchRepNum = 0;

	/*if (16 == s_curTotalNumOfHits)
	{
		while (1)
		{
			if ((HITSHIP == s_statusBoard.m_eaStatusBoard[curCoord / 10][curCoord % 10]) || SUNKSHIP == (s_statusBoard.m_eaStatusBoard[curCoord / 10][curCoord % 10]))
			{

			}
			else
			{

			}

		}
	}*/



	/*if (75 <= s_curSearchNumRep)
	{
		while (1)
		{
			for (curRow = 0; curRow < BS_BOARD_SIZE; ++curRow)
			{
				for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
				{
					if (EMPTY == s_statusBoard.m_eaStatusBoard[curRow][curCol])
					{
						searchCoord.x = curRow;
						searchCoord.y = curCol;
						return searchCoord;
					}

				}
			}
		}
	}*/
	//else
	//{
	s_curSearchNumRep = 0;
		while (!isFound)
		{
			//srand(time(NULL));
			
			if (SEARCH_NUM_REP_LIMIT <= s_curSearchNumRep)
			{
				while (1)
				{
					for (curRow = 0; curRow < BS_BOARD_SIZE; ++curRow)
					{
						for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
						{
							if (EMPTY == s_statusBoard.m_eaStatusBoard[curRow][curCol])
							{
								searchCoord.x = curRow;
								searchCoord.y = curCol;
								return searchCoord;
							}

						}
					}
				}
			}


			isValidCheckerSpot = 0;
			while (!isValidCheckerSpot && SEARCH_NUM_REP_LIMIT > s_curSearchNumRep)
			{
				++s_curSearchNumRep;
				curCoord = rand() % 11;
				curRow = curCoord > 9 ? 0 : curCoord;
				//srand(time(NULL));
				curCoord = rand() % 11;
				curCol = curCoord > 9 ? 0 : curCoord;
				isValidCheckerSpot = IsCheckeredCoordinate(curRow, curCol);
				if (!isValidCheckerSpot)
				{
					continue;
				}
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
	//}
	searchCoord.x = curRow;
	searchCoord.y = curCol;
	++curSearchRepNum;
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

static BS_Coortinates_t GetNextDestroyCoord()
{
	BS_Coortinates_t firstHitnorth;
	BS_Coortinates_t firstHitsouth;
	BS_Coortinates_t firstHiteast;
	BS_Coortinates_t firstHitwest;

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

	firstHitnorth.x = s_firstHitCoord.x + 2;
	firstHitnorth.y = s_firstHitCoord.y;
	firstHitsouth.x = s_firstHitCoord.x - 2;
	firstHitsouth.y = s_firstHitCoord.y;
	firstHiteast.x = s_firstHitCoord.x;
	firstHiteast.y = s_firstHitCoord.y + 2;
	firstHitwest.x = s_firstHitCoord.x;
	firstHitwest.y = s_firstHitCoord.y - 2;

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
	static unsigned int offset = 1;

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
			while (!IsValidAttackCoordinate(nextNorth) &&
				!IsValidAttackCoordinate(nextSouth) &&
				!IsValidAttackCoordinate(nextEast) &&
				!IsValidAttackCoordinate(nextWest))
			{
				if (s_destroyDirectionOffset > BS_BOARD_SIZE - 1)
				{
					while (!IsValidAttackCoordinate(nextNorth) &&
						!IsValidAttackCoordinate(nextSouth) &&
						!IsValidAttackCoordinate(nextEast) &&
						!IsValidAttackCoordinate(nextWest))
					{
						s_destroyDirectionOffset = 2;
						nextNorth.x = s_prevDestroyCoord.x - s_destroyDirectionOffset;
						nextNorth.y = s_prevDestroyCoord.y;
						nextSouth.x = s_prevDestroyCoord.x + s_destroyDirectionOffset;
						nextSouth.y = s_prevDestroyCoord.y;
						nextEast.x = s_prevDestroyCoord.x;
						nextEast.y = s_prevDestroyCoord.y + s_destroyDirectionOffset;
						nextWest.x = s_prevDestroyCoord.x;
						nextWest.y = s_prevDestroyCoord.y - s_destroyDirectionOffset;
						break;
					}
				}
				else
				{
					++s_destroyDirectionOffset;
					nextNorth.x = s_firstHitCoord.x - s_destroyDirectionOffset;
					nextNorth.y = s_firstHitCoord.y;
					nextSouth.x = s_firstHitCoord.x + s_destroyDirectionOffset;
					nextSouth.y = s_firstHitCoord.y;
					nextEast.x = s_firstHitCoord.x;
					nextEast.y = s_firstHitCoord.y + s_destroyDirectionOffset;
					nextWest.x = s_firstHitCoord.x;
					nextWest.y = s_firstHitCoord.y - s_destroyDirectionOffset;
				}
			}
			numOfReps = 1;
			//return GetNextSearchCoord();
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