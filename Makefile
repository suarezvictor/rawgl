
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

another.cpp:
	cat $(SRCS:graphics_gl.cpp=) > another.cpp
	
singlesrc: another.cpp
	$(CXX) `sdl2-config --cflags` -DDISABLE_AUDIO -DBYPASS_PROTECTION -o rawgl another.cpp `sdl2-config --libs` -lz

clean:
	rm -f $(OBJS) $(DEPS)
	rm -f another.cpp

-include $(DEPS)
