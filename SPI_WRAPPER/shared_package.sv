package shared_package;
typedef enum logic [2:0] {
OR_OP = 3'b000,
XOR_OP = 3'b001,
ADD_OP = 3'b010,
MUL_OP = 3'b011,
SHIFT_OP = 3'b100,
ROT_OP = 3'b101,
INVALID_6 = 3'b110,
INVALID_7 = 3'b111
} opcode_e;

localparam logic signed [2:0] MAXPOS = 3; 
localparam logic signed [2:0] ZERO = 0; 
localparam logic signed [2:0] MAXNEG = -4; 
endpackage