import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.NumberTheory.Padics.PadicVal
import Mathlib.NumberTheory.Padics.PadicNumbers
import Mathlib.Topology.MetricSpace.Completion
import Mathlib.Algebra.Order.Archimedean
import Mathlib.Analysis.Normed.Field.Basic
import Mathlib.Topology.UniformSpace.Cauchy
import Mathlib.Tactic
import Mathlib.Algebra.Order.Group.Abs
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.Positivity
import Mathlib.Topology.Algebra.Order.Compact
import Mathlib.Topology.MetricSpace.EMetricSpace
import Mathlib.Topology.Bornology.Constructions
import Mathlib.Topology.UniformSpace.Completion
import Mathlib.RingTheory.Valuation.ValuationRing
import Mathlib.RingTheory.Ideal.LocalRing
import Mathlib.Algebra.Ring.Defs
import Mathlib.RingTheory.Valuation.Integers
import Mathlib.RingTheory.Ideal.LocalRing
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.RingTheory.Localization.Integer
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.RingTheory.Bezout
import Mathlib.Tactic.FieldSimp
import Mathlib.Algebra.Algebra.Basic
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.Topology.Algebra.ValuedField
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Polynomial.Basic
import Mathlib.Analysis.Complex.Polynomial

set_option maxHeartbeats 300000
open Filter TopologicalSpace Set Classical UniformSpace Function

open Classical Uniformity Topology Filter Polynomial

class CompleteNormedField (α : Type _) 
  extends Norm α, Field α, MetricSpace α, CompleteSpace α where
  /-- The distance is induced by the norm. -/
  dist_eq : ∀ x y, dist x y = norm (x - y)
  /-- The norm is multiplicative. -/
  norm_mul' : ∀ a b, norm (a * b) = norm a * norm b
  /-- In a complete uniform space, every Cauchy filter converges. -/
  complete_field : ∀ {f : Filter α}, Cauchy f → ∃ x, f ≤ 𝓝 x

class ArchimedeanField (α : Type _)
  extends NormedField α where 
  anti_tri_ineq : ∃ x y, norm (x + y) > max (norm x) (norm y)

class NonArchimedeanField (α : Type _)
  extends NormedField α where 
  strong_tri_ineq : ∀ x y, norm (x + y) ≤  max (norm x) (norm y)

class CompleteNonArchimedeanField (α : Type _) 
  extends NonArchimedeanField α, CompleteNormedField α

#check Archimedean
#check ℝ 

/- Proposition 4.2 : Let K be a field which is complete with respect to
  an archimedean valuation | |. Then there is an isomorphism σ from K 
  onto ℝ or ℂ satisfying |a| = |σ a| ^ s for all a ∈ K,
  for some fixed s ∈ (0,1]. -/

theorem IsotoValEqR {K :Type _} [NormedField K] (f : K ≃+* ℝ) :
∀ (x : K), ∃ (s : ℝ) (hs : (s > 0 ∧ s < 1)), ‖x‖ = ‖f x‖ ^ s := sorry

theorem IsotoValEqC {K :Type _} [NormedField K] (f : K ≃+* ℂ) :
∀ (x : K), ∃ (s : ℝ) (hs : (s > 0 ∧ s < 1)), ‖x‖ = ‖f x‖ ^ s := sorry

