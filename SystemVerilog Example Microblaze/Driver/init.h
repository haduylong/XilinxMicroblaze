#ifndef _INIT_INCLUDE
#define _INIT_INCLUDE

#include "timer_core.h" // __#include "io_rw.h" // __#include "inttypes.h"
						// __#include "io_map.h"
#include "uart_core.h"
// make timer visible by other code
extern TimerCore sys_timer;
extern UartCore uart;

// define debug function
void debug_off();
void debug_on(const char* str, int n1, int n2);

#ifndef _DEBUG
#define debug(str, n1, n2) debug_off();
#endif

#ifdef _DEBUG
#define debug(str, n1, n2) debug_on(str, n1, n2);
#endif

/* timing function */
unsigned long now_us();
unsigned long now_ms();
void sleep_us(unsigned long int t);
void sleep_ms(unsigned long int t);

/* bit manipulation macro */
#define bit_set(data, n)	( (data) |= (1UL << n) )
#define bit_clear(data, n)	( (data) &= ~(1UL << n) )
#define bit_toggle(data, n)	( (data) ^= (1UL << n) )
#define bit_read(data, n)	( (data >> n) & 0x01 )
#define bit_write(data, n, bit_value) \
		(bit_value? bit_set(data, n): bit_clear(data, n))
#define bit(n) (1UL << n)


#endif // _INIT_INCLUDE
