
#include "scaler.h"

const Scaler *findScaler(const char *name) {
	static Scaler s;
	return &s;
}
