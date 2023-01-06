module GEN_PWM #(parameter G_PWM_PERIOD_CYCLES)(
    input logic clk,
    input logic reset, 
    input logic update,
    input logic [15:0] PWM_DUT_CYCLES, //number of clk cycles in a single HIGH duty cycle of PWM cycle
    output logic PWM_OUT //pwm output signal
);

logic pulse, en;
logic [15:0] currDut;

//only enable flop to change value on update signal AND on the next pulse
assign en = update && pulse; 

always_ff @(posedge clk) begin
    if (reset) currDut <= 0;
    else if (en) currDut <= PWM_DUT_CYCLES;
end

//instantiate pulse generation and duty cycle generation modules
ff_PWM #(G_PWM_PERIOD_CYCLES) ffpwm(.clk(clk), .reset(reset), .pulse(pulse));
ff_DUT ffdut(.clk(clk), .reset(reset), .PWM_DUT_CYCLES(currDut), .pulse(pulse), .PWM_OUT(PWM_OUT));

endmodule

module ff_PWM #(parameter G_PWM_PERIOD_CYCLES)(
    input logic clk,
    input logic reset,
    output logic pulse //pulse goes high every T_PWM
);

logic [15:0] cnt; //counter counts up to number of cycles in PWM period

always_ff @(posedge clk) begin
    if (reset || pulse) cnt <= 1; //reset on number of cycles reached or reset
    else cnt <= cnt +1; 
end

assign pulse = (G_PWM_PERIOD_CYCLES == cnt); //pulse goes high on every T_PWM

endmodule

module ff_DUT(
    input logic clk, 
    input logic reset,
    input logic pulse, //pulse that goes high every T_PWM
    input logic [15:0] PWM_DUT_CYCLES, //number of cycles for HIGH duty cycle
    output logic PWM_OUT //pwm output signal
);

logic [15:0] cnt;
logic RegReset;

assign RegReset = reset || pulse; //reset register on reset or pulse high


always_ff @(posedge clk) begin
    if (RegReset) cnt <= 0;
    else cnt <= cnt + 1;
end

assign PWM_OUT = (cnt < PWM_DUT_CYCLES);

endmodule
