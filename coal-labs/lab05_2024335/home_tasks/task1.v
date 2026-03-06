module DivisionT1 (
    input wire clk,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg ready
);

    reg [7:0] prev_dividend = 8'h0;
    reg [7:0] prev_divisor = 8'h0;

    reg [15:0] rem_reg;
    reg [15:0] div_reg;
    reg [3:0]  step;
    reg        busy = 0;

    initial begin
        quotient = 0;
        remainder = 0;
        ready = 0;
    end

    always @(posedge clk) begin
        if (dividend != prev_dividend || divisor != prev_divisor) begin
            prev_dividend <= dividend;
            prev_divisor  <= divisor;
            
            rem_reg  <= {8'b0, dividend};
            div_reg  <= {1'b0, divisor, 7'b0};
            quotient <= 8'b0;
            
            step  <= 0;
            busy  <= 1;
            ready <= 0;
        end else if (busy) begin
            if (rem_reg >= div_reg) begin
                rem_reg  <= rem_reg - div_reg;
                quotient <= {quotient[6:0], 1'b1};
                if (step == 7) begin
                    remainder <= rem_reg[7:0] - div_reg[7:0];
                end
            end else begin
                quotient <= {quotient[6:0], 1'b0};
                if (step == 7) begin
                    remainder <= rem_reg[7:0];
                end
            end
            
            div_reg <= div_reg >> 1;
            step    <= step + 1;
            
            if (step == 7) begin
                busy  <= 0;
                ready <= 1;
            end
        end
    end

endmodule