#ifndef BSENGINE_BOARD_H
#define BSENGINE_BOARD_H

#define BS_BOARD_SIZE 10

typedef enum {
	BS_HS_MISS,
	BS_HS_HIT,
	BS_HS_DESTROYER_SUNK,
	BS_HS_SUBMARINE_SUNK,
	BS_HS_CRUISER_SUNK,
	BS_HS_BATTLESHIP_SUNK,
	BS_HS_CARRIER_SUNK
} BS_HitStatus_t;

typedef enum {
	BS_BE_SHIP_WRONG_SIZE = - 3,
	BS_BE_SHIP_ILLEGAL_ORIENTATION,
	BS_BE_SHIP_OUT_OF_BOUNDS,
	BS_BE_OK
} BS_BoardError_t;

typedef enum {
	BS_SHIP_CLASS_NONE,
	BS_SHIP_CLASS_DESTROYER,
	BS_SHIP_CLASS_SUBMARINE,
	BS_SHIP_CLASS_CRUISER,
	BS_SHIP_CLASS_BATTLESHIP,
	BS_SHIP_CLASS_CARRIER
} BS_ShipClass_t;

typedef int BS_Board_t[BS_BOARD_SIZE][BS_BOARD_SIZE];

typedef struct {
	unsigned int x;
	unsigned int y;
} BS_Coortinates_t;

typedef struct {
	BS_Coortinates_t ship_start;
	BS_Coortinates_t ship_end;
} BS_ShipCoordinates_t;

__declspec(dllexport) BS_BoardError_t BS_Board_PlaceShip(BS_Board_t* board, BS_ShipClass_t ship_class, BS_ShipCoordinates_t* coordinates);

#endif // BSENGINE_BOARD_H
