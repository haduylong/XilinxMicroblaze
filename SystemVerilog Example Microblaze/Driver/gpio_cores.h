#ifndef _GPIO_CORES_INCLUDE
#define _GPIO_CORES_INCLUDE

#include "init.h" // __#include "timer_core.h" // __#include "io_rw.h" // __#include "inttypes.h"
											   // __#include "io_map.h"

#ifdef __cplusplus
extern "C" {
#endif

class GpoCore{
	/* register map */
	enum {
		DATA_REG = 0 // data register
	};
public:
	GpoCore(uint32_t core_base_addr);
	~GpoCore();
	/* method */
	void write(uint32_t data);					// write 32-bit word
	void write(int bit_value, int bit_pos);		// write 1-bit
private:
	uint32_t base_addr;
	uint32_t wr_data;
};

class GpiCore{
	/* register map */
	enum {
		DATA_REG = 0 // data register
	};
public:
	GpiCore(uint32_t core_base_addr);
	~GpiCore();
	/* method */
	uint32_t read();				// read 32-bit word
	int read(int bit_pos);			// read 1-bit
private:
	uint32_t base_addr;
};

#ifdef __cplusplus
}
#endif

#endif
