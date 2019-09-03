module transmitter(TX_DATA_out, TX_busy, TX_start, TX_DATA, clk,rst);
	input clk;
	input rst;
	input TX_start;
	input [7:0] TX_DATA;
	output TX_DATA_out;
	output reg TX_busy;
	reg [2:0] state, next_state;
	reg [1:0] select;
	reg load_data, shift_data, start_bit = 1'b0, data_bit, parity_bit, stop_bit = 1'b1;
	parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BIT = 3'b010, PARITY_BIT = 3'b011, STOP_BIT = 3'b100;
	integer count = 8;
	always@(state) begin
		case(state)
			IDLE: begin
				load_data = 0;
				shift_data = 0;
				select = 2'b11;
				TX_busy = 0;
			end
			START_BIT: begin
				TX_busy = 1;
				load_data = 1;
				shift_data = 0;
				@(posedge clk);
				select = 2'b00;
				count = 8;
				@(negedge clk);
				next_state = DATA_BIT;
			end
			DATA_BIT: begin
				load_data = 0;
				shift_data = 1;
				while(count)begin
					@(posedge clk);					
					select = 2'b01;					
					count = count - 1;
				end
				@(posedge clk);
				next_state = PARITY_BIT;
			end
			PARITY_BIT: begin
				load_data = 0;
				shift_data = 0;
				select = 2'b10;
				@(posedge clk);
				next_state = STOP_BIT;
			end
			STOP_BIT: begin
				load_data = 0;
				shift_data = 0;
				select = 2'b11;
				@(posedge clk);
				next_state = IDLE;
			end
		endcase
	end
	always@(next_state) 
		state = next_state;

	always@(posedge TX_start, posedge rst) begin
			if(rst)
				state = IDLE;
			else if(TX_start)	
				state = START_BIT;
	end	

	mux_41 mux1(TX_DATA_out, start_bit, data_bit, parity_bit, stop_bit, select);
	
	piso piso1(data_bit_wire , TX_DATA, load_data, shift_data, clk, rst);
	
	parity_gen pgen1(parity_bit_wire, TX_DATA);
	
	always@(data_bit_wire, parity_bit_wire) begin
		data_bit = data_bit_wire;
		parity_bit = parity_bit_wire;
	end

endmodule
