module uart(RX_DATA_out, parity_bit_error, stop_bit_error, TX_busy, TX_DATA,TX_start,baud_rate, clk, rst);
	
	input [7:0]TX_DATA;
	input TX_start;
	input [15:0] baud_rate;//15'd0325
	input clk, rst;
	
	output [7:0] RX_DATA_out;
	output parity_bit_error, stop_bit_error, TX_busy;

	wire baud_clk;
	reg RX_IN;
	wire TX_DATA_out;

	always@(TX_DATA_out)
		RX_IN = TX_DATA_out;	
	
	baud_rate_gen baud_gen(baud_clk, baud_rate, clk, rst);
	transmitter tx1(TX_DATA_out, TX_busy, TX_start, TX_DATA, baud_clk,rst);
	receiver rx1(RX_DATA_out, parity_bit_error, stop_bit_error, RX_IN, baud_clk, rst);

endmodule

module tb_uart;
	reg clk = 1;
	wire baud_clk;
	reg [15:0] baud_rate;
	reg TX_start;
	reg [7:0] TX_DATA;
	wire TX_busy;
	wire parity_bit_error;
	wire stop_bit_error;
	wire [7:0] RX_DATA_out;
	reg rst;

	uart uart1(RX_DATA_out, parity_bit_error, stop_bit_error, TX_busy, TX_DATA,TX_start,baud_rate, clk, rst);	
	baud_rate_gen baud_gen(baud_clk, baud_rate, clk, rst);
	initial forever #100 clk = ~clk;
	initial baud_rate = 16'd325;

	initial begin
		rst = 1;
		TX_DATA = 8'ha2;
		#2100 rst = 0;
		#2100 TX_start = 1;
	end
endmodule
