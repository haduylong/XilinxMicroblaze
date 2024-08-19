#ifndef _IO_RW_INCLUDE
#define _IO_RW_INCLUDE

#include "inttypes.h"
#ifdef __cplusplus
extern "C" {
#endif
// get slot address
#define get_slot_addr(mmio_base, slot)  ((uint32_t) (mmio_base + slot*32*4))

// I/O write
#define io_write(base_addr, offset, data) \
					(*(volatile uint32_t *) (base_addr + 4*offset) = data)

// I/O read
#define io_read(base_addr, offset) (*(volatile uint32_t *) (base_addr + 4*offset))

#ifdef __cplusplus
} // extern "C"
#endif

#endif // _IO_RW_INCLUDE
