// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

//Duration Of Bit = 1/BaudRate = 1/230400 ≈ 4340ns

//Clocks Per Bit = Duration Of Bit/Time Period of Clock = 4340ns/320ns = 14
//
//OR
//
//Clocks Per Bit = Clock Period/BuadRate = 3125K/230400 ≈ 14
//
//Clock Per Bit represents the clock cycles that a single bit must remains on the serial line.

// Add your code here...

parameter idle = 3'b000 ,start = 3'b001, data_tx = 3'b010, parity = 3'b011, stop = 3'b100,clk_per_bit = 4'd14;
reg [2:0]state = 1;
reg [2:0]i ;
reg [3:0]count=0;
//reg parity_bit=0;
//reg [7:0]tx_data = 0;

initial begin
    tx = 1;
    tx_done = 0;
	 i = 3'b111;
end

always@(posedge clk_3125) begin
	//parity_bit <= (data[0] ^ data[1] ^data[2]^data[3]^data[4]^data[5]^data[6]^data[7]);	
		
		case(state) 
		idle:
		begin
				tx<=1'b1;
				tx_done <= 1'b0;
				count<=0;
				i<=7;
				
				if(tx_start==1'b1) begin
				   tx <=1'b0;
					state <= start;
					count<=1;
				end
				else begin
					state <= idle;
				end
		
		
		end
		
		start : 
		begin
				tx <= 1'b0;
				//tx_data <= data;				
				if(count < clk_per_bit-1) begin
					state <= start;
					count <= count +1'b1;
				end
				else begin
					count <= 0;
					state <= data_tx;
				end
		end
		
		data_tx :
		begin 
			tx <= data[i];	
			if(count<clk_per_bit-1) begin
				state<=data_tx;
				count<= count +1'b1;
			end
			else begin
			   count<=0;
				if(i>0) begin
					i<=i-1'b1;
					state <= data_tx;
				end
				else begin
					i<=7;
					state <= parity;
				end
			end
//			if(data[i]==1'b1) begin
//				parity_count <= parity_count+1;
//			end
		end
		
		parity : 
		begin
		  tx = (data[0] ^ data[1] ^data[2]^data[3]^data[4]^data[5]^data[6]^data[7]);		
			if(count<clk_per_bit-1) begin
		      state <= parity;
				count <= count+1'b1;
			end
			else begin
				count<=0;
				state <= stop;
			end
		end
		
		stop : 
		begin
			tx <= 1'b1;
			if(count<clk_per_bit-1) begin
				state <= stop;
				count <=count+1'b1;
			end
			else begin
				tx_done <= 1'b1;
				state  <= idle;
				count<= 0;
			end
		
		end
/*		
		done:
		begin 
				tx_done <=1'b0;
				state <= idle;
		end
		
		default : 
		begin
				state<=idle;
		end*/
	endcase
end
		
				
		
		
		
		
		
		
		
		
		
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

