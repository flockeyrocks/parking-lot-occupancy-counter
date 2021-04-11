`timescale 1ns / 1ps

module parking_sensor(
        input clk, a, b, reset_n, load,
        output [7:0]AN,
        output DP,
        output [6:0]sseg
    );
    
    wire a_debounced,b_debounced;
    wire enter,exit;
    wire [1:0] sensor;
    localparam s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6;
    reg [2:0] state_reg,state_next;
    
    debouncer_delayed debouncerA(
        .clk(clk), 
        .reset_n(reset_n),
        .noisy(a),
        .debounced(a_debounced)
    );
    
    debouncer_delayed debouncerB(
        .clk(clk), 
        .reset_n(reset_n),
        .noisy(b),
        .debounced(b_debounced)
    );
    
    
    assign sensor = {a_debounced, b_debounced};
    
    always@(posedge clk,negedge reset_n) 
    begin
        if(~reset_n)    
            state_reg <= s0;
        else
            state_reg <= state_next;
     end
     
     always@(*) 
     begin
        case(state_reg)
            s0: case(sensor)
                    2'b00:state_next = s0;       
                    2'b01:state_next = s4;
                    2'b10:state_next = s1;
                    2'b11:state_next = s0;  
                endcase
            s1: case(sensor)
                    2'b00:state_next = s0;
                    2'b01:state_next = s0;
                    2'b10:state_next = s1;
                    2'b11:state_next = s2;      
                endcase
            s2: case(sensor)
                    2'b00:state_next = s0;  
                    2'b01:state_next = s3;
                    2'b10:state_next = s1; 
                    2'b11:state_next = s2;     
                endcase    
            s3: case(sensor)
                    2'b00:state_next = s0;  
                    2'b01:state_next = s3;  
                    2'b10:state_next = s0;  
                    2'b11:state_next = s2;  
                endcase    
            s4: case(sensor)
                    2'b00:state_next = s0;
                    2'b10:state_next = s0;  
                    2'b01:state_next = s4;  
                    2'b11:state_next = s5;  
                endcase  
            s5: case(sensor)
                    2'b00:state_next = s0;  
                    2'b01:state_next = s4;  
                    2'b10:state_next = s6;  
                    2'b11:state_next = s5;  
                endcase   
            s6: case(sensor)
                    2'b00:state_next = s0;  
                    2'b01:state_next = s0;  
                    2'b10:state_next = s6;  
                    2'b11:state_next = s5;  
                endcase
            default: state_next = state_reg;   
        endcase
     end
     
     assign enter = (state_reg == s3) & (sensor == 2'b00);
     assign exit = (state_reg == s6) & (sensor == 2'b00);
    
    //car count
    wire[7:0] count;
    
    //arbitrary load
    reg[7:0] D = 3'd111;
    
    udl_counter #(.BITS(8)) counter
    (
         .clk(clk),
         .reset_n(reset_n),
         .enable(enter|exit|load),
         .up(enter),
         .load(load),
         .D(D),
         .Q(count)
    );
    
    wire [11:0] BCD;
    
    bin2bcd convert(
        .binary(count),
        .BCD(BCD)
    );
    
    sseg_driver #(.DesiredHz(10000)) driver
    (
         .clk(clk),
         .reset_n(1),
         .i0({1'b1,BCD[3:0],1'b1}),
         .i1({1'b1,BCD[7:4],1'b1}),
         .i2({1'b1,BCD[11:8],1'b1}),
         .AN(AN),
         .DP(DP),
         .sseg(sseg)
    );
    
endmodule