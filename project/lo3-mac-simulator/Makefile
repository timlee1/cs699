CC = gcc
LD = gcc
CFLAGS += -DDEBUG_FRAC
CFLAGS += -DDEBUG_ENABLE -g
LFLAGS += -lm

CFILES = coordinateToGraph.c handleDataSlot.c input.c routingPath.c fragment.c handlePackets.c scheduler.c handlePriorityQueue.c nodeStats.c simulation.c getEventStructures.c handleScheduleTxRx.c randomfunc.c handleContentionSlot.c rootfunc.c
OFILES = coordinateToGraph.o handleDataSlot.o input.o routingPath.o fragment.o handlePackets.o scheduler.o  handlePriorityQueue.o nodeStats.o simulation.o getEventStructures.o handleScheduleTxRx.o randomfunc.o handleContentionSlot.o rootfunc.o

PROG = lo3mac
all: $(PROG)
$(PROG): $(OFILES)
	$(LD) -o $(PROG) $(OFILES) $(LFLAGS)
$(OFILES): $(CFILES)
	$(CC) $(CFLAGS) -c $(CFILES)
clean:
	rm -f $(OFILES)
	rm -f *.c~ *.h~ *~
	rm -f flows/flow*
	rm -f logs/node*
	rm -f outputFiles/*
	rm -f lo3mac
	rm -f mobility/node*
	rm -f store_cap/*

