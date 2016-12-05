CXX ?= g++
CFLAGS = -fopenmp -Wall -Wconversion -O3 -fPIC
SHVER = 2
OS = $(shell uname)

all: svm-predict svm-train 

lib: svm.o
	if [ "$(OS)" = "Darwin" ]; then \
		SHARED_LIB_FLAG="-dynamiclib -Wl,-install_name,libsvm.so.$(SHVER)"; \
	else \
		SHARED_LIB_FLAG="-shared -Wl,-soname,libsvm.so.$(SHVER)"; \
	fi; \
	$(CXX) $${SHARED_LIB_FLAG} svm.o -o libsvm.so.$(SHVER)

svm-predict: svm-predict.c svm.o
	$(CXX) $(CFLAGS) svm-predict.c svm.o -o svm-predict -lm
svm-train: svm-train.cpp svm.o
	$(CXX) $(CFLAGS) svm-train.cpp svm.o -o svm-train -lm

#svm-train: svm-train.c svm.o
#	$(CXX) $(CFLAGS) svm-train.c svm.o -o svm-train -lm

svm-train-mpi: svm-train-mpi.cpp svm.o
	$(MPICXX) $(CFLAGS) svm-train-mpi.cpp svm.o -o svm-train-mpi -lm

svm-scale: svm-scale.c
	$(CXX) $(CFLAGS) svm-scale.c -o svm-scale
svm.o: svm.cpp svm.h
	$(CXX) $(CFLAGS) -c svm.cpp
#	$(MPICXX) $(CFLAGS) -c svm.cpp
clean:
	rm -f *~ svm.o svm-train svm-predict svm-scale libsvm.so.$(SHVER)
