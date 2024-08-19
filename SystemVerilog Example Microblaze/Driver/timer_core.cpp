#include "timer_core.h" // __#include "io_rw.h" // __#include "inttypes.h"
						// __#include "io_map.h"

TimerCore::TimerCore(uint32_t core_base_addr){
	base_addr = core_base_addr;
	ctrl = 0x01;
	io_write(base_addr, CTRL_REG, ctrl); // enable time
}

TimerCore::~TimerCore(){ }

void TimerCore::pause(){
	// set go bit to 0
	ctrl &= ~GO_FIELD;
	io_write(base_addr, CTRL_REG, ctrl);
}

void TimerCore::go(){
	// set go bit to 1
	ctrl |= GO_FIELD;
	io_write(base_addr, CTRL_REG, ctrl);
}

void TimerCore::clear(){
	uint32_t wr_data;

	// write clear bit in 1 clock
	// do not effect to ctrl
	wr_data = ctrl | CLR_FIELD;		// set clear bit to 1
	io_write(base_addr, CTRL_REG, wr_data);
}

uint64_t TimerCore::read_tick(){
	uint64_t upper, lower;

	lower = (uint64_t) io_read(base_addr, COUNTER_LOWER_REG);
	upper = (uint64_t) io_read(base_addr, COUNTER_UPPER_REG);
	return ((upper<<32) | lower);
}

uint64_t TimerCore::read_time(){
	// read time in microsecond (SYS_CLK_FREQ MHz)
	return (read_tick() / SYS_CLK_FREQ);
}

void TimerCore::sleep(uint64_t us){
	uint64_t start_time, now;

	start_time = read_time();
	do {
		now = read_time();
	} while ((now - start_time) < us);
}
