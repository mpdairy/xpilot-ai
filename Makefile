help:
	@cat Makefile

clean:
	rm -rf build/*
	rm -rf install/*
	cd src/xpilot-4.5.5/ && make clean

dirs:
	mkdir -p build/
	mkdir -p install/bin
	mkdir -p install/include
	mkdir -p install/lib

xpilot: dirs
	mkdir -p build/
	cp -r src/xpilot-4.5.5 build/
	cp Local.config build/xpilot-4.5.5
	cd build/xpilot-4.5.5 \
	&& xmkmf -a \
	&& make CC='gcc -fPIC'
	mkdir -p build/bin
	cp build/xpilot-4.5.5/src/client/xpilot install/bin/
	cp build/xpilot-4.5.5/src/mapedit/xp-mapedit install/bin/
	cp build/xpilot-4.5.5/src/replay/xp-replay install/bin/

server: xpilot
	cp src/ai/globalAI.h src/ai/cmdlineAI.c src/ai/playerAI.c build/xpilot-4.5.5/src/server
	cd build/xpilot-4.5.5/src/server \
	&& gcc -fPIC -O -I../common/ -I../lib/ -Dlinux -D__amd64__ -D_POSIX_C_SOURCE=199309L -D_XOPEN_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -c -o playerAI.o playerAI.c \
	&& gcc -fPIC -O -I../common/ -I../lib/ -Dlinux -D__amd64__ -D_POSIX_C_SOURCE=199309L -D_XOPEN_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -c -o cmdlineAI.o cmdlineAI.c \
	&& gcc -fPIC -o xpilots -O alliance.o asteroid.o cannon.o cell.o cmdlineAI.o collision.o command.o contact.o event.o fileparser.o frame.o id.o item.o laser.o map.o metaserver.o netserver.o object.o objpos.o option.o parser.o play.o playerAI.o robot.o robotdef.o rules.o saudio.o sched.o score.o server.o ship.o shot.o showtime.o stratbot.o tuner.o update.o walls.o wildmap.o ../common/libxpcommon.a -lm
	cp build/xpilot-4.5.5/src/server/xpilots install/bin

lib: xpilot
	cp src/ai/clientAI.c src/ai/clientAI.h src/ai/defaultAI.c src/ai/paintdataAI.c src/ai/painthudAI.c src/ai/xpilotAI.c src/ai/cAI.c src/ai/xpilotai.h build/xpilot-4.5.5/src/client
	cd build/xpilot-4.5.5/src/client \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o clientAI.o clientAI.c \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o defaultAI.o defaultAI.c \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o paintdataAI.o paintdataAI.c \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o painthudAI.o painthudAI.c \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o xpilotAI.o xpilotAI.c \
	&& gcc -fPIC -O -I../common/ -I../../lib/ -Dlinux -D__i386__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFUNCPROTO=15 -DNARROWPROTO -DWINDOWSCALING -c -o cAI.o cAI.c \
	&& gcc -fPIC -o libxpilotai.so -shared -Wl,-soname,libxpilotai.so -O about.o blockbitmaps.o caudio.o clientAI.o colors.o configure.o datagram.o dbuff.o defaultAI.o gfx2d.o gfx3d.o guimap.o guiobjects.o join.o netclient.o paint.o paintdataAI.o painthudAI.o paintmap.o paintobjects.o paintradar.o query.o record.o sim.o syslimit.o talk.o talkmacros.o textinterface.o texture.o usleep.o welcome.o widget.o xeventhandlers.o xevent.o xinit.o cAI.o xpilotAI.o xpmread.o ../common/libxpcommon.a -lX11 -lm
	mkdir -p install/include
	cp src/ai/xpilotai.h install/include
	mkdir -p install/lib
	cp build/xpilot-4.5.5/src/client/libxpilotai.so install/lib

build: clean xpilot server lib
	echo "done"
