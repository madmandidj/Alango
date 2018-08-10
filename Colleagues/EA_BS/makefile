FLAGS = -g -ansi -pedantic -Wall -Wconversion -m32
INC_PATH = ../../inc/
objects = BinarySearchTree.o TEST_BinarySearchTree.o


TEST_BinarySearchTree.out: $(objects) 
	gcc $(FLAGS) -o TEST_BinarySearchTree.out  $(objects)

TEST_BinarySearchTree.o: TEST_BinarySearchTree.c $(INC_PATH)BinarySearchTree.h $(INC_PATH)mu_test.h $(INC_PATH)ADTErr.h
	gcc $(FLAGS) -c TEST_BinarySearchTree.c

BinarySearchTree.o: BinarySearchTree.c $(INC_PATH)BinarySearchTree.h $(INC_PATH)ADTErr.h
	gcc $(FLAGS) -c BinarySearchTree.c

clean:
	rm $(objects) TEST_BinarySearchTree.out
