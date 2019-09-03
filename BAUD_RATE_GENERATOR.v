module baud_rate_gen(next_bit, baud_rate, clk, rst);
	input clk, rst;
	input [15:0] baud_rate;
	output reg next_bit;
	reg [15:0] baud_rate_reg;
	always @(posedge clk, posedge rst) begin
    		if (rst) 
			baud_rate_reg <= 16'b1;
    		else if (next_bit) 
			baud_rate_reg <= 16'b1;
         	else 
			baud_rate_reg <= baud_rate_reg + 1'b1;
	end
	always@(baud_rate, baud_rate_reg)
		next_bit = (baud_rate_reg == baud_rate);

endmodule
