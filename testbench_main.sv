module testbench();
   logic              clk,  reset;
   logic [3:0] channel,unused;
   logic [15:0] dutycycle;

   logic [31:0]    vectornum, errors;
   logic [24:0]       testvectors[10000:0];
   logic [15:0] pwmout;
   logic tready , tvalid;
   logic [23:0] tdata;
   // instantiate device under test
   // axis_pwm module with 16 channels and a PWM period of 100*t_clk
   axis_pwm #(16,100) dut(.clk(clk),.rst(reset), .pwm_out(pwmpulse out), .axis_in_tvalid(tvalid), .axis_in_tdata(tdata), .axis_in_tready(tready));
   // generate clock
   always
      begin
           clk = 1; #5; clk = 0; #5;
      end
   // at start of test, load vectors
   // and pulse reset
   initial
      begin
          $readmemb("axis_sim1.tv", testvectors);
           vectornum = 0; errors = 0;
           reset = 1; #22; reset = 0;
      end
   // apply test vectors on rising edge of clk
   always @(posedge clk)
      begin
           
           #1; {tdata,tvalid} = testvectors[vectornum];
		{unused, channel,dutycycle} = tdata;
      end
   // increment test case on falling edge of clk
   always @(negedge clk)
         vectornum = vectornum+1;
endmodule
