#include <stdlib.h>
#include "BSPlayer.h"

static const unsigned int ship_sizes[] = { 0,2,3,3,4,5 };

static BS_Board_t board = { 0 };

static int last_guess[2] = { 0 };

void staging_cb(BS_Board_t* p_board);
void turn_cb(BS_Coortinates_t* p_coordinates);
void status_cb(BS_HitStatus_t hit_status);

// static void clear_board(void);
// static void fill_board(BS_Board_t* p_board);

void staging_cb(BS_Board_t* p_board) {
	// clear_board();
	// fill_board(p_board);
}

void turn_cb(BS_Coortinates_t* p_coordinates) {
	// do {
	// 	last_guess[0] = rand() % BS_BOARD_SIZE;
	// 	last_guess[1] = rand() % BS_BOARD_SIZE;
	// } while (board[last_guess[1]][last_guess[0]] != 0);

	// p_coordinates->x = last_guess[0];
	// p_coordinates->y = last_guess[1];
}

void status_cb(BS_HitStatus_t status) {
	if (status)
		board[last_guess[1]][last_guess[0]] = 1;
	else
		board[last_guess[1]][last_guess[0]] = -1;
}

static void clear_board(void) {
	for (unsigned int row = 0; row < BS_BOARD_SIZE; row++) {
		for (unsigned int col = 0; col < BS_BOARD_SIZE; col++) {
			board[row][col] = 0;
		}
	}
}

static void fill_board(BS_Board_t* p_board) {
	BS_Board_t scratch_board[2];
	BS_ShipCoordinates_t coordinates;
	unsigned int orientation;
	unsigned int spaces_left;

	for (unsigned int row = 0; row < BS_BOARD_SIZE; row++) {
		for (unsigned int col = 0; col < BS_BOARD_SIZE; col++) {
			scratch_board[0][row][col] = 10 - col;
			scratch_board[1][row][col] = 10 - row;
		}
	}

	for (BS_ShipClass_t ship = BS_SHIP_CLASS_CARRIER; ship > BS_SHIP_CLASS_NONE; ship--) {
		do {
			orientation = rand() % 2;
			if(orientation) {
				coordinates.ship_start.x = rand() % (BS_BOARD_SIZE);
				coordinates.ship_start.y = rand() % (BS_BOARD_SIZE - ship_sizes[ship]);
			}
			else {
				coordinates.ship_start.x = rand() % (BS_BOARD_SIZE - ship_sizes[ship]);
				coordinates.ship_start.y = rand() % (BS_BOARD_SIZE);
			}
		} while (scratch_board[orientation][coordinates.ship_start.y][coordinates.ship_start.x] < ship_sizes[ship]);

		if (orientation) {
			coordinates.ship_end.x = coordinates.ship_start.x;

			for (coordinates.ship_end.y = coordinates.ship_start.y; coordinates.ship_end.y < coordinates.ship_start.y + ship_sizes[ship]; coordinates.ship_end.y++) {
				scratch_board[0][coordinates.ship_end.y][coordinates.ship_end.x] = 0;
				scratch_board[1][coordinates.ship_end.y][coordinates.ship_end.x] = 0;
			}

			for (int row = coordinates.ship_start.y - 1, spaces_left = 1; row >= 0; row--) {
				if (!scratch_board[1][row][coordinates.ship_end.x]) break;
				scratch_board[1][row][coordinates.ship_end.x] = spaces_left++;
			}

			for (int row = coordinates.ship_end.y; row < BS_BOARD_SIZE; row++) {
				if ((!scratch_board[1][row][coordinates.ship_end.x]) || (row == BS_BOARD_SIZE - 1)) {
					for(spaces_left = 1; row >= coordinates.ship_end.y; row--)
						scratch_board[1][row][coordinates.ship_end.x] = spaces_left++;
					break;
				}
			}

			for (int row = coordinates.ship_start.y; row < coordinates.ship_end.y; row++) {
				for (int col = coordinates.ship_start.x - 1, spaces_left = 1; col >= 0; col--) {
					if (!scratch_board[0][row][col]) break;
					scratch_board[0][row][col] = spaces_left++;
				}

				for (int col = coordinates.ship_end.x; col < BS_BOARD_SIZE; col++) {
					if ((!scratch_board[0][row][col]) || (col == BS_BOARD_SIZE - 1)) {
						for (spaces_left = 1; col > coordinates.ship_end.x; col--)
							scratch_board[0][row][col] = spaces_left++;
						break;
					}
				}
			}

			coordinates.ship_end.y--;
		}
		else {
			coordinates.ship_end.y = coordinates.ship_start.y;
			for (coordinates.ship_end.x = coordinates.ship_start.x; coordinates.ship_end.x < coordinates.ship_start.x + ship_sizes[ship]; coordinates.ship_end.x++) {
				scratch_board[0][coordinates.ship_end.y][coordinates.ship_end.x] = 0;
				scratch_board[1][coordinates.ship_end.y][coordinates.ship_end.x] = 0;
			}

			for (int col = coordinates.ship_start.x - 1, spaces_left = 1; col >= 0; col--) {
				if (!scratch_board[0][coordinates.ship_end.y][col]) break;
				scratch_board[0][coordinates.ship_end.y][col] = spaces_left++;
			}

			for (int col = coordinates.ship_end.x; col < BS_BOARD_SIZE; col++) {
				if ((!scratch_board[0][coordinates.ship_end.y][col]) || (col == BS_BOARD_SIZE - 1)) {
					for (spaces_left = 1; col >= coordinates.ship_end.x; col--)
						scratch_board[0][coordinates.ship_end.y][col] = spaces_left++;
					break;
				}
			}

			for (int col = coordinates.ship_start.x; col < coordinates.ship_end.x; col++) {
				for (int row = coordinates.ship_start.y - 1, spaces_left = 1; row >= 0; row--) {
					if (!scratch_board[1][row][col]) break;
					scratch_board[1][row][col] = spaces_left++;
				}

				for (int row = coordinates.ship_end.y; row < BS_BOARD_SIZE; row++) {
					if ((!scratch_board[1][row][col]) || (row == BS_BOARD_SIZE - 1)) {
						for (spaces_left = 1; row > coordinates.ship_end.y; row--)
							scratch_board[1][row][col] = spaces_left++;
						break;
					}
				}
			}

			coordinates.ship_end.x--;
		}

		BS_Board_PlaceShip(p_board, ship, &coordinates);
	}
}