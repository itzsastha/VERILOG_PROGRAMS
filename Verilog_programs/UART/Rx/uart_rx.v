// EcoMender Bot : Task 2A - UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Baudrate: 230400 

Input:  clk_3125 - 3125 KHz clock
        rx      - UART Receiver

Output: rx_msg - received input message of 8-bit width
        rx_parity - received parity bit
        rx_complete - successful uart packet processed signal
*/

// module declaration
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

parameter idle=3'b000, start = 3'b001,data = 3'b010,stop=3'b011,done=3'b100,parity=3'b101,delay=3'b110,clocks_per_bit = 4'd14;
reg [3:0]count = 0;
reg [2:0]i=7;
reg [2:0]state=6;
reg [7:0]rx_data=0; 
initial begin
    rx_msg = 0;
	 rx_parity = 0;
    rx_complete = 0;
	 count<=0;
end

// Add your code here....

always@(posedge clk_3125) begin
	
	case(state)
	delay:
	begin
			state<=idle;
	end
	idle: 
	begin
			count<=0;
			rx_complete<=1'b0;
			if(rx==1'b0) begin
			state<= start;
			count<=1;
			end
			else state <= idle;
			
	end
	
	start:
	begin
			if(count==(clocks_per_bit-1)/2)
			begin
				if(rx == 1'b0)
				begin
					count<=0;
					state <= data;
				end
				else state <= idle;
			end
			else
			begin
				count <= count +1'b1;
				state <= start;
			end
	end

	data:
	begin
			if(count<clocks_per_bit-1) 
			begin
				count <= count + 1'b1;
				state <= data;		
			end
			else
			begin
				count <= 0;
				rx_data[i] <= rx;
				if(i>0)
				begin
					i<=i-1'b1;
					state <= data;
				end
				else
				begin
					i<=3'b111;
					state <= parity;
				end
			end
	end
	parity:
	begin
				if(count<clocks_per_bit-1)
				begin
					count<=count + 1'b1;
					state <= parity;
				end
				else
				begin
					count<=0;
					state<=stop;	
				end
	
	
	
	end
	stop:
			begin
				if(count<clocks_per_bit-1)
				begin
					count<=count + 1'b1;
					state <= stop;
				end
				else
				begin
					count<=0;
					state<=done;	
				end
			end
		
			
	done:
			begin
			
			if(count==(clocks_per_bit-1)/2) begin
				rx_msg <= rx_data;
				rx_parity<= rx_data[0]^rx_data[1]^rx_data[2]^rx_data[3]^rx_data[4]^rx_data[5]^rx_data[6]^rx_data[7];
				rx_complete<=1'b1;
				state<=idle;
				count<=0;
			end
			else
			begin
				count<=count+1'b1;
				state<=done;
			end
			end
	endcase
end








//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////


endmodule

