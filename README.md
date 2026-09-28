# Wolfram Language scans for 6D $N=(1,0)$ $Sp(1)_R$-gauged models

This repository contains scans for the $n_V=96$ branch and the $n_V=12$ $A_2\times U(1)$ and $A_1^3$ branches. The archive `nV=96 branch.zip` contains the staged $n_V=96$ spectra-assembly calculation, its inputs, and saved outputs. The `n_V=96 single_factor_scan.wl` program, if included separately in the repository, is a separate one-factor interface.

## $n_V=96$: staged spectra assembly

Unzip `nV=96 branch.zip` to retain the `nV=96 branch/n=1/` through `nV=96 branch/n=5/` directories. If sharing the work on GitHub, upload the extracted directories as well so readers can browse the programs and results without downloading the whole archive.

Here $n$ is the number of simple gauge factors other than $Sp(1)_R$. The assembly uses one-factor spectra as seeds, then lifts an $(n-1)$-factor spectrum together with a one-factor spectrum, imposing the local and mixed-anomaly constraints and removing duplicates under permutations of identical factors.

| Stage | Main source | Archived result |
| --- | --- | ---: |
| $n=1$ | `n=1/n=1 scan.nb` and `n=1/n1_Sp1R_Catalogue.pdf` | 652 local spectra in the PDF; 646 after the common odd-lattice filter |
| $n=2$ | `n=2/GTSA_n2_complete_scan.wl` | 1,968 |
| $n=3$ | `n=3/GTSA_n3_complete_scan.wl` | 1,092 |
| $n=4$ | `n=4/GTSA_n4_complete_scan.wl` | 388 |
| $n=5$ | `n=5/GTSA_n5_complete_scan.wl` | 0 |

The six one-factor spectra removed by the lattice filter are the denominator-three $G_2$ cases. The combined `all nV=96 anomaly free spectra.pdf` reports $646+1968+1092+388=4094$ retained spectra and no spectra for $n\geq5$. These counts include spectra with drone vectors; they are not counts of drone-free endpoints. Each stage imposes a nonnegative drone count $M_{\mathrm{drone}}=93-\sum_i\dim G_i$.

### Representation-coefficient dictionary

The short keys in the ZIP's `RepInfo.nb` files **do not have the same names as the representation coefficients in the paper**. The assembly drivers read them as follows:

| `RepInfo.nb` key | Paper's coefficient | Internal driver field |
| --- | --- | --- |
| `a` | $B_R$, coefficient of $\operatorname{tr} F^4$ | `"QuarticB"` |
| `b` | $C_R$, coefficient of $(\operatorname{tr} F^2)^2$ | `"QuadC"` |
| `c` | $A_R$, quadratic trace index | `"IndexA"` |

Thus the A1 fundamental entry `a -> 0, b -> 1/2, c -> 1` in `RepInfo.nb` means $B_{\mathbf2}=0,\ C_{\mathbf2}=1/2,\ A_{\mathbf2}=1$. The lowercase `a` and `b` keys in representation data are unrelated to the anomaly-lattice vectors $a$ and $b_i$. The assembly drivers use the off-diagonal lattice convention `eta = {{0,1},{1,0}}`, `aVec = {-2,-2}`, and `bRVec = {3/2,-5}`.

### Read saved spectra without rerunning a scan

Each `n=k/nk_GTSA_complete_outputs/` directory contains `nk_GTSA_all_spectra.wl` (a Wolfram Language list), a `.wxf` version, a readable `.txt` list, a final count CSV, and one text file per scanned group tuple. For example, in Mathematica, choose the saved **spectra** file:

```wl
spectra2 = Get[SystemDialogInput["FileOpen"]];  (* select n2_GTSA_all_spectra.wl *)
Length[spectra2]                                (* 1968 *)
Take[spectra2, UpTo[3]]
Dataset[spectra2]
```

The archived `n5_GTSA_all_spectra.wl` evaluates to an empty list. The `*_counts_final.csv` files have one row per scanned group tuple; the last column is that tuple's count. The `n1_Sp1R_Catalogue.pdf` in each assembly folder is an input containing all 652 local one-factor spectra, **before** the six-entry lattice filter applied by the drivers.

### Rerun an assembly stage

A Wolfram/Mathematica installation with PDF import and `NotebookImport` is needed. Keep the folder structure intact. Each stage's driver reads its local `RepInfo.nb` and `n1_Sp1R_Catalogue.pdf`. Stages $n=3,4,5$ also read the respective preceding-stage snapshot `n2_GTSA_all_spectra.wl`, `n3_GTSA_all_spectra.wl`, or `n4_GTSA_all_spectra.wl` **in that stage's own folder**; these snapshots are included in the ZIP.

