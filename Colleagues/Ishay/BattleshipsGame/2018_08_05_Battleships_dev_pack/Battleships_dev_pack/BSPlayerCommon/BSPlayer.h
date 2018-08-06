#ifndef BSPLAYER_H
#define BSPLAYER_H

#include "BSEngine_board.h"

__declspec(dllexport) void staging_cb(BS_Board_t* p_board);
__declspec(dllexport) void turn_cb(BS_Coortinates_t* p_coordinates);
__declspec(dllexport) void status_cb(BS_HitStatus_t hit_status);

#endif // BSPLAYER_H