theorem Ostrowski {K :Type _} [NormedField K] [CompleteSpace K] [ArchimedeanField K]
:(∃ (f : K ≃+* ℂ), ∀ (x : K), ∃ (s : ℝ) (hs : (s > 0 ∧ s < 1)), norm x = norm (f x) ^ s)
∨  (∃ (f : K ≃+* ℝ), ∀ (x : K), ∃ (s : ℝ) (hs : (s > 0 ∧ s < 1)), norm x = norm (f x) ^ s )
  := by
    have h₁ : ∃ (g₁ : ℝ →+* K), Function.Injective g₁ := sorry
    have h₂ : ∃ (g₂ : K →+* ℂ), Function.Injective g₂ := sorry 
    rcases h₂ with ⟨g₂, h₃⟩ 
    have exist_iso : (∃ (f : K ≃+* ℝ), Function.Bijective f) ∨ 
    (∃ (f : K ≃+* ℂ),  Function.Bijective f) := by 
      have h₃ : ∀ (x : K), ∃ (f : Polynomial ℝ), Polynomial.degree f = 2 
      ∧ Polynomial.eval (g₂ x) (Polynomial.map (Complex.ofReal) f) = 0 
      := by 
        intro x
        let ξ := g₂ x
        let f : ℂ → ℝ := fun (z : ℂ) ↦ |‖ξ^2 - (2 * z.re) * ξ + (z.re)^2 + (z.im)^2‖|
        have fHasMin : ∃ (zmin : ℂ), ∀ (z : ℂ), f zmin ≤ f z := sorry
        rcases fHasMin with ⟨zmin, hfHasMin⟩
        let m : ℝ  := f zmin
        have fInverseBounded : ∃ (z₀ :ℂ), ∀ (z : ℂ) (hz : f z = m), Complex.abs z ≤ Complex.abs z₀:= sorry
        rcases fInverseBounded with ⟨z₀, h1⟩
        have meqzero : m = 0 := by
          by_contra hm 
          have mneq : m < 0 ∨ m > 0 := by exact Ne.lt_or_lt hm
          rcases mneq with mneg | mpos          
          have : 0 ≤ m  := abs_nonneg _ 
          linarith
          let g : ℝ[X] := X^2 - (Polynomial.monomial 1).toFun (2 * z₀.re) + 1
          let g' := Polynomial.map (Complex.ofReal) g
          have hg : 0 < Polynomial.degree g' := sorry
          have gHasRoot : ∃ (z : ℂ), Polynomial.IsRoot g' z := by 
            exact @Complex.exists_root g' hg
          rcases gHasRoot with ⟨z₁, IsRoot⟩
          have gzeqzero : Polynomial.eval z₁ g' = 0 := by exact IsRoot
          have flem : ∀ (n : ℕ), (f z₁) / m ≤ (1 + (1 / 2) ^ n) ^ 2 := by
            intro n  
            let G : ℝ[X] := (g - (Polynomial.monomial (R := ℝ) 0 (m/2))) ^ n - ((Polynomial.monomial 0).toFun (- m/2)) ^ n
            let G' := Polynomial.map (Complex.ofReal) G

            have GHasRoot : Polynomial.eval z₁ G' = 0 := by 
              calc 
              Polynomial.eval z₁ G' = (Polynomial.eval z₁ g' - (m / 2)) ^ n - ((- m/2)) ^ n := by simp
              _ = (0 - (m / 2 : ℂ)) ^ n - ((- m/2 : ℂ)) ^ n := by rw [gzeqzero]
              _ = (- (m / 2 : ℂ)) ^ n - ((- m/2 : ℂ)) ^ n := by simp only [zero_sub, Complex.cpow_nat_cast, div_pow]
              _ = ((- m / 2 : ℂ)) ^ n - ((- m/2 : ℂ)) ^ n := by congr 2; ring
              _ = 0 := by simp only [Complex.cpow_nat_cast, div_pow, sub_self]
            have Ggeineq : (Complex.abs (Polynomial.eval ξ G')) ^ 2 ≥ (f z₁) * m ^ (2 * n - 1) := sorry
            have Gleineq : Complex.abs (Polynomial.eval ξ G') ≤ m ^ n + (m/2) ^ n := sorry
            have leineq : (f z₁) * m ^ (2*n - 1) ≤ (m ^ n + (m/2) ^ n) ^ 2 := by 
              calc
              (f z₁) * m ^ (2*n - 1) ≤ (Complex.abs (Polynomial.eval ξ G')) ^ 2 := by exact Ggeineq
              _ ≤  (m ^ n + (m/2) ^ n)^2 := sorry
            sorry
          sorry
        sorry
      sorry
    rcases exist_iso with IsoToR | IsoToC
    · right
      rcases IsoToR with ⟨f, hf⟩
      use f
      intro x
      exact @IsotoValEqR K _ f _
    · left
      rcases IsoToC with ⟨f, hf⟩
      use f
      intro x
      exact @IsotoValEqC K _ f _

#check Completion
#check ValuationRing.ValueGroup
#check Valuation
#check ValuationRing.localRing
#check FractionRing

variable (K : Type v) 


-- Proposition 4.3
def ValIntR [Field K] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation K Γ) :
  Subring K := Valuation.integer v

instance  [Field K] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation K Γ) : 
ValuationRing (ValIntR K v) := by sorry

instance  [Field K] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation K Γ) : 
LocalRing (ValIntR K v) := by exact ValuationRing.localRing { x // x ∈ ValIntR K v }


def LocMaxIdea [Field K] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation K Γ) :
Ideal (ValIntR K v) := LocalRing.maximalIdeal ((ValIntR K v))


theorem ResidualOfCompletion [Field K] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation K Γ) (hv : Valued K Γ)
:
 let v' :=  @Valued.extensionValuation K _ Γ _ hv;
  (ValIntR K v) ⧸ (LocMaxIdea K v) ≃+* (ValIntR (Completion K) v') ⧸ ((LocMaxIdea (Completion K) v')) 
  := sorry

-- Proposition 4.4

def IsPrimiPAdic [Field F1] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation F1 Γ) 
  (f : Polynomial F1) : Prop :=
  (∀ n : ℕ , v (Polynomial.coeff f n) ≤ 1) ∧ (∃ n : ℕ, v (Polynomial.coeff f n) = 1 )

#check IsPrimiPAdic

theorem prim [Field F1] {Γ : Type _} 
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation F1 Γ) 
(f : Polynomial F1) : 
IsPrimiPAdic v f ↔ Polynomial.IsPrimitive f := sorry

theorem hensel_lemma [Field F1] {Γ : Type _} {hp : Type _}
[inst : LinearOrderedCommGroupWithZero Γ]  (v : Valuation F1 Γ) (f : Polynomial F1) 
: 
   ℕ 
  := sorry
 