module mul8u_seq (
    input        clk,
    input        rst,
    input  [7:0] a,
    input  [7:0] b,
    output reg [15:0] y,
    output reg   ready
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            multiplicand <= 0;
            multiplier   <= 0;
            y            <= 0;
            count        <= 0;
            ready        <= 0;
        end else begin
            if (count == 0) begin
                // load operands
                multiplicand <= {8'b0, a};
                multiplier   <= b;
                y            <= 0;
                ready        <= 0;
                count        <= 1;
            end else if (count <= 8) begin
                if (multiplier[0])
                    y <= y + multiplicand;

                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                count        <= count + 1;

                if (count == 8)
                    ready <= 1;
            end else begin
                // Idle: hold result until reset
                ready <= 1;
            end
        end
    end
endmodule