Wolfram Language scans for 6D $N=(1,0)$ models
This repository contains three independent Wolfram Language (`.wl`) programs for spectra with gauged $Sp(1)_R$:
File	Model	How to specify a class	Main functions
`n\_V=96 single\_factor\_scan.wl`	One nonabelian gauge factor, $n_V=96$, with possible drone vectors	Table 2 class number `1`–`48`	`classData`, `solveClass`, `scanAll`, `checkClass`
`A2xU1.wl`	$A_2\times U(1)$, $n_V=12$	Pair `{p,k}`, passed as two arguments	`countA2U1Fiber`, `runA2U1CountAudit`, `exportA2U1Spectra`
`A1 Cubed.wl`	$A_1^3$, Table 8	Table 8 class number `1`–`102`, or its branch triple	`a1CubedClass`, `countA1CubedFiber`, `runTable8CountAudit`, `exportA1CubedSpectra`
All three files contain their representation data and class tables. They can be loaded independently; no companion notebook or data file is required. Loading a file defines its functions; it does not start an exhaustive scan. The first two files perform quick consistency checks when loaded. For the $A_1^3$ file, call `a1CubedCheckWitnesses\[]` to check its embedded examples.
Load a file
Open Mathematica and evaluate one of the following in a notebook. The file chooser avoids assumptions about the current working directory:
```wl
Get\[SystemDialogInput\["FileOpen"]]  (\* choose n\_V=96 single\_factor\_scan.wl \*)
```
or
```wl
Get\[SystemDialogInput\["FileOpen"]]  (\* choose A2xU1.wl \*)
```
or
```wl
Get\[SystemDialogInput\["FileOpen"]]  (\* choose A1 Cubed.wl \*)
```
If you already know the full path, use `Get\["/full/path/to/file.wl"]`. On Windows, forward slashes in the path also work, for example `Get\["C:/path/to/A2xU1.wl"]`. Start a fresh kernel when switching scans or after updating a file so that you know which definitions are loaded.
One-factor scan: $n_V=96$
The file includes the representation menu and 48 candidate anomaly-vector classes. A class is identified by its integer Table 2 number. For example, inspect class 38, then enumerate only that class:
```wl
classData\[38]               (\* group, anomaly data, representation menu, targets \*)
one = solveClass\[38];       (\* list of spectra; may be empty \*)
Length\[one]
Take\[one, UpTo\[3]]          (\* first three spectra, if present \*)
```
Each spectrum is an association containing `"G"`, `"p"`, `"q"`, `"b"`, `"Drones"`, `"Singlets"`, `"HCharged"`, and `"Spectrum"`. The last field lists its nonzero irreducible representations, their Dynkin labels, dimensions, and multiplicities `"m"`. The multiplicity `m` is measured in full-hypermultiplet units; it can be `1/2` for a pseudoreal representation.
To scan all 48 candidate classes and compare the counts with the paper:
```wl
allByClass = scanAll\[];
classSummary\[allByClass]              (\* one row per class, including zeros \*)
checkClass\[allByClass]
showClass\[allByClass, 38]            (\* retrieve one scanned class \*)
```
`checkClass` reports `"ComputedTotal" -> 646`, `"ComputedBranches" -> 38`, and `"MatchesPaper" -> True` when the full result agrees with the reference table. It checks group totals as well as the overall counts. The scan can take time; `solveClass\[k]` is useful for trying one class first.
Save the scan result in Wolfram Language format, then load it in a later session without rerunning the scan:
```wl
Put\[allByClass, "one\_factor\_by\_class.wl"];
allByClass = Get\["one\_factor\_by\_class.wl"];
```
These one-factor spectra are seeds for the spectra-assembly procedure. A seed with drone vectors is not by itself a drone-free physical endpoint.
$A_2\times U(1)$ scan
Here a class is identified by $p\in{-25,-23,-17,-15,-9,-7,-1}$ and $k\in{1,2,3}$. For example, $(p,k)=(-25,1)$ is class 8:
```wl
a2u1ClassNumber\[-25, 1]                 (\* 8 \*)
a2u1Targets\[-25, 1]                     (\* {256,156,480,96,96,50,0} \*)
class8 = countA2U1Fiber\[-25, 1];
class8\["InequivalentCount"]             (\* 231 \*)
class8\["PassQ"]                         (\* True \*)
```
To list the actual spectra, request solutions explicitly:
```wl
class8 = countA2U1Fiber\[-25, 1, "ReturnSolutions" -> True];
class8\["InequivalentCount"]
Take\[class8\["Solutions"], UpTo\[5]]
Dataset\[class8\["Solutions"]]
```
`"Solutions"` is a list of associations with only nonzero multiplicities. Keys such as `"3\_1"` and `"bar3\_1"` distinguish the charged complex orientations. Solutions are counted up to the simultaneous $U(1)$ charge reversal specified in the code. For the underlying integer vectors in the order `a2u1VariableOrder`, set `"FormattedSolutions" -> False` together with `"ReturnSolutions" -> True`.
To export one class as a CSV (one column per representation/charge block):
```wl
exportA2U1Spectra\[-25, 1, "A2\_class8.csv"]
```
To audit all 21 physical no-drone classes:
```wl
audit = runA2U1CountAudit\[];
audit\["ByK"]              (\* <|1 -> 813, 2 -> 22408, 3 -> 155317|> \*)
audit\["ComputedTotal"]    (\* 178538 \*)
audit\["MatchesPaper"]     (\* True \*)
audit\["FailedClasses"]    (\* {} \*)
```
The $k=0$ sector contains seven additional formal drone classes and is excluded by default. Include it explicitly with `runA2U1CountAudit\["IncludeDrone" -> True]`. Calling the audit with `"ReturnSolutions" -> True`, or listing solutions for a large class, can use substantially more memory than counting alone.
$A_1^3$ scan (Table 8)
The file includes all 102 Table 8 class labels, reference counts, and one example spectrum per class. A class number maps to a branch triple ${r_1,r_2,r_3}$:
```wl
a1CubedCheckWitnesses\[]                       (\* {} if all examples pass \*)
a1CubedClass\[36]                              (\* {1,1,2} \*)
a1CubedSpectrum\[a1CubedWitness\[36]]           (\* one embedded example \*)

class36 = countA1CubedFiber\[a1CubedClass\[36]];
class36\["InequivalentCount"]                  (\* 19 \*)
```
Pass `True` as the second argument to return every inequivalent spectrum in that class. The default call above computes the count without constructing the list of canonical representatives:
```wl
class36 = countA1CubedFiber\[a1CubedClass\[36], True];
class36\["InequivalentCount"]                  (\* 19 \*)
spectra36 = a1CubedSpectrum /@ class36\["Solutions"];
Take\[spectra36, UpTo\[5]]
Dataset\[spectra36]
```
Each formatted spectrum has `"ChargedSMW"` (nonzero coefficients indexed by ordered representation triples such as `{2,1,1}`) and `"NeutralHypers"` (the number of neutral full hypers). The charged coefficients are in the code's SMW units: a pseudoreal representation permits one unit, while a real representation is constrained to even SMW multiplicity. `class36\["Solutions"]` itself contains the independent integer solver variables and the neutral count.
Export all spectra in one class to CSV with a column for each representation triple:
```wl
exportA1CubedSpectra\[36, "A1cubed\_class36.csv"]
```
Audit the 102 classes, saving progress after each one. Running the same command again resumes from that checkpoint:
```wl
table8Audit = runTable8CountAudit\[
  "CheckpointFile" -> "table8\_audit\_progress.wl"
];
table8Audit\["BranchesChecked"]              (\* 102 after completion \*)
table8Audit\["ComputedTotal"]                (\* 4337331 \*)
table8Audit\["MatchesPaper"]                 (\* True \*)
table8Audit\["FailedClasses"]                (\* {} \*)
```
`runTable8CountAudit\[]` performs a fresh scan without writing a checkpoint. The full scan can take substantial time and memory. Listing a large class with `countA1CubedFiber\[branch, True]` or exporting its spectra requires additional memory. The checkpoint records counts, not the spectra themselves; enumerate a class separately to list its spectra.
Conventions and outputs
The three scans concern different branches. The $A_2\times U(1)$ and $A_1^3$ files use the off-diagonal metric `{{0,1},{1,0}}` with `a = {-2,-2}`. The optional `a2u1OddEmbedding\[p,k]` describes a separate integral embedding; it is not the coordinate system used for the $A_2\times U(1)$ scan. The one-factor file uses the odd diagonal basis described in its Table 2 data and the paper's representation coefficients $a_R=A_R$, $b_R=B_R$, $c_R=C_R$. Do not mix the coordinate systems or class labels.
`Export` and `Put` write relative filenames to Mathematica's current directory, which you can inspect with `Directory\[]`. To select an explicit destination, supply an absolute filename or build one with `FileNameJoin`.
