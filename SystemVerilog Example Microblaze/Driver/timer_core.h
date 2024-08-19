#ifndef _TIMER_CORE_INCLUDE
#define _TIMER_CORE_INCLUDE

#include "io_rw.h" // __#include "inttypes.h"
#include "io_map.h"

#ifdef __cplusplus
extern "C" {
#endif

class TimerCore{
	/* register map */
	enum {
		COUNTER_LOWER_REG = 0,
		COUNTER_UPPER_REG = 1,
		CTRL_REG = 2
	};

	/* control field */
	enum {
		GO_FIELD = 0x00000001,		// bit 0 of control reg; enable
		CLR_FIELD = 0x00000002		// bit 1 of control reg; clear
	};
public:
	TimerCore(uint32_t core_base_addr);
	~TimerCore();
	/* method */
	void go();					// resume counter
	void pause();				// pause counter
	void clear();				// clear counter to 0
	uint64_t read_tick();		// read clock elapse
	uint64_t read_time();		// read time elapse (microsecond us)
	void sleep(uint64_t us);	// delay for us microsecond
private:
	uint32_t base_addr;
	uint32_t ctrl;			// state of control reg
};

#ifdef __cplusplus
} // extern "C"
#endif

#endif // _TIMER_CORE_INCLUDE
