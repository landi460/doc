
module businvbeh ( ck, rst, A, B, C );
  input [7:0] A;
  output [8:0] B;
  output [7:0] C;
  input ck, rst;
  wire   N13, N14, N15, N16, N17, N18, N19, N20, N25, N26, N31, N65, N66, N201,
         N202, N235, N236, N237, N238, N266, N275, N276, N277, N278, N279,
         N280, N281, N282, add_51_I9_carry_2_, add_51_I9_carry_3_,
         add_3_root_add_51_I8_aco_carry_1_, add_3_root_add_51_I8_aco_carry_2_,
         add_5_root_add_51_I8_aco_carry_1_, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103;
  wire   [7:2] AX;

  DFFR_X1 AOLD_reg_0_ ( .D(N13), .CK(ck), .RN(n103), .Q(B[0]), .QN(n95) );
  DFFR_X1 invold_reg ( .D(N266), .CK(ck), .RN(n103), .Q(B[8]), .QN(n102) );
  DFFR_X1 AOLD_reg_1_ ( .D(N14), .CK(ck), .RN(n103), .Q(B[1]), .QN(n94) );
  DFFR_X1 AOLD_reg_2_ ( .D(N15), .CK(ck), .RN(n103), .Q(B[2]), .QN(n101) );
  DFFR_X1 AOLD_reg_3_ ( .D(N16), .CK(ck), .RN(n103), .Q(B[3]), .QN(n100) );
  DFFR_X1 AOLD_reg_4_ ( .D(N17), .CK(ck), .RN(n103), .Q(B[4]), .QN(n99) );
  DFFR_X1 AOLD_reg_5_ ( .D(N18), .CK(ck), .RN(n103), .Q(B[5]), .QN(n98) );
  DFFR_X1 AOLD_reg_6_ ( .D(N19), .CK(ck), .RN(n103), .Q(B[6]), .QN(n97) );
  DFFR_X1 AOLD_reg_7_ ( .D(N20), .CK(ck), .RN(n103), .Q(B[7]), .QN(n96) );
  DFFR_X1 C_reg_7_ ( .D(N282), .CK(ck), .RN(n103), .Q(C[7]) );
  DFFR_X1 C_reg_6_ ( .D(N281), .CK(ck), .RN(n103), .Q(C[6]) );
  DFFR_X1 C_reg_5_ ( .D(N280), .CK(ck), .RN(n103), .Q(C[5]) );
  DFFR_X1 C_reg_4_ ( .D(N279), .CK(ck), .RN(n103), .Q(C[4]) );
  DFFR_X1 C_reg_3_ ( .D(N278), .CK(ck), .RN(n103), .Q(C[3]) );
  DFFR_X1 C_reg_2_ ( .D(N277), .CK(ck), .RN(n103), .Q(C[2]) );
  DFFR_X1 C_reg_1_ ( .D(N276), .CK(ck), .RN(n103), .Q(C[1]) );
  DFFR_X1 C_reg_0_ ( .D(N275), .CK(ck), .RN(n103), .Q(C[0]) );
  HA_X1 add_51_I9_U1_1_1 ( .A(N202), .B(N201), .CO(add_51_I9_carry_2_), .S(
        N235) );
  HA_X1 add_51_I9_U1_1_2 ( .A(n82), .B(add_51_I9_carry_2_), .CO(
        add_51_I9_carry_3_), .S(N236) );
  HA_X1 add_51_I9_U1_1_3 ( .A(n83), .B(add_51_I9_carry_3_), .CO(N238), .S(N237) );
  FA_X1 add_3_root_add_51_I8_aco_U1_0 ( .A(N31), .B(N65), .CI(AX[7]), .CO(
        add_3_root_add_51_I8_aco_carry_1_), .S(N201) );
  FA_X1 add_3_root_add_51_I8_aco_U1_1 ( .A(n84), .B(N66), .CI(
        add_3_root_add_51_I8_aco_carry_1_), .CO(
        add_3_root_add_51_I8_aco_carry_2_), .S(N202) );
  FA_X1 add_4_root_add_51_I8_aco_U1_0 ( .A(AX[5]), .B(AX[6]), .CI(AX[4]), .CO(
        N66), .S(N65) );
  FA_X1 add_5_root_add_51_I8_aco_U1_0 ( .A(N25), .B(AX[3]), .CI(AX[2]), .CO(
        add_5_root_add_51_I8_aco_carry_1_), .S(N31) );
  XOR2_X1 U98 ( .A(n85), .B(add_3_root_add_51_I8_aco_carry_2_), .Z(n82) );
  AND2_X1 U99 ( .A1(n85), .A2(add_3_root_add_51_I8_aco_carry_2_), .ZN(n83) );
  XOR2_X1 U100 ( .A(N26), .B(add_5_root_add_51_I8_aco_carry_1_), .Z(n84) );
  AND2_X1 U101 ( .A1(N26), .A2(add_5_root_add_51_I8_aco_carry_1_), .ZN(n85) );
  INV_X1 U102 ( .A(rst), .ZN(n103) );
  XOR2_X1 U103 ( .A(n96), .B(n102), .Z(N282) );
  XOR2_X1 U104 ( .A(n97), .B(n102), .Z(N281) );
  XOR2_X1 U105 ( .A(n98), .B(n102), .Z(N280) );
  XOR2_X1 U106 ( .A(n99), .B(n102), .Z(N279) );
  XOR2_X1 U107 ( .A(n100), .B(n102), .Z(N278) );
  XOR2_X1 U108 ( .A(n101), .B(n102), .Z(N277) );
  XOR2_X1 U109 ( .A(n94), .B(n102), .Z(N276) );
  XOR2_X1 U110 ( .A(n95), .B(n102), .Z(N275) );
  NOR2_X1 U111 ( .A1(n86), .A2(n87), .ZN(N26) );
  XOR2_X1 U112 ( .A(n86), .B(n87), .Z(N25) );
  XOR2_X1 U113 ( .A(A[0]), .B(n95), .Z(n87) );
  XOR2_X1 U114 ( .A(A[1]), .B(n94), .Z(n86) );
  XOR2_X1 U115 ( .A(A[7]), .B(N266), .Z(N20) );
  XOR2_X1 U116 ( .A(A[6]), .B(N266), .Z(N19) );
  XOR2_X1 U117 ( .A(A[5]), .B(N266), .Z(N18) );
  XOR2_X1 U118 ( .A(A[4]), .B(N266), .Z(N17) );
  XOR2_X1 U119 ( .A(A[3]), .B(N266), .Z(N16) );
  XOR2_X1 U120 ( .A(A[2]), .B(N266), .Z(N15) );
  XOR2_X1 U121 ( .A(A[1]), .B(N266), .Z(N14) );
  XOR2_X1 U122 ( .A(A[0]), .B(N266), .Z(N13) );
  INV_X1 U123 ( .A(n88), .ZN(N266) );
  MUX2_X1 U124 ( .A(n89), .B(n90), .S(n102), .Z(n88) );
  AOI21_X1 U125 ( .B1(n82), .B2(n91), .A(n83), .ZN(n90) );
  OR2_X1 U126 ( .A1(N201), .A2(N202), .ZN(n91) );
  AOI211_X1 U127 ( .C1(N236), .C2(n92), .A(N238), .B(N237), .ZN(n89) );
  NAND2_X1 U128 ( .A1(n93), .A2(N201), .ZN(n92) );
  INV_X1 U129 ( .A(N235), .ZN(n93) );
  XNOR2_X1 U130 ( .A(A[7]), .B(n96), .ZN(AX[7]) );
  XNOR2_X1 U131 ( .A(A[6]), .B(n97), .ZN(AX[6]) );
  XNOR2_X1 U132 ( .A(A[5]), .B(n98), .ZN(AX[5]) );
  XNOR2_X1 U133 ( .A(A[4]), .B(n99), .ZN(AX[4]) );
  XNOR2_X1 U134 ( .A(A[3]), .B(n100), .ZN(AX[3]) );
  XNOR2_X1 U135 ( .A(A[2]), .B(n101), .ZN(AX[2]) );
endmodule

