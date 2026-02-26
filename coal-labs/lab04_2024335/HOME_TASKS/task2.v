module mul8s_seq (
    input        clk,
    input        rst,
    input  signed [7:0] a,
    input  signed [7:0] b,
    output reg signed [15:0] y,
    output reg   ready
);

    reg signed [15:0] multiplicand;
    reg signed [7:0]  multiplier;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            ready <= 0;
            count <= 0;
        end else begin
            if (count == 0) begin
                multiplicand <= {{8{a[7]}}, a}; // sign extension
                multiplier   <= b;
                y <= 0;
                ready <= 0;
                count <= 1;
            end
            else if (count <= 8) begin
                if (multiplier[0])
                    y <= y + multiplicand;

                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >>> 1;
                count <= count + 1;

                if (count == 8)
                    ready <= 1;
            end else begin
                // Idle: hold result until reset
                ready <= 1;
            end
        end
    end
endmodule