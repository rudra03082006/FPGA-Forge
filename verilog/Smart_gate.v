module Smart_gate(

    input CLOCK_50,      // 50 MHz clock from DE2 board

    input ir1,           // IR sensor 1 (open gate)
    input ir2,           // IR sensor 2 (close gate)

    output servo         // Servo PWM output
);

reg [31:0] pwm_counter = 0;
reg servo_pwm = 0;
reg gate_open = 0;

// 50 MHz clock → 20ms PWM period
parameter PERIOD = 1_000_000;

// pulse widths
parameter OPEN_PULSE  = 100000;   // ~2 ms
parameter CLOSE_PULSE = 50000;    // ~1 ms


always @(posedge CLOCK_50)
begin

    // -------- Gate control --------
    if(!ir1)
        gate_open <= 1'b1;   // open gate

    if(!ir2)
        gate_open <= 1'b0;   // close gate


    // -------- PWM counter --------
    if(pwm_counter >= PERIOD)
        pwm_counter <= 0;
    else
        pwm_counter <= pwm_counter + 1;


    // -------- Servo PWM --------
    if(gate_open) begin
        if(pwm_counter < OPEN_PULSE)
            servo_pwm <= 1'b1;
        else
            servo_pwm <= 1'b0;
    end
    else begin
        if(pwm_counter < CLOSE_PULSE)
            servo_pwm <= 1'b1;
        else
            servo_pwm <= 1'b0;
    end

end

assign servo = servo_pwm;

endmodule