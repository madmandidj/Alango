#FLAGS = -g -ansi -pedantic -Wall -Wconversion -m32
INC_PATH = ./inc/
DLL_PATH = ./bin/
SRC_PATH = ./source/

all: BSPlayerX.o BSPlayerX.dll

BSPlayerX.dll: BSPlayerX.o $(DLL_PATH)BSEngine.dll 
	gcc -shared -o $(DLL_PATH)BSPlayerX.dll BSPlayerX.o $(DLL_PATH)BSEngine.dll 

BSPlayerX.o: $(SRC_PATH)BSPlayer.c $(INC_PATH)BSPlayer.h 
	gcc -c -DBUILDING_EXAMPLE_DLL $(SRC_PATH)BSPlayer.c -o BSPlayerX.o

clean:
	erase BSPlayerX.o .\bin\BSPlayerX.dll 
