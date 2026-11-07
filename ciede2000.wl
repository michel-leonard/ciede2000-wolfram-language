(* This function written in Wolfram Language is not affiliated with the CIE (International Commission on Illumination),
and is released into the public domain. It is provided "as is" without any warranty, express or implied. *)

(* The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
"l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127. *)
ciede2000[l1_Real, a1_Real, b1_Real, l2_Real, a2_Real, b2_Real, kl_Real: 1.0, kc_Real: 1.0, kh_Real: 1.0, canonical: (_?BooleanQ): False] := Module[
	(* Working in Mathematica with the CIEDE2000 color-difference formula.
	kl, kc, kh are parametric factors to be adjusted according to
	different viewing parameters such as textures, backgrounds... *)
	{npi, n, c1, c2, c, h1, h2, hm, hd, rt, l, t, h},
	npi = N[Pi];
	c1 = b1 * b1;
	c2 = b2 * b2;
	n = ((Sqrt[a1 * a1 + c1] + Sqrt[a2 * a2 + c2]) * 0.5) ^ 7.0;
	(* A factor involving chroma raised to the power of 7 designed to make
	the influence of chroma on the total color difference more accurate. *)
	n = 1.0 + 0.5 * (1.0 - Sqrt[n / (n + 6103515625.0)]);
	(* atan2 is preferred over atan because it accurately computes the angle of
	a point (x, y) in all quadrants, handling the signs of both coordinates. *)
	c = a1 * n;
	h1 = If[a1 == 0.0 && b1 == 0.0, 0.0, ArcTan[c, b1]];
	If[h1 < 0.0, h1 += 2.0 * npi];
	c1 = Sqrt[c * c + c1];
	c = a2 * n;
	h2 = If[a2 == 0.0 && b2 == 0.0, 0.0, ArcTan[c, b2]];
	If[h2 < 0.0, h2 += 2.0 * npi];
	c2 = Sqrt[c * c + c2];
	(* When the hue angles lie in different quadrants, the straightforward
	average can produce a mean that incorrectly suggests a hue angle in
	the wrong quadrant, the next lines handle this issue. *)
	hm = (h1 + h2) * 0.5;
	hd = (h2 - h1) * 0.5;
	(* The part where most programmers get it wrong. *)
	If[npi + 0.00000000000001 < Abs[h2 - h1],
		hd += npi;
		If[canonical && npi + 0.00000000000001 < hm,
			(* Sharma’s implementation, OpenJDK, ... *)
			hm -= npi,
			(* Lindbloom’s implementation, Netflix’s VMAF, ... *)
			hm += npi
		];
	];
	n = ((c1 + c2) * 0.5) ^ 7.0;
	(* The hue rotation correction term is designed to account for
	the non-linear behavior of hue differences in the blue region. *)
	rt = -2.0 * Sqrt[n / (n + 6103515625.0)];
	n = 36.0 * hm - 55.0 * npi;
	rt *= Sin[npi / 3.0 * Exp[n * n / (-25.0 * npi * npi)]];
	n = (l1 + l2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	(* Lightness. *)
	l = (l2 - l1) / (kl * (1.0 + 0.015 * n / Sqrt[20.0 + n]));
	(* These coefficients adjust the impact of different
	harmonic components on the hue difference calculation. *)
	t = 1.0 - 0.17 * Sin[hm + npi / 3.0];
	t += 0.24 * Sin[2.0 * hm + npi * 0.5];
	t += 0.32 * Sin[3.0 * hm + 8.0 * npi / 15.0];
	t -= 0.20 * Sin[4.0 * hm + 3.0 * npi / 20.0];
	n = c1 + c2;
	(* Hue. *)
	h = 2.0 * Sqrt[c1 * c2] * Sin[hd] / (kh * (1.0 + 0.0075 * n * t));
	(* Chroma. *)
	c = (c2 - c1) / (kc * (1.0 + 0.0225 * n));
	(* The result reflects the actual geometric distance in color space, given a tolerance of 3.6e-13. *)
	Sqrt[l * l + h * h + c * c + c * h * rt]
]

(* If you remove the constant 0.00000000000001, the code will continue to work, but
CIEDE2000 interoperability between all programming languages will no longer be guaranteed.

Source code tested by Michel LEONARD
Website: ciede2000.pages-perso.free.fr *)
