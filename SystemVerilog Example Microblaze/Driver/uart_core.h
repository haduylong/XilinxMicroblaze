#ifndef _UART_CORE_INCLUDE
#define _UART_CORE_INCLUDE

#include "io_rw.h" // __#include "inttypes.h"
#include "io_map.h"

#ifdef __cplusplus
extern "C" {
#endif

class UartCore {
	/* register map */
	enum {
		RD_DATA_REG	= 0,
		DVSR_REG = 1,
		WR_DATA_REG = 2,
		RM_RD_DATA_REG = 3
	};

	/* read field */
	enum {
		RX_DATA_FIELD = 0x000000ff,
		RX_EMPTY_FIELD = 0x00000100,
		TX_FULL_FIELD = 0x00000200
	};

public:
	UartCore(uint32_t core_base_addr);
	~UartCore();
	/* method */
	// basic
	void set_baud_rate(int baud);
	int rx_fifo_empty();
	int tx_fifo_full();
	void tx_byte(uint8_t byte);
	int rx_byte();

	// display
	void disp(char ch);
	void disp(const char *str);
	void disp(int n, int base, int len);
	void disp(int n, int base);
	void disp(int n);
	void disp(double f, int digit);
	void disp(double f);
private:
	uint32_t base_addr;
	int baud_rate;
	void disp_str(const char *str);
};

#ifdef __cplusplus
} // extern "C"
#endif

#endif
