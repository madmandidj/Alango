#ifndef BSENGINE_H
#define BSENGINE_H

typedef enum {
	BS_EE_ILLEGAL_TURN_COODRINATES = -6,
	BS_EE_ILLEGAL_SHIP_PLACEMENT,
	BS_EE_STATUS_CALLBACK_NOT_FOUND,
	BS_EE_TURN_CALLBACK_NOT_FOUND,
	BS_EE_STAGING_CALLBACK_NOT_FOUND,
	BS_EE_PLAYER_DLL_NOT_FOUND,
	BS_EE_OK
} BS_EngineError_t;

__declspec(dllexport) BS_EngineError_t BS_Engine_init(int argc, char** argv);
__declspec(dllexport) void BS_Engine_play(void);
__declspec(dllexport) void BS_Engine_close(void);

#endif // BSENGINE_H