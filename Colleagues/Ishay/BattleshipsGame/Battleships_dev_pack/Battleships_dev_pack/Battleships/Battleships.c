#include "BSEngine.h"

int main(int argc, char** argv) {

	BS_Engine_init("BSPlayer1.dll", "BSPlayer2.dll");
	BS_Engine_play(10);
	BS_Engine_close();

	return 0;
}
