`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2021 05:16:56 PM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
    input [7:0] binary,
    output [11:0] BCD
    );
    // column: count 1 from the left.
    // row: count 1 from the bottom
   
    wire [4:0] A0Row1,A1Row1,A2Row1,A3Row1;                             // Row1's pins are denoted by A0....A3, S0...S3.
    wire [4:0] S0Row1,S1Row1,S2Row1,S3Row1;
    
    wire [3:0] AiRow2Column1,AiRow2Column2,SiRow2Column1,SiRow2Column2; // Row2's pins are denoted by Ai,Si with row# and column#
    
    // wire up add_3 on row 1
    generate
    genvar i;
        for(i=0;i<5;i=i+1) begin
            add_3 addRow1
            (
                .x({A3Row1[i],A2Row1[i],A1Row1[i],A0Row1[i]}),
                .y({S3Row1[i],S2Row1[i],S1Row1[i],S0Row1[i]})
            );
        end 
    endgenerate
    // wire up add_3 on row2
    add_3 addRow2Column1
    (
        .x(AiRow2Column1),
        .y(SiRow2Column1)
    );
    
    add_3 addRow2Column2
    (
        .x(AiRow2Column2),
        .y(SiRow2Column2)
    );
    
    // wire up input and output for add_3s and BCD result.
    assign A0Row1 = binary[5:1];
    assign A1Row1 = {binary[6],S0Row1[4:1]};
    assign A2Row1 = {binary[7],S1Row1[4:1]};
    assign A3Row1 = {1'b0,S2Row1[4:1]};
    assign AiRow2Column1 = {1'b0,S3Row1[4:2]};
    assign AiRow2Column2 = {SiRow2Column1[2:0],S3Row1[1]};
    
    assign BCD[0] = binary[0];
    assign BCD[4:1] = {S3Row1[0],S2Row1[0],S1Row1[0],S0Row1[0]};
    assign BCD[8:5] = SiRow2Column2;
    assign BCD[9] = SiRow2Column1[3];
    assign BCD[11:10] = {2'b00};
    
endmodule
