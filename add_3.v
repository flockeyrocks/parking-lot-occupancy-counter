`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2021 05:00:06 PM
// Design Name: 
// Module Name: add_3
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


module add_3(
    input [3:0] x,
    output reg [3:0] y
    );
    /*
    always@(x) begin
        if(y<5)
            y = x;
        else if(y<10)
            y = x + 3;
        else
            y = 'bxxxx;
    end
    */
    
    always@(x) begin
        case(x)
        0:y = 4'b0000;
        1:y = 4'b0001;
        2:y = 4'b0010;
        3:y = 4'b0011;
        4:y = 4'b0100;
        5:y = 4'b1000;
        6:y = 4'b1001;
        7:y = 4'b1010;
        8:y = 4'b1011;
        9:y = 4'b1100;
        default: y = 'bx;
        endcase
    end
        
    
endmodule
