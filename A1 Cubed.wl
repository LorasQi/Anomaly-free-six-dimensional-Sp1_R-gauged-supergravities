(* ::Package:: *)
(* A1^3 x Sp(1)_R, Table 8. Self-contained: no Get or notebook dependency.
   Loading only defines data and functions; nothing is enumerated until called.
   The metric is {{0,1},{1,0}} and a={-2,-2}, as in the main draft.

   Typical Mathematica notebook usage:
     Get[SystemDialogInput["FileOpen"]]                 (* choose this .wl *)
     a1CubedClass[36]                                    (* {1,1,2} *)
     a1CubedCheckWitnesses[]                             (* {}: 102 valid examples *)
     countA1CubedFiber[{1,1,2}]["InequivalentCount"]      (* 19 *)
     one = countA1CubedFiber[{1,1,2}, True];
     one["Solutions"]                                   (* y vectors + singlets *)
     a1CubedSpectrum /@ one["Solutions"]                 (* readable SMW counts *)
     exportA1CubedSpectra[36,"A1cubed_class36.csv"]
     audit = runTable8CountAudit[]; audit["MatchesPaper"]
   Optional resume: runTable8CountAudit["CheckpointFile"->"audit.wl"]
   For large classes ReturnSolutions->True can require substantial memory.
*)

ClearAll[smwStep, dContent, tContent, pContent, countA1CubedFiber,
  a1CubedClass, a1CubedWitness, a1CubedCheckWitnesses,
  a1CubedSpectrum, exportA1CubedSpectra, runTable8CountAudit,
  a1CubedTableBranches, a1CubedTableN, a1CubedTableSingletMin,
  a1CubedWitnessEncoded, allReps, chargedReps, nCharged];

(* Ordered Table 8 representatives and independently tabulated N and s_min. *)
a1CubedTableBranches = {{0, 0, 0}, {0, 0, 1}, {0, 0, 2}, {0, 0, 3}, {0, 0, 4}, {0, 0, 5}, {0, 0, 6}, {0, 0, 7}, {0, 1, 1}, {0, 1, 2}, {0, 1, 3}, {0, 1, 4}, {0, 1, 5}, {0, 1, 6}, {0, 1, 7}, {0, 2, 2}, {0, 2, 3}, {0, 2, 4}, {0, 2, 5}, {0, 2, 6}, {0, 2, 7}, {0, 3, 3}, {0, 3, 4}, {0, 3, 5}, {0, 3, 6}, {0, 3, 7}, {0, 4, 4}, {0, 4, 5}, {0, 4, 6}, {0, 4, 7}, {0, 5, 5}, {0, 5, 6}, {0, 5, 7}, {0, 6, 6}, {1, 1, 1}, {1, 1, 2}, {1, 1, 3}, {1, 1, 4}, {1, 1, 5}, {1, 1, 6}, {1, 1, 7}, {1, 2, 2}, {1, 2, 3}, {1, 2, 4}, {1, 2, 5}, {1, 2, 6}, {1, 2, 7}, {1, 3, 3}, {1, 3, 4}, {1, 3, 5}, {1, 3, 6}, {1, 3, 7}, {1, 4, 4}, {1, 4, 5}, {1, 4, 6}, {1, 4, 7}, {1, 5, 5}, {1, 5, 6}, {1, 5, 7}, {1, 6, 6}, {2, 2, 2}, {2, 2, 3}, {2, 2, 4}, {2, 2, 5}, {2, 2, 6}, {2, 2, 7}, {2, 3, 3}, {2, 3, 4}, {2, 3, 5}, {2, 3, 6}, {2, 3, 7}, {2, 4, 4}, {2, 4, 5}, {2, 4, 6}, {2, 4, 7}, {2, 5, 5}, {2, 5, 6}, {2, 5, 7}, {2, 6, 6}, {3, 3, 3}, {3, 3, 4}, {3, 3, 5}, {3, 3, 6}, {3, 3, 7}, {3, 4, 4}, {3, 4, 5}, {3, 4, 6}, {3, 4, 7}, {3, 5, 5}, {3, 5, 6}, {3, 5, 7}, {3, 6, 6}, {4, 4, 4}, {4, 4, 5}, {4, 4, 6}, {4, 4, 7}, {4, 5, 5}, {4, 5, 6}, {4, 5, 7}, {4, 6, 6}, {5, 5, 5}, {5, 5, 6}};
a1CubedTableN = {1, 1, 3, 3, 6, 6, 10, 6, 2, 8, 22, 35, 51, 61, 20, 27, 124, 240, 345, 320, 75, 205, 775, 966, 859, 174, 843, 1879, 1790, 218, 1070, 1140, 13, 61, 5, 19, 61, 103, 166, 154, 38, 122, 772, 1624, 2290, 1965, 369, 1652, 6667, 8581, 7094, 1261, 6775, 16804, 13895, 1432, 9089, 9183, 96, 303, 311, 3370, 7613, 10432, 8592, 1263, 14732, 63112, 81473, 65380, 8212, 65262, 154568, 108705, 7843, 73957, 61236, 345, 1529, 20954, 132249, 159383, 116590, 11861, 253698, 546458, 350611, 20144, 240230, 181876, 613, 2873, 148958, 437467, 255794, 7770, 350242, 195937, 41, 516, 58426, 4826};
a1CubedTableSingletMin = {160, 120, 80, 60, 40, 40, 40, 60, 84, 52, 24, 12, 10, 18, 36, 24, 4, 0, 0, 1, 22, 0, 1, 0, 0, 18, 0, 0, 2, 24, 0, 10, 40, 28, 48, 24, 0, 0, 0, 0, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 21, 12, 0, 0};

