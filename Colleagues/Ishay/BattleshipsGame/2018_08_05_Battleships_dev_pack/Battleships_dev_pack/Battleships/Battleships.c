#include "BSEngine.h"

int main(int argc, char** argv) {

	BS_Engine_init(argc, argv);
	BS_Engine_play();
	BS_Engine_close();

	return 0;
}
