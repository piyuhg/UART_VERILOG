module mux_41(y, a, b, c, d, s);
	input a, b, c, d;
	input [1:0] s;
	output y;

	assign y = s[1]?(s[0]?d:c):(s[0]?b:a);

endmodule
