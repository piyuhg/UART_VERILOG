module piso(dout, din, load, shift, clk, rst);
	input [7:0]din;
	input load, shift, clk, rst;
	output reg dout;
	reg [7:0] inter;
	integer count = 0;
	always@(posedge clk) begin
		if(rst) begin
			inter <= 0;
			dout <= 0;
			count = 0;
		end
		else begin
			if(load)
				inter <= din;
			else if(shift) begin
				dout <= inter[0];
				inter <= inter>>1;
				count = count + 1;
			end
		end
	end
endmodule
