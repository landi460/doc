
module busnormal ( ck, rst, A, B, C );
  input [7:0] A;
  output [7:0] B;
  output [7:0] C;
  input ck, rst;
  wire   n1;

  DFFR_X1 buss_reg_7_ ( .D(A[7]), .CK(ck), .RN(n1), .Q(B[7]) );
  DFFR_X1 buss_reg_6_ ( .D(A[6]), .CK(ck), .RN(n1), .Q(B[6]) );
  DFFR_X1 buss_reg_5_ ( .D(A[5]), .CK(ck), .RN(n1), .Q(B[5]) );
  DFFR_X1 buss_reg_4_ ( .D(A[4]), .CK(ck), .RN(n1), .Q(B[4]) );
  DFFR_X1 buss_reg_3_ ( .D(A[3]), .CK(ck), .RN(n1), .Q(B[3]) );
  DFFR_X1 buss_reg_2_ ( .D(A[2]), .CK(ck), .RN(n1), .Q(B[2]) );
  DFFR_X1 buss_reg_1_ ( .D(A[1]), .CK(ck), .RN(n1), .Q(B[1]) );
  DFFR_X1 buss_reg_0_ ( .D(A[0]), .CK(ck), .RN(n1), .Q(B[0]) );
  DFFR_X1 C_reg_7_ ( .D(B[7]), .CK(ck), .RN(n1), .Q(C[7]) );
  DFFR_X1 C_reg_6_ ( .D(B[6]), .CK(ck), .RN(n1), .Q(C[6]) );
  DFFR_X1 C_reg_5_ ( .D(B[5]), .CK(ck), .RN(n1), .Q(C[5]) );
  DFFR_X1 C_reg_4_ ( .D(B[4]), .CK(ck), .RN(n1), .Q(C[4]) );
  DFFR_X1 C_reg_3_ ( .D(B[3]), .CK(ck), .RN(n1), .Q(C[3]) );
  DFFR_X1 C_reg_2_ ( .D(B[2]), .CK(ck), .RN(n1), .Q(C[2]) );
  DFFR_X1 C_reg_1_ ( .D(B[1]), .CK(ck), .RN(n1), .Q(C[1]) );
  DFFR_X1 C_reg_0_ ( .D(B[0]), .CK(ck), .RN(n1), .Q(C[0]) );
  INV_X1 U4 ( .A(rst), .ZN(n1) );
endmodule

