module sipo(dout, din, enable, clk, rst);
	input din, clk, rst, enable;
	output reg [7:0] dout;
	always@(posedge clk) begin
		if(rst) begin
			dout <= 0;
		end
		else if(enable)begin
			dout = dout>>1;
			dout[7] = din;
		end
	end
endmodule
