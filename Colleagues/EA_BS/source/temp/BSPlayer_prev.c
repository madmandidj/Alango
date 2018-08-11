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
#include "../inc/BSPlayer.h"

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
/*********************************************
STATIC FUNCTION DECLARATIONS
*********************************************/
static void InitAttackBoard();
static void InitSearchBoard();
static void PlaceAllShips(BS_Board_t* p_board);
static BS_ShipCoordinates_t CalculateShipPlacement(BS_Board_t* p_board, BS_ShipClass_t _ship);
static BS_Coortinates_t CalculateAttackCoordinate();
static BS_HitStatus_t GetBCHitStatus(unsigned int _x, unsigned int _y);
static EA_SearchBlock GetNextSearchBlock();
static BS_Coortinates_t GetNextSearchCoord(EA_SearchBlock _searchBlock);
static BS_Coortinates_t GetFirstHitCoordinateFound();
static BS_Coortinates_t GetNextDestroyCoord(BS_Coortinates_t _attackAndDestroyCoord);
void Sleep_Wrapper(unsigned int _sleepTimeSecs);
/*********************************************
STATIC GLOBALS INSTANTIATION
*********************************************/
static const unsigned int s_ship_sizes[] = {0,2,3,3,4,5};
static BS_Board_t s_attackBoard = { 0 };
static int s_myAttackResult[2] = { 0 };
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
	InitSearchBoard();
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
			s_attackBoard[xPos][yPos] = 0;
		}
	}
}

static void InitSearchBoard()
{
    unsigned int curCol;
    unsigned curRow;
    unsigned int shouldStartSecondRow = 1;

    for (curCol = 0; curCol < BS_BOARD_SIZE; ++curCol)
    {
        curRow = shouldStartSecondRow ? 0 : 1;
        while (curRow < BS_BOARD_SIZE)
        {
            s_searchBoard[curCol][curRow] = (0 == (curRow % 2)) ? (shouldStartSecondRow ? 0 : 1) : (shouldStartSecondRow ? 1 : 0); 
            ++curRow;
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
    BS_Coortinates_t attackAndDestroyCoord;
    EA_SearchBlock searchBlock;
    unsigned int isAttackCoordValid = 0;

    switch (s_attackMode)
    {
        case SEARCH_ATTACK:
                searchBlock = GetNextSearchBlock();
                attackCoord = GetNextSearchCoord(searchBlock);
            break;

        case DESTROY_ATTACK:
            while (!isAttackCoordValid)
            {
                attackAndDestroyCoord = GetFirstHitCoordinateFound();
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

static EA_SearchBlock GetNextSearchBlock()
{
    EA_SearchBlock searchBlock;
    size_t isFound = 0;

    while (!isFound)
    {
        searchBlock = *(s_searchBoard[s_currentSearchBlock]);
        
        ++s_currentSearchBlock;
    }
    ++s_currentSearchBlock;
    return searchBlock;
}


static BS_Coortinates_t GetNextSearchCoord(EA_SearchBlock _searchBlock)
{

}




static BS_Coortinates_t GetFirstHitCoordinateFound()
{

}


static BS_Coortinates_t GetNextDestroyCoord(BS_Coortinates_t _attackAndDestroyCoord)
{

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