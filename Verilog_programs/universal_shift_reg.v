module universal_shift_register(
    input [3:0] i, // Define pins for parallel input
    input [1:0] sel, // Define select line pins to choose the operation
    input clk, rst, il, ir, // Define clock,reset, serial input for
    // shift left and serial input for shift right
    output reg [3:0] out_bit // Define output pins
);

// Execute the logic whenever positive edge of
// clock or negative edge of Reset is encountered
always @ (posedge clk, negedge rst) begin
    if(rst==0) // if rst = 0, then clear the output
        out_bit=4'b000;
    else begin
        case(sel) //check select lines to determine type of
        //operation
        2'b00:begin end //Retain the data
        2'b01:begin
            out_bit={ir,out_bit[3:1]}; //shift right operation
        end
        2'b10:begin
            out_bit={out_bit[2:0],il}; //Shift left operation
        end
        2'b11:begin
            out_bit = i; //parallel input-output operation
        end
        default:begin end
        endcase
    end
end

endmodule
