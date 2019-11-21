
module grayencoder ( ck, rst, A, B, C );
  input [7:0] A;
  output [7:0] B;
  output [7:0] C;
  input ck, rst;
  wire   N0, N1, N2, N3, N4, N5, N6, n1, n2, n3;
  wire   [5:1] BTMP;

  DFFR_X1 buss_reg_7_ ( .D(A[7]), .CK(ck), .RN(n1), .Q(B[7]) );
  DFFR_X1 buss_reg_6_ ( .D(N6), .CK(ck), .RN(n1), .Q(B[6]) );
  DFFR_X1 buss_reg_5_ ( .D(N5), .CK(ck), .RN(n1), .Q(B[5]) );
  DFFR_X1 buss_reg_4_ ( .D(N4), .CK(ck), .RN(n1), .Q(B[4]) );
  DFFR_X1 buss_reg_3_ ( .D(N3), .CK(ck), .RN(n1), .Q(B[3]) );
  DFFR_X1 buss_reg_2_ ( .D(N2), .CK(ck), .RN(n1), .Q(B[2]) );
  DFFR_X1 buss_reg_1_ ( .D(N1), .CK(ck), .RN(n1), .Q(B[1]) );
  DFFR_X1 buss_reg_0_ ( .D(N0), .CK(ck), .RN(n1), .Q(B[0]) );
  DFFR_X1 BTMP_reg_7_ ( .D(B[7]), .CK(ck), .RN(n1), .Q(C[7]) );
  DFFR_X1 BTMP_reg_6_ ( .D(B[6]), .CK(ck), .RN(n1), .QN(n3) );
  DFFR_X1 BTMP_reg_5_ ( .D(B[5]), .CK(ck), .RN(n1), .Q(BTMP[5]) );
  DFFR_X1 BTMP_reg_4_ ( .D(B[4]), .CK(ck), .RN(n1), .Q(BTMP[4]) );
  DFFR_X1 BTMP_reg_3_ ( .D(B[3]), .CK(ck), .RN(n1), .Q(BTMP[3]) );
  DFFR_X1 BTMP_reg_2_ ( .D(B[2]), .CK(ck), .RN(n1), .Q(BTMP[2]) );
  DFFR_X1 BTMP_reg_1_ ( .D(B[1]), .CK(ck), .RN(n1), .Q(BTMP[1]) );
  DFFR_X1 BTMP_reg_0_ ( .D(B[0]), .CK(ck), .RN(n1), .QN(n2) );
  INV_X1 U18 ( .A(rst), .ZN(n1) );
  XOR2_X1 U19 ( .A(A[7]), .B(A[6]), .Z(N6) );
  XOR2_X1 U20 ( .A(A[6]), .B(A[5]), .Z(N5) );
  XOR2_X1 U21 ( .A(A[5]), .B(A[4]), .Z(N4) );
  XOR2_X1 U22 ( .A(A[4]), .B(A[3]), .Z(N3) );
  XOR2_X1 U23 ( .A(A[3]), .B(A[2]), .Z(N2) );
  XOR2_X1 U24 ( .A(A[2]), .B(A[1]), .Z(N1) );
  XOR2_X1 U25 ( .A(A[1]), .B(A[0]), .Z(N0) );
  XNOR2_X1 U26 ( .A(n2), .B(C[1]), .ZN(C[0]) );
  XOR2_X1 U27 ( .A(BTMP[1]), .B(C[2]), .Z(C[1]) );
  XOR2_X1 U28 ( .A(BTMP[2]), .B(C[3]), .Z(C[2]) );
  XOR2_X1 U29 ( .A(BTMP[3]), .B(C[4]), .Z(C[3]) );
  XOR2_X1 U30 ( .A(BTMP[4]), .B(C[5]), .Z(C[4]) );
  XOR2_X1 U31 ( .A(BTMP[5]), .B(C[6]), .Z(C[5]) );
  XNOR2_X1 U32 ( .A(C[7]), .B(n3), .ZN(C[6]) );
endmodule

