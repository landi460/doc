
module t0encdec ( ck, rst, A, B, C );
  input [7:0] A;
  output [8:0] B;
  output [7:0] C;
  input ck, rst;
  wire   N16, N17, N18, N19, N20, N21, N22, N23, N24, N27, N28, N29, N30, N31,
         N32, N33, N34, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56;
  wire   [7:0] Aold;
  wire   [7:0] AoldInc;
  wire   [7:2] add_70_carry;
  wire   [7:2] add_32_carry;

  DFFR_X1 Aold_reg_7_ ( .D(A[7]), .CK(ck), .RN(n48), .Q(Aold[7]) );
  DFFR_X1 Aold_reg_6_ ( .D(A[6]), .CK(ck), .RN(n48), .Q(Aold[6]) );
  DFFR_X1 Aold_reg_5_ ( .D(A[5]), .CK(ck), .RN(n48), .Q(Aold[5]) );
  DFFR_X1 Aold_reg_4_ ( .D(A[4]), .CK(ck), .RN(n48), .Q(Aold[4]) );
  DFFR_X1 Aold_reg_3_ ( .D(A[3]), .CK(ck), .RN(n48), .Q(Aold[3]) );
  DFFR_X1 Aold_reg_2_ ( .D(A[2]), .CK(ck), .RN(n48), .Q(Aold[2]) );
  DFFR_X1 Aold_reg_1_ ( .D(A[1]), .CK(ck), .RN(n48), .Q(Aold[1]) );
  DFFR_X1 Aold_reg_0_ ( .D(A[0]), .CK(ck), .RN(n48), .Q(Aold[0]) );
  DLH_X1 buss_reg_7_ ( .G(N16), .D(N24), .Q(B[7]) );
  DLH_X1 buss_reg_6_ ( .G(N16), .D(N23), .Q(B[6]) );
  DLH_X1 buss_reg_5_ ( .G(N16), .D(N22), .Q(B[5]) );
  DLH_X1 buss_reg_4_ ( .G(N16), .D(N21), .Q(B[4]) );
  DLH_X1 buss_reg_3_ ( .G(N16), .D(N20), .Q(B[3]) );
  DLH_X1 buss_reg_2_ ( .G(N16), .D(N19), .Q(B[2]) );
  DLH_X1 buss_reg_1_ ( .G(N16), .D(N18), .Q(B[1]) );
  DLH_X1 buss_reg_0_ ( .G(N16), .D(N17), .Q(B[0]) );
  DFFR_X1 C_reg_0_ ( .D(n56), .CK(ck), .RN(n48), .Q(C[0]) );
  DFFR_X1 C_reg_1_ ( .D(n55), .CK(ck), .RN(n48), .Q(C[1]) );
  DFFR_X1 C_reg_2_ ( .D(n54), .CK(ck), .RN(n48), .Q(C[2]) );
  DFFR_X1 C_reg_3_ ( .D(n53), .CK(ck), .RN(n48), .Q(C[3]) );
  DFFR_X1 C_reg_4_ ( .D(n52), .CK(ck), .RN(n48), .Q(C[4]) );
  DFFR_X1 C_reg_5_ ( .D(n51), .CK(ck), .RN(n48), .Q(C[5]) );
  DFFR_X1 C_reg_6_ ( .D(n50), .CK(ck), .RN(n48), .Q(C[6]) );
  DFFR_X1 C_reg_7_ ( .D(n49), .CK(ck), .RN(n48), .Q(C[7]) );
  MUX2_X1 U49 ( .A(B[7]), .B(N34), .S(B[8]), .Z(n49) );
  MUX2_X1 U50 ( .A(B[6]), .B(N33), .S(B[8]), .Z(n50) );
  MUX2_X1 U51 ( .A(B[5]), .B(N32), .S(B[8]), .Z(n51) );
  MUX2_X1 U52 ( .A(B[4]), .B(N31), .S(B[8]), .Z(n52) );
  MUX2_X1 U53 ( .A(B[3]), .B(N30), .S(B[8]), .Z(n53) );
  MUX2_X1 U54 ( .A(B[2]), .B(N29), .S(B[8]), .Z(n54) );
  MUX2_X1 U55 ( .A(B[1]), .B(N28), .S(B[8]), .Z(n55) );
  MUX2_X1 U56 ( .A(B[0]), .B(N27), .S(B[8]), .Z(n56) );
  AND2_X1 U57 ( .A1(n48), .A2(A[7]), .ZN(N24) );
  AND2_X1 U58 ( .A1(n48), .A2(A[6]), .ZN(N23) );
  AND2_X1 U59 ( .A1(n48), .A2(A[5]), .ZN(N22) );
  AND2_X1 U60 ( .A1(n48), .A2(A[4]), .ZN(N21) );
  AND2_X1 U61 ( .A1(n48), .A2(A[3]), .ZN(N20) );
  AND2_X1 U62 ( .A1(n48), .A2(A[2]), .ZN(N19) );
  AND2_X1 U63 ( .A1(n48), .A2(A[1]), .ZN(N18) );
  AND2_X1 U64 ( .A1(n48), .A2(A[0]), .ZN(N17) );
  NAND2_X1 U65 ( .A1(B[8]), .A2(n48), .ZN(N16) );
  INV_X1 U66 ( .A(rst), .ZN(n48) );
  AND2_X1 U67 ( .A1(n38), .A2(n39), .ZN(B[8]) );
  NOR4_X1 U68 ( .A1(n40), .A2(n41), .A3(n42), .A4(n43), .ZN(n39) );
  XOR2_X1 U69 ( .A(AoldInc[3]), .B(A[3]), .Z(n43) );
  XOR2_X1 U70 ( .A(AoldInc[2]), .B(A[2]), .Z(n42) );
  XOR2_X1 U71 ( .A(AoldInc[1]), .B(A[1]), .Z(n41) );
  XOR2_X1 U72 ( .A(AoldInc[0]), .B(A[0]), .Z(n40) );
  NOR4_X1 U73 ( .A1(n44), .A2(n45), .A3(n46), .A4(n47), .ZN(n38) );
  XOR2_X1 U74 ( .A(AoldInc[7]), .B(A[7]), .Z(n47) );
  XOR2_X1 U75 ( .A(AoldInc[6]), .B(A[6]), .Z(n46) );
  XOR2_X1 U76 ( .A(AoldInc[5]), .B(A[5]), .Z(n45) );
  XOR2_X1 U77 ( .A(AoldInc[4]), .B(A[4]), .Z(n44) );
  XOR2_X1 add_70_U2 ( .A(add_70_carry[7]), .B(C[7]), .Z(N34) );
  INV_X1 add_70_U1 ( .A(C[0]), .ZN(N27) );
  HA_X1 add_70_U1_1_1 ( .A(C[1]), .B(C[0]), .CO(add_70_carry[2]), .S(N28) );
  HA_X1 add_70_U1_1_2 ( .A(C[2]), .B(add_70_carry[2]), .CO(add_70_carry[3]), 
        .S(N29) );
  HA_X1 add_70_U1_1_3 ( .A(C[3]), .B(add_70_carry[3]), .CO(add_70_carry[4]), 
        .S(N30) );
  HA_X1 add_70_U1_1_4 ( .A(C[4]), .B(add_70_carry[4]), .CO(add_70_carry[5]), 
        .S(N31) );
  HA_X1 add_70_U1_1_5 ( .A(C[5]), .B(add_70_carry[5]), .CO(add_70_carry[6]), 
        .S(N32) );
  HA_X1 add_70_U1_1_6 ( .A(C[6]), .B(add_70_carry[6]), .CO(add_70_carry[7]), 
        .S(N33) );
  XOR2_X1 add_32_U2 ( .A(add_32_carry[7]), .B(Aold[7]), .Z(AoldInc[7]) );
  INV_X1 add_32_U1 ( .A(Aold[0]), .ZN(AoldInc[0]) );
  HA_X1 add_32_U1_1_1 ( .A(Aold[1]), .B(Aold[0]), .CO(add_32_carry[2]), .S(
        AoldInc[1]) );
  HA_X1 add_32_U1_1_2 ( .A(Aold[2]), .B(add_32_carry[2]), .CO(add_32_carry[3]), 
        .S(AoldInc[2]) );
  HA_X1 add_32_U1_1_3 ( .A(Aold[3]), .B(add_32_carry[3]), .CO(add_32_carry[4]), 
        .S(AoldInc[3]) );
  HA_X1 add_32_U1_1_4 ( .A(Aold[4]), .B(add_32_carry[4]), .CO(add_32_carry[5]), 
        .S(AoldInc[4]) );
  HA_X1 add_32_U1_1_5 ( .A(Aold[5]), .B(add_32_carry[5]), .CO(add_32_carry[6]), 
        .S(AoldInc[5]) );
  HA_X1 add_32_U1_1_6 ( .A(Aold[6]), .B(add_32_carry[6]), .CO(add_32_carry[7]), 
        .S(AoldInc[6]) );
endmodule

