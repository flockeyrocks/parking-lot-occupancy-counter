`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2021 04:01:24 PM
// Design Name: 
// Module Name: sseg_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sseg_driver
    #(parameter DesiredHz = 1,ClockHz = 100_000_000)
    (
        input clk,
        input reset_n,
        input [5:0]i0,i1,i2,i3,i4,i5,i6,i7,         //numbers
        output [7:0]AN,                             //seven-segment selector output
        output DP,
        output [6:0]sseg
    );
    
    localparam iteration = ClockHz / DesiredHz;
    wire done;                                      //  1 when the timer finishes a counting
    wire [2:0]inputSelector;                        // select the input to be displayed
    reg [5:0]D_out;                                 // the output of Mux
    wire [7:0]ANgen_Out;                            // the output of ANgenerator(AN decoder)

    always @(*) begin                               // pick value from ix
        D_out = i0;
        case(inputSelector) 
            0: D_out = i0;
            1: D_out = i1;
            2: D_out = i2;
            3: D_out = i3;
            4: D_out = i4;
            5: D_out = i5;
            6: D_out = i6;
            7: D_out = i7;
            default: D_out = i0;
        endcase
    end
    
    timer_input #($clog2(iteration)) timer          // count once according to the desired Hz/speed. 
    (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1),
        .FINAL_VALUE(iteration),
    //    output [BITS - 1:0] Q,                    
        .done(done)
    );
    
    udl_counter #(3) counter (                      // we only need 8 numbers, so bits = 3
    .clk(clk),
    .reset_n(reset_n),
    .enable(done),                                  // enable everytime the timer completes a count
    .up(1), //when asserted the counter is up counter; otherwise, it is a down counter
    .load(0),                                       // no need for loading
    .D(),                                           // no need for a new number
    .Q(inputSelector)                               
    );
    
    decoder_generic #(3) ANgenerator                // generate AN with opposite order
    (
        .w(inputSelector),                          // select a AN
        .en(D_out[5]),
        .y(ANgen_Out)
    );
    
    wire [7:0] reverseAN = {<<{ANgen_Out}};         // reverse the order of AN
    assign AN = ~reverseAN;                         // inverse bits to get the correct AN inputs
    
    hex2sseg HEX2SSEG
    (
      .hex(D_out[4:1]),
      .sseg(sseg) //arranged as gfedcba  
    );
    
    assign DP = D_out[0];
    
    
endmodule
