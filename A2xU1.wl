(* ::Package:: *)
(* A2 x U(1) x Sp(1)_R: exact one-fiber spectrum counter, nV=12.

   Conventions follow Section 7 of Latest_Sp_1_R_gauged_models:
      Omega = {{0,1},{1,0}}, a = {-2,-2}, bR = {-2,2}.
   The odd diagonal basis in Section 7.3 is an EMBEDDING of these same
   anomaly data. It is not the coordinate system used in the scan.

   Get["Count_A2xU1_Fibers.wl"] only defines functions. Examples are below.
   The charged 3 and bar3 (likewise 6 and bar6) orientations are independent
   nonnegative full-hyper multiplicities. We impose the signed cubic equation
   exactly, then count orbits under simultaneous U(1) charge reversal.
   We do not prematurely set conjugate multiplicities equal.
*)

ClearAll["Global`a2u1*"];
ClearAll[countA2U1Fiber,runA2U1CountAudit,exportA2U1Spectra];

a2u1Omega = {{0,1},{1,0}};
a2u1a = {-2,-2};
a2u1bR = {-2,2};
a2u1Dot[v_List,w_List] := v.a2u1Omega.w;
a2u1nH = 256;
a2u1PValues = {-25,-23,-17,-15,-9,-7,-1};

(* One physical full hyper labelled R_q contributes dim(R) to nH;
   the symplectic completion R_q (+) bar(R)_{-q} is implicit.
   A_R,C_R,E_R follow draft Eq. (7.4). For SU(3), there is no B_R row.
   TwoC is exactly 2 C_R, so all matrix entries are integers. *)
a2u1Block[blockName_,repDim_,aCoeff_,twoCCoeff_,eCoeff_,
  chargeMag_,partnerName_] := <|
  "Name"->blockName,"dim"->repDim,"A_R"->aCoeff,
  "TwoC"->twoCCoeff,"E_R"->eCoeff,
  "Charge"->chargeMag,"Conjugate"->partnerName|>;
a2u1Blocks = Join[
  {
    a2u1Block["1_0",1,0,0,0,0,"1_0"],
    a2u1Block["3_0",3,1,1,0,0,"3_0"],
    a2u1Block["6_0",6,5,17,0,0,"6_0"],
    a2u1Block["8_0",8,6,18,0,0,"8_0"]
  },
  Flatten[Table[{
    a2u1Block["1_"<>ToString[q],1,0,0,0,q,
      "1_"<>ToString[q]],
    a2u1Block["3_"<>ToString[q],3,1,1,1,q,
      "bar3_"<>ToString[q]],
    a2u1Block["bar3_"<>ToString[q],3,1,1,-1,q,
      "3_"<>ToString[q]],
    a2u1Block["6_"<>ToString[q],6,5,17,7,q,
      "bar6_"<>ToString[q]],
    a2u1Block["bar6_"<>ToString[q],6,5,17,-7,q,
      "6_"<>ToString[q]],
    a2u1Block["8_"<>ToString[q],8,6,18,0,q,
      "8_"<>ToString[q]]
  },{q,1,2}],1]
];
a2u1VariableOrder = Lookup[a2u1Blocks,"Name"];

(* This exact witness is class 8 in Appendix D. If the representation
   records do not evaluate to associations, stop before doing any scan. *)
a2u1WitnessClass8 = {0,16,12,5,36,0,0,5,5,0,0,0,0,0,0,0};
If[Length[a2u1Blocks]=!=16 ||
   !And@@(AssociationQ /@ a2u1Blocks) ||
   Length[a2u1VariableOrder]=!=16,
  Print["ERROR: the A2 representation table did not load correctly."];
  Abort[]
];

(* Rows of D: nH, Sigma_A, 2 Sigma_C, S2, S4, S_Aq2, C_cubic.
   The cubic row is sum_q q(m3,q + 7 m6,q) with SIGNED orientations.
   Positive and negative q label the two orientations of a complex block;
   the charge-even rows depend only on |q|. *)
a2u1Matrix = Transpose[Function[block,
  With[{q=block["Charge"]},
   {block["dim"],block["A_R"],block["TwoC"],
    q^2 block["dim"],q^4 block["dim"],
    q^2 block["A_R"],q block["E_R"]}
  ]] /@ a2u1Blocks];
a2u1Rows = {"nH","Sigma_A","2Sigma_C","S2","S4","SAq2","Ccubic"};

(* Eq. (7.17), (7.24), (7.35): in the OFF-DIAGONAL presentation.
   bA2 can have half-integral coordinates here. Eq. (7.47)/(7.48)
   supplies an integral realization in the odd lattice. *)
a2u1bA2[p_Integer] := {-(p+3)/4,(3-p)/4};
a2u1bU1[k_Integer] := {4k,4k};
a2u1N1[k_Integer] := 32k(4-k);
a2u1N2[k_Integer] := 8k(k-1);

