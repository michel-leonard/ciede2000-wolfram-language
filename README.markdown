Browse : [Rust](https://github.com/michel-leonard/ciede2000-rust) · [SQL](https://github.com/michel-leonard/ciede2000-sql) · [Swift](https://github.com/michel-leonard/ciede2000-swift) · [TypeScript](https://github.com/michel-leonard/ciede2000-typescript) · [VBA](https://github.com/michel-leonard/ciede2000-vba) · **Wolfram Language** · [AWK](https://github.com/michel-leonard/ciede2000-awk) · [BC](https://github.com/michel-leonard/ciede2000-basic-calculator) · [C#](https://github.com/michel-leonard/ciede2000-csharp) · [C++](https://github.com/michel-leonard/ciede2000-cpp) · [C99](https://github.com/michel-leonard/ciede2000-c)

# CIEDE2000 color difference formula in Mathematica

This page presents the CIEDE2000 color difference, implemented in the Wolfram Programming Language.

![Logo for CIEDE2000 in Mathematica](https://raw.githubusercontent.com/michel-leonard/ciede2000-color-matching/refs/heads/main/docs/assets/images/logo.jpg)

## About

Here you’ll find the first rigorously correct implementation of CIEDE2000 that doesn’t use any conversion between degrees and radians. Set parameter `canonical` to obtain results in line with your existing pipeline.

`canonical`|The algorithm operates...|
|:--:|-|
`False`|in accordance with the CIEDE2000 values currently used by many industry players|
`True`|in accordance with the CIEDE2000 values provided by [this](https://hajim.rochester.edu/ece/sites/gsharma/ciede2000/) academic MATLAB function|

## Our CIEDE2000 offer

This production-ready file, released in 2026, contain the CIEDE2000 algorithm.

Source File|Type|Bits|Purpose|Advantage|
|:--:|:--:|:--:|:--:|:--:|
[ciede2000.wl](./ciede2000.wl)|`Real`|64|Scientific|Interoperability|

The `ciede2000` function works on 64-bit `Real` numbers and operates in `MachinePrecision`.

### Software Versions

- Wolfram Language 14.3
- WolframScript 1.13
- Mathematica Online

### Example Usage

We calculate the CIEDE2000 distance between two colors, first without and then with parametric factors.

```mathematica
(* Example of two L*a*b* colors *)
l1 = 93.9;  a1 = 125.4;  b1 = -7.6;
l2 = 98.1;  a2 = 60.4;   b2 = 3.9;

deltaE = ciede2000[l1, a1, b1, l2, a2, b2];

Print["CIEDE2000 = ", deltaE];
(* ΔE2000 = 13.354969270072646 *)

(* Example of parametric factors used in the textile industry *)
kl = 2.0; kc = 1.0; kh = 1.0;

(* Perform a CIEDE2000 calculation compliant with that of Gaurav Sharma *)
canonical = True;

deltaE = ciede2000[l1, a1, b1, l2, a2, b2, kl, kc, kh, canonical];

Print["CIEDE2000 = ", deltaE];
(* ΔE2000 = 13.179691956995732 *)
```

### Test Results

LEONARD’s tests are based on well-chosen L\*a\*b\* colors, with various parametric factors `kL`, `kC` and `kH`.

```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : 93.0,5.0,-21.0,94.0,28.0,120.0,1.0,1.0,1.0,47.69446104798974
           Precision : 12 decimal digits
           Successes : 10000000
               Error : 0
            Duration : 2714.26 seconds
     Average Delta E : 67.13
   Average Deviation : 7e-15
   Maximum Deviation : 3e-13
```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : 93.0,5.0,-21.0,94.0,28.0,120.0,1.0,1.0,1.0,47.694660278178866
           Precision : 12 decimal digits
           Successes : 10000000
               Error : 0
            Duration : 2729.50 seconds
     Average Delta E : 67.13
   Average Deviation : 7.2e-15
   Maximum Deviation : 3e-13
```

## Public Domain Licence

You are free to use these files, even for commercial purposes.