allReps = Select[Tuples[Range[3], 3], Count[#, 3] <= 1 &];
chargedReps = DeleteCases[allReps, {1, 1, 1}];
nCharged = Length[chargedReps];

(* Each entry is a sparse vector of independent nonnegative y coefficients,
   followed by the number s of neutral full hypers.  Converted from all 102
   supplied Table8_ex9s_Input.wl example spectra, where notebook n_R equals
   2^(d-1) times the SMW coefficient x_R for d doublet factors.  Our solver
   uses x_R=smwStep[R] y_R (the singlet is 2s SMW units). *)
a1CubedWitnessEncoded = {
{1->32, 3->32, 8->32, 20->160},
{1->72, 3->28, 4->1, 8->28, 9->1, 20->120},
{1->112, 3->29, 5->1, 8->29, 10->1, 20->80},
{1->120, 2->4, 3->25, 4->1, 5->1, 8->25, 9->1, 10->1, 20->60},
{1->128, 2->8, 3->26, 5->2, 8->26, 10->2, 20->40},
{1->104, 2->16, 3->22, 4->1, 5->2, 8->22, 9->1, 10->2, 20->40},
{1->80, 2->24, 3->23, 5->3, 8->23, 10->3, 20->40},
{1->24, 2->36, 3->19, 4->1, 5->3, 8->19, 9->1, 10->3, 20->60},
{1->64, 3->64, 4->3, 8->28, 12->1, 20->84},
{1->96, 3->62, 4->2, 5->2, 8->24, 9->1, 12->1, 20->52},
{1->124, 3->61, 5->5, 8->21, 9->1, 10->1, 11->1, 20->24},
{1->124, 2->4, 3->54, 4->1, 5->6, 8->22, 10->2, 11->1, 20->12},
{1->108, 2->10, 3->52, 5->8, 8->18, 9->1, 10->2, 11->1, 20->10},
{1->76, 2->18, 3->45, 4->1, 5->9, 8->19, 10->3, 11->1, 20->18},
{1->28, 2->28, 3->43, 5->11, 8->15, 9->1, 10->3, 11->1, 20->36},
{1->90, 3->90, 4->2, 5->2, 7->2, 8->24, 12->2, 20->24},
{1->110, 3->86, 5->6, 7->2, 8->16, 9->2, 11->1, 12->1, 20->4},
{1->102, 2->4, 3->76, 4->1, 5->8, 7->2, 8->12, 9->3, 11->1, 12->1},
{1->85, 2->8, 3->72, 4->1, 5->12, 7->1, 8->9, 9->5, 14->1},
{1->74, 2->13, 3->62, 5->14, 7->2, 8->15, 10->3, 11->2, 20->1},
{1->21, 2->22, 3->57, 4->1, 5->17, 7->1, 8->16, 9->1, 10->3, 14->1, 20->22},
{1->78, 2->4, 3->90, 4->5, 5->2, 7->6, 8->20, 12->3},
{1->74, 2->5, 3->65, 4->9, 5->5, 7->6, 8->14, 10->2, 11->3, 20->1},
{1->66, 2->8, 3->72, 4->2, 5->12, 7->6, 9->5, 11->3},
{1->49, 2->12, 3->73, 5->17, 7->5, 8->10, 9->3, 10->1, 12->1, 14->1},
{1->13, 2->18, 3->61, 5->21, 7->5, 8->12, 9->1, 10->3, 11->1, 14->1, 20->18},
{1->47, 2->8, 3->71, 4->10, 5->3, 7->11, 8->18, 10->1, 12->2, 14->1},
{1->42, 2->8, 3->72, 4->5, 5->12, 7->10, 8->6, 9->5, 14->2},
{1->44, 2->10, 3->61, 5->17, 7->12, 8->7, 10->3, 11->4, 20->2},
{2->14, 3->49, 4->1, 5->25, 6->2, 7->8, 8->13, 9->1, 10->3, 14->2, 20->24},
{1->38, 2->8, 3->72, 5->12, 7->18, 8->2, 9->5, 11->1, 14->2},
{1->22, 2->10, 3->53, 4->1, 5->17, 7->18, 8->13, 10->3, 11->1, 14->2, 20->10},
{1->13, 2->3, 5->36, 6->13, 7->5, 8->9, 9->1, 10->3, 11->1, 14->2, 20->40},
{1->2, 2->11, 3->32, 5->16, 6->1, 7->26, 8->14, 10->3, 14->3, 20->28},
{1->64, 3->64, 8->64, 12->4, 20->48},
{1->88, 3->57, 4->1, 5->1, 8->57, 9->1, 10->1, 12->4, 20->24},
{1->112, 3->55, 5->3, 8->55, 10->3, 12->4},
{1->88, 2->8, 3->44, 4->5, 8->44, 9->5, 11->1, 13->1},
{1->88, 2->8, 3->33, 4->4, 5->5, 8->43, 10->7, 11->2, 12->2},
{1->76, 2->12, 3->37, 5->9, 8->37, 10->9, 11->3, 12->1},
{1->32, 2->24, 3->43, 5->7, 8->43, 10->7, 11->1, 13->1, 20->8},
{1->77, 3->77, 4->3, 5->1, 7->1, 8->54, 10->1, 12->5, 14->1, 20->4},
{1->74, 2->4, 3->70, 4->2, 5->2, 7->2, 8->40, 9->3, 12->7},
{1->52, 2->8, 3->44, 4->14, 8->42, 9->5, 13->1, 14->2},
{1->62, 2->8, 3->38, 4->7, 5->6, 7->2, 8->34, 10->6, 11->3, 12->4},
{1->52, 2->8, 3->52, 5->16, 8->16, 9->7, 10->6, 11->3, 14->2},
{1->14, 2->24, 3->51, 4->3, 5->7, 7->2, 8->43, 10->3, 11->1, 13->2},
{1->70, 3->70, 5->6, 7->6, 9->10, 11->10},
{1->58, 2->4, 3->64, 5->8, 7->6, 9->10, 11->7, 12->3},
{1->24, 2->12, 3->16, 4->22, 6->4, 8->50, 13->2, 14->2},
{1->10, 2->20, 3->42, 4->10, 5->2, 7->6, 8->40, 11->1, 12->3, 13->2},
{1->5, 2->20, 3->56, 4->1, 5->12, 7->5, 8->35, 9->1, 10->2, 11->1, 12->1, 13->2, 14->1},
{1->28, 2->12, 3->64, 4->3, 7->12, 8->28, 12->13},
{1->27, 2->4, 3->68, 5->16, 7->7, 8->1, 9->13, 12->3, 14->5},
{1->15, 2->8, 3->62, 5->18, 7->7, 8->9, 9->11, 13->1, 14->5},
{1->1, 2->15, 3->48, 4->1, 5->16, 7->9, 8->34, 10->3, 11->1, 13->2, 14->3, 20->3},
{1->28, 3->28, 4->12, 5->12, 7->12, 8->32, 10->8, 14->8},
{1->17, 2->12, 3->42, 5->10, 7->17, 8->23, 9->2, 11->3, 12->1, 13->2, 14->3},
{1->16, 2->4, 3->1, 5->29, 6->15, 8->34, 9->1, 10->1, 13->2, 14->1, 15->1, 20->15},
{1->1, 2->11, 3->29, 5->13, 6->5, 7->17, 8->34, 9->1, 10->2, 13->1, 15->2, 20->8},
{1->48, 3->58, 4->8, 8->68, 9->4, 10->2, 12->4, 14->2, 18->2},
{1->50, 2->6, 3->44, 4->5, 6->2, 8->60, 9->1, 12->12, 17->2},
{1->48, 3->7, 4->20, 5->1, 8->57, 10->11, 11->4, 14->2, 18->2},
{1->68, 3->8, 4->8, 5->8, 6->2, 8->28, 10->12, 11->9, 12->3, 16->2},
{1->10, 2->16, 3->16, 4->16, 8->56, 10->6, 11->2, 13->2, 14->2, 17->2},
{1->8, 2->20, 3->43, 5->7, 7->2, 8->43, 10->7, 11->3, 12->3, 13->2, 17->2},
{1->42, 2->6, 3->48, 4->3, 6->4, 7->2, 8->44, 12->17, 16->2},
{1->24, 2->12, 3->52, 4->2, 7->6, 8->40, 9->1, 12->17, 17->2},
{1->24, 2->12, 3->16, 4->11, 6->6, 8->44, 12->11, 13->2, 16->2},
{2->20, 3->46, 4->2, 5->2, 7->6, 8->40, 9->1, 12->11, 13->2, 17->2},
{2->20, 3->30, 4->3, 5->6, 6->6, 8->44, 12->5, 13->4, 16->2},
{1->17, 3->17, 4->20, 5->3, 7->5, 8->48, 10->9, 12->4, 14->7, 18->2},
{1->4, 2->6, 3->62, 5->14, 6->4, 9->16, 11->1, 12->5, 15->2, 16->2},
{1->27, 3->36, 5->18, 7->7, 8->29, 10->12, 12->8, 14->5, 18->2},
{2->14, 3->19, 4->5, 5->11, 6->8, 8->41, 10->1, 11->2, 13->4, 15->1, 16->2},
{1->19, 3->44, 5->16, 7->9, 8->7, 9->13, 12->2, 13->1, 14->11, 17->2},
{2->8, 3->31, 4->5, 5->9, 7->12, 8->33, 10->9, 11->4, 13->1, 15->2, 18->2},
{1->1, 2->7, 3->10, 5->21, 6->12, 8->42, 9->1, 10->2, 13->3, 15->2, 17->1, 18->1, 20->7},
{1->1, 2->10, 3->23, 5->10, 6->6, 7->12, 8->42, 9->1, 10->2, 13->2, 15->3, 17->1, 18->1},
{1->10, 3->20, 4->20, 8->60, 9->4, 10->6, 12->4, 14->6, 17->2, 18->4},
{1->4, 2->2, 4->25, 8->64, 10->10, 11->1, 12->3, 14->6, 16->2, 19->1},
{4->23, 5->6, 8->60, 9->2, 10->14, 14->6, 18->2, 19->1},
{2->10, 3->30, 4->11, 5->2, 8->32, 10->10, 12->6, 13->2, 14->2, 15->1, 16->6},
{2->10, 3->12, 4->8, 5->6, 6->6, 8->50, 10->10, 13->4, 18->6},
{1->6, 2->8, 3->50, 7->10, 8->18, 9->11, 12->12, 13->1, 14->2, 18->6},
{3->53, 5->15, 6->4, 8->1, 9->19, 10->5, 12->3, 15->2, 18->6},
{3->50, 5->16, 7->4, 8->14, 9->9, 10->14, 11->1, 12->2, 15->2, 18->6},
{1->4, 2->12, 3->4, 5->10, 6->12, 8->52, 12->4, 13->5, 18->2, 19->1},
{3->8, 4->15, 5->6, 6->4, 7->4, 8->42, 10->14, 11->1, 12->1, 15->3, 18->6},
{3->35, 4->3, 5->13, 7->8, 8->33, 10->17, 12->2, 15->3, 18->6},
{1->8, 2->6, 5->13, 6->12, 8->31, 10->3, 11->1, 13->5, 15->2, 16->3, 18->3, 20->9},
{1->1, 2->13, 3->25, 5->1, 6->5, 7->9, 8->24, 9->1, 11->1, 13->4, 15->4, 16->6},
{1->28, 3->28, 7->12, 8->28, 10->12, 12->16, 18->12},
{1->8, 3->12, 5->16, 6->8, 8->16, 9->14, 10->4, 11->8, 15->1, 19->3},
{1->25, 2->6, 4->10, 6->3, 8->13, 11->4, 13->6, 14->9, 16->7, 17->5},
{2->11, 3->1, 4->1, 5->6, 6->12, 8->49, 9->1, 10->1, 13->6, 16->1, 18->3, 19->2},
{1->16, 3->31, 5->15, 8->17, 10->5, 11->3, 12->6, 14->8, 15->3, 17->12},
{2->12, 3->2, 5->2, 6->4, 7->12, 8->48, 11->3, 12->2, 13->4, 14->4, 19->3},
{1->5, 2->10, 6->7, 7->5, 8->4, 11->1, 13->8, 14->4, 15->1, 16->8, 18->4, 20->21},
{1->7, 2->10, 3->13, 6->8, 7->2, 9->1, 11->1, 13->5, 15->5, 16->10, 17->1, 18->1, 20->12},
{1->2, 3->2, 4->5, 5->10, 7->10, 8->52, 10->10, 14->10, 19->5},
{1->8, 2->8, 3->19, 5->3, 6->8, 8->19, 10->3, 13->4, 15->3, 16->8, 19->3}
};

smwStep[rep_] := If[OddQ[Count[rep, 2]], 1, 2];

dContent[rep_, i_] := If[rep[[i]] == 2, Times @@ Delete[rep, i], 0];
tContent[rep_, i_] := If[rep[[i]] == 3, Times @@ Delete[rep, i], 0];
pContent[rep_, i_, j_] := Module[{k = First@Complement[Range[3], {i, j}]},
  {0, 1, 4}[[rep[[i]]]] {0, 1, 4}[[rep[[j]]]] rep[[k]]
];

countA1CubedFiber[r_List, returnSolutions_: False] := Module[
  {y, s, steps, matrix, target, constraints, solutions, stabilizer,
   repMap, permuteMatter, canonical, inequivalent, fixedCounts, orbitCount,
   p, v},

  If[!MemberQ[a1CubedTableBranches, r],
    Return[Failure["UnknownBranch", <|"Branch" -> r|>]]];

  y = Table[Unique["y"], {nCharged}];
  s = Unique["s"];
  steps = smwStep /@ chargedReps;

  matrix = Table[
    steps[[k]] {
      dContent[chargedReps[[k]], 1],
      dContent[chargedReps[[k]], 2],
      dContent[chargedReps[[k]], 3],
      tContent[chargedReps[[k]], 1],
      tContent[chargedReps[[k]], 2],
      tContent[chargedReps[[k]], 3],
      pContent[chargedReps[[k]], 1, 2],
      pContent[chargedReps[[k]], 1, 3],
      pContent[chargedReps[[k]], 2, 3]
    },
    {k, nCharged}
  ] // Transpose;

  target = Join[
    8 (4 + 7 r - r^2),
    2 r (r - 1),
    2 {
      2 r[[1]] r[[2]] + r[[1]] + r[[2]],
      2 r[[1]] r[[3]] + r[[1]] + r[[3]],
      2 r[[2]] r[[3]] + r[[2]] + r[[3]]
    }
  ];

  constraints = Join[
    Thread[matrix . y == target],
    {Total[steps y (Times @@@ chargedReps)] + 2 s == 512}
  ];

  solutions = SolveValues[constraints, Join[y, {s}], NonNegativeIntegers];
  If[!ListQ[solutions] || solutions === {},
    Return[Failure["UnexpectedEmptyFiber", <|"Branch" -> r,
      "Target" -> target|>]]];

  (* Only permutations preserving the ordered branch identify solutions. *)
  stabilizer = Select[Permutations[Range[3]], r[[#]] == r &];
  repMap[p_] := Table[
    First@FirstPosition[chargedReps, chargedReps[[k, p]]],
    {k, nCharged}
  ];
  permuteMatter[v_, p_] := Module[{out = ConstantArray[0, nCharged], map = repMap[p]},
    Do[out[[map[[k]]]] = v[[k]], {k, nCharged}];
    out
  ];
  canonical[sol_] := First@Sort[
    (Join[permuteMatter[Take[sol, nCharged], #], {Last[sol]}] &) /@ stabilizer
  ];

  (* Burnside count avoids constructing millions of canonical vectors. *)
  fixedCounts = Table[Count[solutions, v_ /;
     Take[v, nCharged] === permuteMatter[Take[v, nCharged], p]],
    {p, stabilizer}];
  orbitCount = Total[fixedCounts]/Length[stabilizer];
  inequivalent = If[TrueQ[returnSolutions],
    DeleteDuplicates[canonical /@ solutions], Missing["NotConstructed"]];
  If[TrueQ[returnSolutions] && Length[inequivalent] =!= orbitCount,
    Return[Failure["OrbitMismatch", <|"Branch" -> r|>]]];

  <|
    "Branch" -> r,
    "LabeledCount" -> Length[solutions],
    "StabilizerOrder" -> Length[stabilizer],
    "InequivalentCount" -> orbitCount,
    "Solutions" -> If[TrueQ[returnSolutions], inequivalent, Missing["NotReturned"]]
  |>
];


(* Class numbers are 1..102.  A witness is {y_1,...,y_19,s}. *)
a1CubedClass[k_Integer] /; 1 <= k <= Length[a1CubedTableBranches] :=
  a1CubedTableBranches[[k]];
a1CubedWitness[k_Integer] /; 1 <= k <= Length[a1CubedWitnessEncoded] :=
  ReplacePart[ConstantArray[0, nCharged + 1], a1CubedWitnessEncoded[[k]]];

(* Check the embedded examples directly against all ten integer equations;
   this does not call SolveValues or enumerate any class. *)
a1CubedCheckWitnesses[] := Module[{v, x, r, d, t, p, ok, ij},
  Table[
    v = a1CubedWitness[k];
    x = (smwStep /@ chargedReps) Take[v, nCharged];
    r = a1CubedTableBranches[[k]];
    d = Table[Total[MapThread[#1 dContent[#2, i] &, {x, chargedReps}]], {i, 3}];
    t = Table[Total[MapThread[#1 tContent[#2, i] &, {x, chargedReps}]], {i, 3}];
    p = Table[With[{i = ij[[1]], j = ij[[2]]},
      Total[MapThread[#1 pContent[#2, i, j] &, {x, chargedReps}]]],
      {ij, {{1,2},{1,3},{2,3}}}];
    ok = d === 8 (4 + 7 r - r^2) &&
         t === 2 r (r - 1) &&
         p === 2 {2 r[[1]] r[[2]] + r[[1]] + r[[2]],
                   2 r[[1]] r[[3]] + r[[1]] + r[[3]],
                   2 r[[2]] r[[3]] + r[[2]] + r[[3]]} &&
         Total[x (Times @@@ chargedReps)] + 2 Last[v] === 512;
    If[ok, Nothing, k],
    {k, Length[a1CubedTableBranches]}
  ]
];

(* One canonical solver output: independent SMW multiplicities x_R and
   the neutral full-hyper count s.  Keys are ordered representation triples. *)
a1CubedSpectrum[v_List] /; Length[v] == nCharged + 1 := Module[{rules},
  rules = Thread[chargedReps -> (smwStep /@ chargedReps) Take[v, nCharged]];
  <|"ChargedSMW" -> Association@Select[rules, Last[#] > 0 &],
    "NeutralHypers" -> Last[v]|>
];

exportA1CubedSpectra[k_Integer, file_String] := Module[{r, result, header, records},
  If[!MemberQ[Range[Length[a1CubedTableBranches]], k],
    Return[Failure["UnknownClass", <|"Class" -> k|>]]];
  r = a1CubedClass[k];
  result = countA1CubedFiber[r, True];
  If[!AssociationQ[result], Return[result]];
  header = Join[{"Class", "r1", "r2", "r3"},
    ("(" <> StringRiffle[ToString /@ #, ","] <> ")" &) /@ chargedReps,
    {"NeutralHypers"}];
  records = (Join[{k}, r,
      (smwStep /@ chargedReps) Take[#, nCharged], {Last[#]}] &)
      /@ result["Solutions"];
  Export[file, Prepend[records, header], "CSV"]
];

(* The optional checkpoint is an output file, never a required input.
   It must contain contiguous, structurally matching earlier results. *)
Options[runTable8CountAudit] = {"CheckpointFile" -> None,
  "EndClass" -> 102, "Verbose" -> True};
runTable8CountAudit[OptionsPattern[]] := Module[
  {file = OptionValue["CheckpointFile"], last = OptionValue["EndClass"],
   rows = {}, prior, start, k, result, row, failures},
  If[!IntegerQ[last] || last < 1 || last > Length[a1CubedTableBranches],
    Return[Failure["InvalidEndClass", <|"EndClass" -> last|>]]];
  If[file =!= None && !StringQ[file],
    Return[Failure["InvalidCheckpointFile", <|"File" -> file|>]]];
  If[StringQ[file] && FileExistsQ[file],
    prior = Get[file];
    If[!ListQ[prior] || Length[prior] > last ||
       !And @@ Table[
         AssociationQ[prior[[j]]] && prior[[j]]["Class"] === j &&
         prior[[j]]["Branch"] === a1CubedTableBranches[[j]] &&
         prior[[j]]["ExpectedN"] === a1CubedTableN[[j]] &&
         TrueQ[prior[[j]]["PassQ"]] &&
         prior[[j]]["ComputedN"] === a1CubedTableN[[j]],
         {j, Length[prior]}],
      Return[Failure["InvalidCheckpoint", <|"File" -> file|>]]];
    rows = prior;
  ];
  start = Length[rows] + 1;
  Do[
    If[TrueQ[OptionValue["Verbose"]],
      Print["START class ", k, " of ", last,
        " (branch ", a1CubedTableBranches[[k]], ")"]];
    result = countA1CubedFiber[a1CubedTableBranches[[k]]];
    If[!AssociationQ[result], Return[result]];
    row = <|"Class" -> k, "Branch" -> a1CubedTableBranches[[k]],
      "ExpectedN" -> a1CubedTableN[[k]],
      "LabeledCount" -> result["LabeledCount"],
      "StabilizerOrder" -> result["StabilizerOrder"],
      "ComputedN" -> result["InequivalentCount"],
      "PassQ" -> (result["InequivalentCount"] === a1CubedTableN[[k]])|>;
    AppendTo[rows, row];
    If[StringQ[file], Put[rows, file]];
    If[TrueQ[OptionValue["Verbose"]],
      Print["DONE  class ", k, ": ", row["ComputedN"],
        " (paper ", row["ExpectedN"], ")"]];
    ClearSystemCache[], {k, start, last}
  ];
  failures = Select[rows, !TrueQ[# ["PassQ"]] &];
  <|"BranchesChecked" -> Length[rows], "ExpectedBranches" -> last,
    "ComputedTotal" -> Total[Lookup[rows, "ComputedN", {}]],
    "ReferenceTotal" -> Total[Take[a1CubedTableN, Length[rows]]],
    "FailedClasses" -> Lookup[failures, "Class", {}],
    "CompleteQ" -> (Length[rows] === last),
    "MatchesPaper" -> (Length[rows] === last && failures === {} &&
      Total[Lookup[rows, "ComputedN", {}]] === Total[Take[a1CubedTableN, last]]),
    "Rows" -> rows|>
];
