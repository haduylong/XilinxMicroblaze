#ifndef _IO_MAP_INCLUDE
#define _IO_MAP_INCLUDE

#ifdef __cplusplus
extern "C" {
#endif

#define SYS_CLK_FREQ  100 // MHz

// I/O base address for micorblaze (see in file .xsa)
#define BRIDGE_BASE  0xc0000000

// slot module definition
#define S0_SYS_TIMER	0
#define S1_UART1		1
#define S2_LED			2
#define S3_SW			3

#ifdef __cplusplus
} // extern "C"
#endif

#endif // _IO_MAP_INCLUDE
