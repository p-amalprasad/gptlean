--BPP A promise problem A (Ayes Ano) is in BPP if and only if there exists a polynomial-time probabilistic Turing machine M that accepts every string x Ayes with probability at least 2/3, and accepts every string x E Ano with probability at most 1/3.

-- Mathlib.MeasureTheory.probability_space
-- import Mathlib.MeasureTheory.Category.integration
import Mathlib.Probability.ConditionalProbability
import Mathlib.Probability.Integration
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
namespace bpp

-- Definition of a probabilistic algorithm
structure probabilistic_algorithm :=
  (algorithm : ℕ → Bool)
  (bounded_error : ∃ (poly : ℕ → ℕ), ∀ (n : ℕ), ProbabilityMeasure{k | algorithm k = algorithm n} ≥ 1/2 + 1/poly n)

-- BPP complexity class
def BPP (P : probabilistic_algorithm → Prop) :=
  ∃ (poly : ℕ → ℕ), ∀ (n : ℕ), ∀ (pa : ConditionalProbability),
    P pa → (pa.algorithm n = tt → ProbabilityMeasure {k | pa.algorithm k = tt} ≥ 2/3) ∧ (pa.algorithm n = ff → ProbabilityMeasure{k | pa.algorithm k = ff} ≤ 1/3)

-- Theorem: BPP is a subclass of P
theorem BPP_is_P (P : probabilistic_algorithm → Prop) :
  BPP P → P (λ pa, ∃ (n : ℕ), pa.algorithm n = tt) :=
begin
  -- Introduce the BPP assumption
  rintros ⟨poly, h⟩,

  -- Use a specific polynomial for simplicity; replace with a suitable one
  use (λ n, n^2 + n + 1),

  -- Introduce n and a probabilistic algorithm pa
  intros n pa hP,

  -- Use classical logic to handle cases where the algorithm outputs true or false
  cases' classical.em (pa.algorithm n = tt) with h1 h2,

  -- Case: pa.algorithm n = tt
  {
    -- Apply the correctness property for true output
    exact (h n pa hP).left h1,
  },

  -- Case: pa.algorithm n = ff
  {
    -- Apply the error bound property for false output
    exact (h n pa hP).right h2,
  }

end bpp
