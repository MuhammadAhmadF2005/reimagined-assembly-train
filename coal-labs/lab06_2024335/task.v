module fp8_adder(
    input  [7:0] a, //8 bit input and outputs
    input  [7:0] b,
    output [7:0] sum
);

//let a[7] or the MSB be the sign bit as usual in FPs

wire signA = a[7];
wire signB = b[7];

wire [3:0] expA = a[6:3];
wire [3:0] expB = b[6:3];

wire [3:0] mantA = {1'b1, a[2:0]};
wire [3:0] mantB = {1'b1, b[2:0]};

reg signR;
reg [3:0] expR;
reg [4:0] mantR;

reg [3:0] mantA_shift;
reg [3:0] mantB_shift;

always @(*) begin

    if(expA > expB) begin
        expR = expA;
        mantA_shift = mantA;
        mantB_shift = mantB >> (expA - expB);
    end
    else begin
        expR = expB;
        mantA_shift = mantA >> (expB - expA);
        mantB_shift = mantB;
    end

    if(signA == signB) begin
        mantR = mantA_shift + mantB_shift;
        signR = signA;
    end
    else begin
        if(mantA_shift > mantB_shift) begin
            mantR = mantA_shift - mantB_shift;
            signR = signA;
        end
        else begin
            mantR = mantB_shift - mantA_shift;
            signR = signB;
        end
    end

    if(mantR[4]) begin
        mantR = mantR >> 1;
        expR = expR + 1;
    end

end

assign sum = {signR, expR, mantR[2:0]};

endmodule