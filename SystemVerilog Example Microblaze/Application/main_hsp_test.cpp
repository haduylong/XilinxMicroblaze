#include "gpio_cores.h"
// define test function
void timer_check(GpoCore *led, int n){
	int i;

	for(i=0; i<n; i++){
		led->write(0xffff);
		sleep_ms(500);
		led->write(0x0000);
		sleep_ms(500);
	}
}

void led_check(GpoCore *led, int n){
	int i;

	for(i=0; i<n; i++){
		led->write(1, i);
		sleep_ms(200);
		led->write(0, i);
		sleep_ms(200);
	}
}

void sw_check(GpoCore *led, GpiCore *sw){
	int i, s;

	s = sw->read();
	for(i=0; i<50; i++){
		led->write(s);
		sleep_ms(500);
		led->write(0);
		sleep_ms(500);
	}
}

// instance
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));

int main(){
	while(1){
		timer_check(&led, 10);
		led_check(&led, 10);
		sw_check(&led, &sw);
	}
}
