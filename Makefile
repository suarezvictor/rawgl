
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LIBS = `sdl2-config --libs` -lSDL2_mixer -lGL

DEFINES = -DBYPASS_PROTECTION -DUSE_GL -DDISABLE_AUDIO

CXXFLAGS := -g -O -MMD -Wall -Wpedantic $(SDL_CFLAGS) $(DEFINES)

SRCS = aifcplayer.cpp bitmap.cpp file.cpp engine.cpp graphics_gl.cpp graphics_soft.cpp \
	script.cpp mixer.cpp pak.cpp resource.cpp resource_nth.cpp \
	resource_win31.cpp resource_3do.cpp scaler.cpp screenshot.cpp systemstub_sdl.cpp sfxplayer.cpp \
	staticres.cpp unpack.cpp util.cpp video.cpp main.cpp

OBJS = $(SRCS:.cpp=.o)
DEPS = $(SRCS:.cpp=.d)

rawgl: $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(SDL_LIBS) -lz

HEADERS = file.h intern.h script.h mixer.h resource.h resource_nth.h resource_3do.h resource_win31.h \
sfxplayer.h video.h aifcplayer.h bitmap.h engine.h graphics.h pak.h scaler.h screenshot.h \
script.h systemstub.h unpack.h util.h 

another.cpp: $(SRCS)
	cat $(SRCS:graphics_gl.cpp=) > another.cpp.tmp
	grep "^#include <" another.cpp.tmp | awk '!x[$$0]++' > another_linux.h
	#echo "#include \"another.h\"" > another.cpp
	cat $(HEADERS) | grep ^\#include -v >> another.cpp
	grep ^\#include -v another.cpp.tmp >> another.cpp
	rm another.cpp.tmp
	
	
singlesrc: another.cpp
	$(CXX) `sdl2-config --cflags` -DDISABLE_AUDIO -DBYPASS_PROTECTION -o rawgl -O2 -include another_linux.h another.cpp `sdl2-config --libs` -lz

clean:
	rm -f $(OBJS) $(DEPS)
	rm -f another.cpp another_linux.h

-include $(DEPS)
