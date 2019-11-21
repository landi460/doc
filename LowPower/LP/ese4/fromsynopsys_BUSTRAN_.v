
module transbased ( ck, rst, A, B, C );
  input [7:0] A;
  output [7:0] B;
  output [7:0] C;
  input ck, rst;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, n1, n2, n3, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n14, n15, n16, n17;
  wire   [7:0] CENC;

  DFFR_X1 buss_reg_7_ ( .D(N0), .CK(ck), .RN(n1), .Q(B[7]) );
  DFFR_X1 buss_reg_6_ ( .D(N1), .CK(ck), .RN(n1), .Q(B[6]) );
  DFFR_X1 buss_reg_5_ ( .D(N2), .CK(ck), .RN(n1), .Q(B[5]) );
  DFFR_X1 buss_reg_4_ ( .D(N3), .CK(ck), .RN(n1), .Q(B[4]) );
  DFFR_X1 buss_reg_3_ ( .D(N4), .CK(ck), .RN(n1), .Q(B[3]) );
  DFFR_X1 buss_reg_2_ ( .D(N5), .CK(ck), .RN(n1), .Q(B[2]) );
  DFFR_X1 buss_reg_1_ ( .D(N6), .CK(ck), .RN(n1), .Q(B[1]) );
  DFFR_X1 buss_reg_0_ ( .D(N7), .CK(ck), .RN(n1), .Q(B[0]) );
  DFFR_X1 CENC_reg_7_ ( .D(B[7]), .CK(ck), .RN(n1), .Q(CENC[7]), .QN(n3) );
  DFFR_X1 CENC_reg_6_ ( .D(B[6]), .CK(ck), .RN(n1), .Q(CENC[6]), .QN(n5) );
  DFFR_X1 CENC_reg_5_ ( .D(B[5]), .CK(ck), .RN(n1), .Q(CENC[5]), .QN(n7) );
  DFFR_X1 CENC_reg_4_ ( .D(B[4]), .CK(ck), .RN(n1), .Q(CENC[4]), .QN(n9) );
  DFFR_X1 CENC_reg_3_ ( .D(B[3]), .CK(ck), .RN(n1), .Q(CENC[3]), .QN(n11) );
  DFFR_X1 CENC_reg_2_ ( .D(B[2]), .CK(ck), .RN(n1), .Q(CENC[2]), .QN(n13) );
  DFFR_X1 CENC_reg_1_ ( .D(B[1]), .CK(ck), .RN(n1), .Q(CENC[1]), .QN(n15) );
  DFFR_X1 CENC_reg_0_ ( .D(B[0]), .CK(ck), .RN(n1), .Q(CENC[0]), .QN(n17) );
  DFFR_X1 CENCOLD_reg_7_ ( .D(CENC[7]), .CK(ck), .RN(n1), .QN(n2) );
  DFFR_X1 CENCOLD_reg_6_ ( .D(CENC[6]), .CK(ck), .RN(n1), .QN(n4) );
  DFFR_X1 CENCOLD_reg_5_ ( .D(CENC[5]), .CK(ck), .RN(n1), .QN(n6) );
  DFFR_X1 CENCOLD_reg_4_ ( .D(CENC[4]), .CK(ck), .RN(n1), .QN(n8) );
  DFFR_X1 CENCOLD_reg_3_ ( .D(CENC[3]), .CK(ck), .RN(n1), .QN(n10) );
  DFFR_X1 CENCOLD_reg_2_ ( .D(CENC[2]), .CK(ck), .RN(n1), .QN(n12) );
  DFFR_X1 CENCOLD_reg_1_ ( .D(CENC[1]), .CK(ck), .RN(n1), .QN(n14) );
  DFFR_X1 CENCOLD_reg_0_ ( .D(CENC[0]), .CK(ck), .RN(n1), .QN(n16) );
  INV_X1 U20 ( .A(rst), .ZN(n1) );
  XOR2_X1 U21 ( .A(B[0]), .B(A[0]), .Z(N7) );
  XOR2_X1 U22 ( .A(B[1]), .B(A[1]), .Z(N6) );
  XOR2_X1 U23 ( .A(B[2]), .B(A[2]), .Z(N5) );
  XOR2_X1 U24 ( .A(B[3]), .B(A[3]), .Z(N4) );
  XOR2_X1 U25 ( .A(B[4]), .B(A[4]), .Z(N3) );
  XOR2_X1 U26 ( .A(B[5]), .B(A[5]), .Z(N2) );
  XOR2_X1 U27 ( .A(B[6]), .B(A[6]), .Z(N1) );
  XOR2_X1 U28 ( .A(B[7]), .B(A[7]), .Z(N0) );
  XOR2_X1 U29 ( .A(n2), .B(n3), .Z(C[7]) );
  XOR2_X1 U30 ( .A(n4), .B(n5), .Z(C[6]) );
  XOR2_X1 U31 ( .A(n6), .B(n7), .Z(C[5]) );
  XOR2_X1 U32 ( .A(n8), .B(n9), .Z(C[4]) );
  XOR2_X1 U33 ( .A(n10), .B(n11), .Z(C[3]) );
  XOR2_X1 U34 ( .A(n12), .B(n13), .Z(C[2]) );
  XOR2_X1 U35 ( .A(n14), .B(n15), .Z(C[1]) );
  XOR2_X1 U36 ( .A(n16), .B(n17), .Z(C[0]) );
endmodule