The drivers contain a machine-specific default `$BaseDir` pointing to `C:\Physics\6d anomaly free models\n=k`. Before running a stage on another machine, edit the `$BaseDir` assignment near the beginning of **that stage's** `GTSA_nk_complete_scan.wl` to the absolute path of its extracted `n=k` directory. For example, for $n=2$:

```wl
If[! ValueQ[$BaseDir], $BaseDir = "C:/path/to/nV=96 branch/n=2"];
```

Use the corresponding `n=3`, `n=4`, or `n=5` path for the other drivers. In the $n=2$ and $n=3$ drivers, ``ClearAll["Global`*"]`` at the beginning clears settings assigned in a notebook **before** `Get`; edit their default path inside the driver rather than relying on a preceding `$BaseDir = ...` input. The driver has `$RunNow = True` by default: loading it with `Get` starts the full scan and writes output files.

```wl
Get["C:/path/to/nV=96 branch/n=2/GTSA_n2_complete_scan.wl"]
```

For $n=3,4,5$, replace both the stage number and filename. If you regenerate stage $n-1$, the next stage still reads its **bundled snapshot** unless you replace that snapshot or edit the next driver's `$N2SpectraWL`, `$N3SpectraWL`, or `$N4SpectraWL` path to point to the newly generated `nk_GTSA_complete_outputs/nk_GTSA_all_spectra.wl`. Run stages in order if you want every stage to use newly computed inputs. Full scans can be lengthy and will write their final files in the corresponding `nk_GTSA_complete_outputs` directory.

## Optional standalone one-factor program

If `n_V=96 single_factor_scan.wl` is also supplied in the repository, it can be loaded independently of the ZIP. Its 48 candidate classes are labeled by the paper's Table 2 class numbers:

```wl
Get[SystemDialogInput["FileOpen"]];       (* select n_V=96 single_factor_scan.wl *)
classData[38]
one = solveClass[38];
Length[one]
allByClass = scanAll[];
checkClass[allByClass]
showClass[allByClass, 38]
```

That standalone program reports 646 spectra across 38 nonempty branches after the lattice conditions. Its functions, output format, and representation data are distinct from the ZIP's `n=1/n=1 scan.nb` and staged GTSA drivers. A seed with drones is not itself a drone-free endpoint.

## $n_V=12$: $A_2\times U(1)$

The self-contained `A2xU1.wl` file uses the off-diagonal metric `{{0,1},{1,0}}` and `a = {-2,-2}`. Classes are specified by $(p,k)$, with $p\in\{-25,-23,-17,-15,-9,-7,-1\}$ and $k=1,2,3$ in the no-drone scan. Load it in a fresh kernel:

```wl
Get[SystemDialogInput["FileOpen"]];          (* select A2xU1.wl *)
a2u1ClassNumber[-25, 1]                 (* 8 *)
class8 = countA2U1Fiber[-25, 1, "ReturnSolutions" -> True];
class8["InequivalentCount"]              (* 231 *)
Take[class8["Solutions"], UpTo[5]]
exportA2U1Spectra[-25, 1, "A2_class8.csv"]

audit = runA2U1CountAudit[];
audit["ByK"]                             (* <|1 -> 813, 2 -> 22408, 3 -> 155317|> *)
audit["ComputedTotal"]                   (* 178538 *)
audit["MatchesPaper"]                    (* True *)
```

The $k=0$ formal drone classes are excluded by default; use `runA2U1CountAudit["IncludeDrone" -> True]` to include them. Counting without `"ReturnSolutions" -> True` uses less memory.

## $n_V=12$: $A_1^3$

The self-contained `A1 Cubed.wl` file has 102 Table 8 classes. One class can be specified by its table number or mapped to an ordered branch triple:

```wl
Get[SystemDialogInput["FileOpen"]];        (* select A1 Cubed.wl *)
a1CubedCheckWitnesses[]               (* {} if all embedded examples pass *)
a1CubedClass[36]                       (* {1,1,2} *)
class36 = countA1CubedFiber[a1CubedClass[36], True];
class36["InequivalentCount"]            (* 19 *)
Take[a1CubedSpectrum /@ class36["Solutions"], UpTo[5]]
exportA1CubedSpectra[36, "A1cubed_class36.csv"]

table8Audit = runTable8CountAudit[
  "CheckpointFile" -> "table8_audit_progress.wl"
];
table8Audit["ComputedTotal"]            (* 4337331 *)
table8Audit["MatchesPaper"]             (* True *)
```

The audit can take substantial time. The checkpoint stores counts so rerunning with the same filename resumes the audit; listing all spectra for a large class takes additional memory.

## Working with output files

`Get` reads a saved Wolfram Language `.wl` expression. `Put` and `Export` write relative filenames to Mathematica's current directory; check it with `Directory[]` or supply an absolute filename. Start a fresh kernel when switching independent scans to avoid stale definitions.

