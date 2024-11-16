// Verilog code in Dataflow style
module two_way_switch(
    input s1, s2, // Define two Inputs pins
    output z      // Define one output pin
);

assign z = (s1^s2); //XOR the 2 input pins(s1,s2) and assign

endmodule
