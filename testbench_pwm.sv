//an alternative way to test this would be to use an oscilloscope
module testbench_pwm();
    logic clk, reset, update;
    logic pwm;
	

    //instantiate device under test
    GEN_PWM #(100) genpwm(.clk(clk), .reset(reset), .PWM_DUT_CYCLES(16'd50), .update(update),.PWM_OUT(pwm));

    initial
    begin
      reset <= 1; # 22; reset <= 0; //pulse reset
      update <= 1; # 1000; update <=0;
    end

    //generate clock to sequence tests
    always
        begin
            clk <= 1; # 5; clk <= 0; # 5;
        end
endmodule