a2u1Targets[p_Integer,k_Integer] := {
  a2u1nH,                 (* gravitational anomaly *)
  6(1-p),                 (* Sigma_A, Eq. (7.29) *)
  18+3(p^2-9)/4,         (* 2 Sigma_C, Eq. (7.29) *)
  96k,                    (* S2, Eq. (7.35) *)
  96k^2,                  (* S4, Eq. (7.35) *)
  -2*k*p,                 (* S_Aq2=bA2.bU1, Eq. (7.25) *)
  0                       (* cubic A2^3-U(1) equation (7.9) *)
};

If[a2u1Matrix.a2u1WitnessClass8 =!=
   {256,156,480,96,96,50,0} ||
   a2u1Targets[-25,1] =!= {256,156,480,96,96,50,0},
  Print["ERROR: the class-8 witness fails the anomaly matrix check."];
  Abort[]
];

(* These are the 28 formal classes of Eqs. (7.43), (7.45).
   k=0 is a formal drone sector. Physical no-drone results use k=1..3. *)
a2u1ClassNumber[p_Integer,k_Integer] /;
 MemberQ[a2u1PValues,p] && 0<=k<=3 :=
 7k+First[FirstPosition[a2u1PValues,p]];

(* Appendix D, Table 11. Entries already include the global Z2 quotient. *)
a2u1ExpectedCounts = {
  {22,23,11,8,2,1,1},
  {231,419,96,61,4,1,1},
  {4796,13471,2883,1198,48,11,1},
  {33921,101013,14105,6117,137,22,2}
};
a2u1ExpectedCount[p_Integer,k_Integer] /;
 MemberQ[a2u1PValues,p] && 0<=k<=3 :=
 a2u1ExpectedCounts[[k+1,First[FirstPosition[a2u1PValues,p]]]];

(* Direct local-basis check; it is independent of the multiplicity solve. *)
a2u1LocalVectorCheck[p_Integer,k_Integer] := Module[
 {b=a2u1bA2[p],u=a2u1bU1[k]},
 <|"a.bA2"->a2u1Dot[a2u1a,b],
   "bR.bA2"->a2u1Dot[a2u1bR,b],
   "bA2^2"->a2u1Dot[b,b],
   "a.bU1"->a2u1Dot[a2u1a,u],
   "bU1^2"->a2u1Dot[u,u],
   "bA2.bU1"->a2u1Dot[b,u],
   "bR.bU1"->a2u1Dot[a2u1bR,u]|>
];

(* Section 7.3: an INTEGRAL ODD-LATTICE EMBEDDING of the same Gram
   data, included only as an optional independent check. *)
a2u1OddEmbedding[p_Integer,k_Integer] /;
 MemberQ[a2u1PValues,p] && 0<=k<=3 := Module[
 {br,b},
 If[Mod[p,8]==1,
   br={1,3};b={3(1-p)/8,(9-p)/8},
   br={-1,-3};b={-3(p+1)/8,-(p+9)/8}
 ];
 <|"Omega"->DiagonalMatrix[{1,-1}],
   "a"->{-3,-1},"bR"->br,"bA2"->b,"bU1"->{6k,2k}|>
];

(* The SU(3) mod-6 congruence follows from the exact 2Sigma_C target
   for each allowed p; we retain an explicit check for readability. *)
a2u1GlobalAnomalyFreeQ[v_List] :=
 Mod[18-v.Lookup[a2u1Blocks,"TwoC"],6] == 0;

(* Simultaneous reversal of the U(1) generator, Eq. (7.54).
   The positive-charge singlet and 8 blocks are fixed, while the two
   orientations of each charged 3 and 6 are swapped. *)
