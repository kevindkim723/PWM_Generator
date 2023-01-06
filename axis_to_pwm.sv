module axis_pwm #(
    parameter G_NUM_CHANNELS,
    parameter G_PWM_PERIOD_CYCLES)pulse (
    // Clock & Reset
    input logic clk,
    input logic rst,
    // PWM Outputs
    output logic [G_NUM_CHANNELS-1:0] pwm_out,
    // Required AXI4-Stream Signals
    // Note: Other AXI4-Stream signals intentionally not included
    input logic axis_in_tvalid,
    input logic [23:0] axis_in_tdata,
    output logic axis_in_tready
);

logic [3:0] channel_adr; //pwm channel address
logic [15:0] duty_cycle; //duty cycle
logic [15:0] channel_adr_oh; //one-hot encoding of pwm channel address
logic en; //data register write enable

logic [23:0] currData, nextData;

assign axis_in_tready = 1'b1; //NOTE: the flip flop is always ready to shift in new data on every clock edge so it's perpetually in a ready state?

//unpack signals
assign channel_adr = currData[19:16];
assign duty_cycle = currData[15:0];

//data register write enable logic
assign en = axis_in_tready && axis_in_tvalid;

always_ff @(posedge clk) begin
    if (rst) currData <= 0;
    else if (en) currData <= axis_in_tdata;
end

//Generate PWM blocks
genvar i;
generate
    for (i = 0; i < G_NUM_CHANNELS; i=i+1) begin: forloop
        GEN_PWM #(G_PWM_PERIOD_CYCLES) gp(.clk(clk), .reset(rst), .update(channel_adr_oh[i]), .PWM_DUT_CYCLES(duty_cycle), .PWM_OUT(pwm_out[i]));
    end
endgenerate

//get one-hot encoding of channel address
decoder4_16 Dec4_16(channel_adr, channel_adr_oh); 

endmodule


//4 to 16 decoder logic
module decoder4_16(
    input logic [3:0] a,
    output logic [15:0] b
);

always_comb begin
    b = 0;
    b[a] = 1;
end

endmodule