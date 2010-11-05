#ifndef __INPUT_H__
#define __INPUT_H__

#include <configs.h>
#include <default.h>

enum input_type {
	INPUT_KEYBOARD			= 1,
	INPUT_MOUSE				= 2,
	INPUT_TOUCHSCREEN		= 3,
	INPUT_JOYSTICK			= 4,
	INPUT_ACCELEROMETER		= 5,
	INPUT_GYROSCOPE			= 6,
	INPUT_LIGHT				= 7,
	INPUT_MAGNETIC			= 8,
	INPUT_ORIENTATION		= 9,
	INPUT_PRESSURE			= 10,
	INPUT_PROXIMITY			= 11,
	INPUT_TEMPERATURE		= 12,
};

struct input_event {
	x_u32 time;
	enum input_type type;
	x_u32 code;
	x_u32 value;
};

struct input
{
	const char * name;
	enum input_type type;
	void (*probe)(void);
	void (*remove)(void);
};

struct input * search_input(const char * name);
x_bool register_input(struct input * input);
x_bool unregister_input(struct input * input);

void input_report(enum input_type type, x_u32 code, x_u32 value);
void input_sync(enum input_type type);

#endif /* __INPUT_H__ */
