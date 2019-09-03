module parity_gen(parity_bit, data_in);
	input [7:0] data_in;
	output parity_bit;

	assign parity_bit = ^data_in;

endmodule