a2u1ConjugationMap = (First[FirstPosition[a2u1VariableOrder,#]]& /@
  Lookup[a2u1Blocks,"Conjugate"]);
a2u1Conjugate[v_List] := v[[a2u1ConjugationMap]];
a2u1Canonical[v_List] := First[Sort[{v,a2u1Conjugate[v]}]];
a2u1SpectrumAssociation[v_List] := Association @ Select[
 Thread[a2u1VariableOrder->v],Last[#]>0&];

Options[countA2U1Fiber] = {
 "ReturnSolutions"->False,"FormattedSolutions"->True,
 "CheckGlobalAnomaly"->True
};

countA2U1Fiber[p_Integer,k_Integer,OptionsPattern[]] := Module[
 {z,charge1Positions,conditions,raw,physical,fixed,orbits,
  canonical,returnQ,formattedQ,reference},
 If[!MemberQ[a2u1PValues,p] || !MemberQ[Range[0,3],k],
   Return[Failure["UnknownClass",<|"p"->p,"k"->k|>]]];
 z=Table[Unique["m"],{Length[a2u1Blocks]}];
 charge1Positions=Flatten[Position[Lookup[a2u1Blocks,"Charge"],1]];
 conditions=Thread[a2u1Matrix.z==a2u1Targets[p,k]];
 (* Primitive normalization; for k=0 there are no charged hypers. *)
 If[k>0,AppendTo[conditions,Total[z[[charge1Positions]]]>=1]];
 raw=SolveValues[conditions,z,NonNegativeIntegers];
 If[!ListQ[raw],Return[Failure["SolveDidNotReturnList",<|"p"->p,"k"->k|>]]];
 If[raw==={},Return[Failure["UnexpectedEmptyFiber",
   <|"p"->p,"k"->k,"Targets"->a2u1Targets[p,k]|>]]];
 physical=If[TrueQ[OptionValue["CheckGlobalAnomaly"]],
   Select[raw,a2u1GlobalAnomalyFreeQ],raw];
 If[physical==={},Return[Failure["GlobalCheckRemovedEntireFiber",
   <|"p"->p,"k"->k,"RawLabeledCount"->Length[raw]|>]]];
 fixed=Count[physical,v_ /; a2u1Conjugate[v]===v];
 orbits=(Length[physical]+fixed)/2; (* Burnside for the global Z2 *)
 reference=a2u1ExpectedCount[p,k];
 returnQ=TrueQ[OptionValue["ReturnSolutions"]];
 formattedQ=TrueQ[OptionValue["FormattedSolutions"]];
 canonical=If[returnQ,DeleteDuplicates[a2u1Canonical /@ physical],
   Missing["NotConstructed"]];
 <|"Class"->a2u1ClassNumber[p,k],"p"->p,"k"->k,
   "bA2"->a2u1bA2[p],"bU1"->a2u1bU1[k],
   "N1"->a2u1N1[k],"N2"->a2u1N2[k],
   "RawLabeledCount"->Length[raw],
   "GlobalAnomalyCount"->Length[physical],
   "ConjugationFixedCount"->fixed,
   "InequivalentCount"->orbits,
   "ExpectedCount"->reference,
   "PassQ"->(orbits===reference),
   "Solutions"->If[returnQ,
      If[formattedQ,a2u1SpectrumAssociation /@ canonical,canonical],
      Missing["NotRequested"]]|>
];

Options[runA2U1CountAudit] = Join[
 Options[countA2U1Fiber],{"IncludeDrone"->False}];
runA2U1CountAudit[OptionsPattern[]] := Module[
 {rows={},result,ks,referenceTotal,computedTotal,failures},
 ks=If[TrueQ[OptionValue["IncludeDrone"]],Range[0,3],Range[1,3]];
 Do[
   Print["START class ",a2u1ClassNumber[p,k]," (p,k)=",{p,k}];
   result=countA2U1Fiber[p,k,
     "ReturnSolutions"->OptionValue["ReturnSolutions"],
     "FormattedSolutions"->OptionValue["FormattedSolutions"],
     "CheckGlobalAnomaly"->OptionValue["CheckGlobalAnomaly"]];
   If[!AssociationQ[result],Return[result]];
   AppendTo[rows,result];
   Print["DONE  class ",result["Class"],": ",
     result["InequivalentCount"]," (paper ",result["ExpectedCount"],")"];
   ClearSystemCache[],
   {k,ks},{p,a2u1PValues}
 ];
 failures=Select[rows,!TrueQ[# ["PassQ"]]&];
 computedTotal=Total[Lookup[rows,"InequivalentCount"]];
 referenceTotal=Total[Flatten[a2u1ExpectedCounts[[ks+1]]]];
 <|"ClassesChecked"->Length[rows],
   "ComputedTotal"->computedTotal,"ReferenceTotal"->referenceTotal,
   "FailedClasses"->Lookup[failures,"Class",{}],
   "MatchesPaper"->(failures==={} && computedTotal===referenceTotal),
   "ByK"->Association@Table[k->Total[Lookup[
      Select[rows,# ["k"]===k&],"InequivalentCount",{}]],{k,ks}],
   "Rows"->rows|>
];

(* Export the canonical spectra of one class as a CSV with one column
   per representation/charge block. Potentially large for k=3. *)
exportA2U1Spectra[p_Integer,k_Integer,file_String] := Module[
 {result,records},
 result=countA2U1Fiber[p,k,"ReturnSolutions"->True,
   "FormattedSolutions"->False];
 If[!AssociationQ[result],Return[result]];
 records=(Join[{result["Class"],p,k},#]& /@ result["Solutions"]);
 Export[file,Prepend[records,Join[{"Class","p","k"},
    a2u1VariableOrder]],"CSV"]
];

(* Examples after loading this file:
   a2u1LocalVectorCheck[-25,1]            local off-diagonal convention
   a2u1OddEmbedding[-25,1]              the separate Section 7.3 basis
   countA2U1Fiber[-23,3]                one class (reference 101013)
   audit=runA2U1CountAudit[];            all 21 no-drone classes
   audit["ByK"]                          reference {1->813,2->22408,3->155317}
   audit["MatchesPaper"]                 reference True
   exportA2U1Spectra[-17,2,"A2_class17.csv"]
*)
