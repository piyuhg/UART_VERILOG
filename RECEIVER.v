module receiver(RX_DATA_out, parity_bit_error, stop_bit_error, RX_IN, clk, rst);
	input clk, rst;
	input RX_IN;
	output reg stop_bit_error, parity_bit_error;
	output reg [7:0] RX_DATA_out;
	reg [7:0] inter_rx_data = 0;
	reg sipo_din, RX_IN_reg;
	reg enable;
	reg start_bit_detect = 0;
	wire [7:0] sipo_dout;
	reg [1:0] state, next_state;
	wire parity_bit;
	integer count = 8;	
	parameter IDLE = 2'b00, DATA = 2'b01, PARITY = 2'b10, STOP = 2'b11;
	
	always@(state, RX_IN_reg) begin
		case(state)
			IDLE: begin
				count = 8;
				parity_bit_error = 0;
				stop_bit_error = 0;
				RX_DATA_out = 0;
				enable = 0;	
				if(RX_IN_reg == 0) begin
					start_bit_detect = 1;
					@(posedge clk);
					start_bit_detect = 0;
					next_state = DATA;
				end
				else begin
					@(posedge clk);
					next_state = IDLE;					
				end
			end
			DATA: begin
				enable = 1;	
				while(count) begin
					count = count - 1;
					 @(posedge clk);					
				end
				enable = 0;
				next_state = PARITY;
			end
			PARITY: begin
				inter_rx_data = sipo_dout;
				@(negedge clk);
				if(parity_bit==RX_IN_reg) begin
					parity_bit_error = 0;
					@(posedge clk);
					next_state = STOP;
				end
				else begin
					parity_bit_error = 1;
					@(posedge clk);
					next_state = IDLE;
				end
			end
			STOP: begin
				if(RX_IN_reg == 1)
					RX_DATA_out = inter_rx_data;
				else 
					stop_bit_error = 1;
				@(posedge clk);
				next_state = IDLE;
			end
		endcase
	end

	always@(posedge clk) begin
		RX_IN_reg = RX_IN;
		sipo_din = RX_IN;
	end

	always@(posedge rst)
		state <= IDLE;
	
	always@(next_state) 
		state <= next_state;
	
	sipo sp1(sipo_dout, sipo_din, enable, clk, rst);
	parity_gen pgen1(parity_bit, inter_rx_data);
	
endmodule
