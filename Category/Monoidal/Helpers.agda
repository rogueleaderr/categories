{-# OPTIONS --universe-polymorphism #-}
module Category.Monoidal.Helpers where

open import Support hiding (_×_)
open import Category
open import Category.Monoidal.Builders

open import Category.Bifunctor hiding (identityˡ; identityʳ; assoc) renaming (id to idF; _≡_ to _≡F_; _∘_ to _∘F_)
open import Category.NaturalIsomorphism
open import Category.NaturalTransformation using (_∘₀_; _∘₁_; _∘ˡ_; _∘ʳ_; NaturalTransformation) renaming (_≡_ to _≡ⁿ_; id to idⁿ)
open import Category.Functor.Constant

module MonoidalHelperFunctors {o ℓ e} (C : Category o ℓ e) (⊗ : Bifunctor C C C) (id : Category.Obj C) where
  private module C = Category.Category C
  open C hiding (id; identityˡ; identityʳ)

  private module ⊗ = Functor ⊗ renaming (F₀ to ⊗₀; F₁ to ⊗₁; F-resp-≡ to ⊗-resp-≡)
  open ⊗

  open MonoidalHelperBuilders C ⊗ id

  open import Category.Product

  id⊗x : Endofunctor C
  id⊗x = ⊗ ∘F (Constant {D = C} id {C = C} ※ id₁) 
  {-
  id⊗x = record 
    { F₀ = λ x → ⊗₀ (id , x)
    ; F₁ = λ f → ⊗₁ (C.id , f)
    ; identity = identity
    ; homomorphism = λ {_} {_} {_} {f} {g} → homomorphism′ {f = f} {g}
    ; F-resp-≡ = λ {_} {_} {f} {g} → F-resp-≡′ {F = f} {g}
    }
    where
    .homomorphism′ : ∀ {A B C} {f : Hom A B} {g : Hom B C} 
                  → ⊗₁ (C.id , g ∘ f) ≡ ⊗₁ (C.id , g) ∘ ⊗₁ (C.id , f)
    homomorphism′ {f = f} {g} = 
        begin
          ⊗₁ (C.id , g ∘ f)
        ≈⟨ ⊗-resp-≡ (sym C.identityˡ , IsEquivalence.refl C.equiv) ⟩
          ⊗₁ (C.id ∘ C.id , g ∘ f)
        ≈⟨ ⊗.homomorphism ⟩
          ⊗₁ (C.id , g) ∘ ⊗₁ (C.id , f)
        ∎
      where
      open IsEquivalence C.equiv hiding (refl)
      open SetoidReasoning hom-setoid
    .F-resp-≡′ : ∀ {A B} → {F G : Hom A B} → F ≡ G → ⊗₁ (C.id , F) ≡ ⊗₁ (C.id , G)
    F-resp-≡′ {F = F} {G} F≡G = 
        begin 
          ⊗₁ (C.id , F)
        ≈⟨ ⊗-resp-≡ ((C-refl , F≡G)) ⟩
          ⊗₁ (C.id , G)
        ∎
      where
      open IsEquivalence C.equiv renaming (refl to C-refl)
      open SetoidReasoning hom-setoid
  -}

  x⊗id : Endofunctor C
  x⊗id = ⊗ ∘F (id₁ ※ Constant {D = C} id {C = C})

  {-
  x⊗id = record 
    { F₀ = λ x → ⊗₀ (x , id)
    ; F₁ = λ f → ⊗₁ (f , C.id)
    ; identity = identity
    ; homomorphism = λ {_} {_} {_} {f} {g} → homomorphism′ {f = f} {g}
    ; F-resp-≡ = λ {_} {_} {f} {g} → F-resp-≡′ {F = f} {g}
    }
    where
    .homomorphism′ : ∀ {A B C} {f : Hom A B} {g : Hom B C} 
                  → ⊗₁ (g ∘ f , C.id) ≡ ⊗₁ (g , C.id) ∘ ⊗₁ (f , C.id)
    homomorphism′ {f = f} {g} = 
        begin
          ⊗₁ (g ∘ f , C.id)
        ≈⟨ ⊗-resp-≡ (IsEquivalence.refl C.equiv , sym C.identityˡ) ⟩
          ⊗₁ (g ∘ f , C.id ∘ C.id)
        ≈⟨ ⊗.homomorphism ⟩
          ⊗₁ (g , C.id) ∘ ⊗₁ (f , C.id)
        ∎
      where
      open IsEquivalence C.equiv hiding (refl)
      open SetoidReasoning hom-setoid
    .F-resp-≡′ : ∀ {A B} → {F G : Hom A B} → F ≡ G → ⊗₁ (F , C.id) ≡ ⊗₁ (G , C.id)
    F-resp-≡′ {F = F} {G} F≡G = 
        begin 
          ⊗₁ (F , C.id)
        ≈⟨ ⊗-resp-≡ (F≡G , C-refl) ⟩
          ⊗₁ (G , C.id)
        ∎
      where
      open IsEquivalence C.equiv renaming (refl to C-refl)
      open SetoidReasoning hom-setoid
  -}

  [x⊗y]⊗z : Triendo
  [x⊗y]⊗z = ⊗ ⟨⊗⟩ id₁

  x⊗[y⊗z] : Triendo 
  x⊗[y⊗z] = (id₁ ⟨⊗⟩ ⊗) ∘F preassoc C C C

  [x⊗id]⊗y : Bifunctor C C C
  [x⊗id]⊗y = x⊗id ⟨⊗⟩ id₁

  x⊗[id⊗y] : Bifunctor C C C
  x⊗[id⊗y] = id₁ ⟨⊗⟩ id⊗x

  [[x⊗y]⊗z]⊗w : Tetraendo
  [[x⊗y]⊗z]⊗w = [x⊗y]⊗z ⟨⊗⟩ id₁
  
  [x⊗y]⊗[z⊗w] : Tetraendo
  [x⊗y]⊗[z⊗w] = (⊗ ⟨⊗⟩ ⊗) ∘F preassoc (Product C C) C C

  x⊗[y⊗[z⊗w]] : Tetraendo
  x⊗[y⊗[z⊗w]] = (id₁ ⟨⊗⟩ (id₁ ⟨⊗⟩ ⊗)) ∘F preassoc C C (Product C C) ∘F preassoc (Product C C) C C

  x⊗[[y⊗z]⊗w] : Tetraendo
  x⊗[[y⊗z]⊗w] = (id₁ ⟨⊗⟩ [x⊗y]⊗z) 
                  ∘F preassoc C (Product C C) C 
                  ∘F (preassoc C C C ⁂ id₁)

  [x⊗[y⊗z]]⊗w : Tetraendo
  [x⊗[y⊗z]]⊗w = x⊗[y⊗z] ⟨⊗⟩ id₁

  module Coherence (identityˡ : NaturalIsomorphism id⊗x idF)
                   (identityʳ : NaturalIsomorphism x⊗id idF)
                   (assoc : NaturalIsomorphism [x⊗y]⊗z x⊗[y⊗z]) where
    open NaturalIsomorphism identityˡ using () renaming (F⇒G to υˡ)
    open NaturalIsomorphism identityʳ using () renaming (F⇒G to υʳ)
    open NaturalIsomorphism assoc using () renaming (F⇒G to α)

    TriangleLeftSide : NaturalTransformation [x⊗id]⊗y ⊗
    TriangleLeftSide = υʳ ⟨⊗⟩ⁿ id₂

    TriangleTopSide : NaturalTransformation [x⊗id]⊗y x⊗[id⊗y]
    TriangleTopSide = α ∘ʳ ((id₁ ※ Constant {D = C} id {C = C}) ⁂ id₁)

    TriangleRightSide : NaturalTransformation x⊗[id⊗y] ⊗
    TriangleRightSide = id₂ ⟨⊗⟩ⁿ υˡ

    α-over : {C₁ C₂ C₃ : Category o ℓ e} (F₁ : FunctorToC C₁) (F₂ : FunctorToC C₂) (F₃ : FunctorToC C₃) → NaturalTransformation ((F₁ ⟨⊗⟩ F₂) ⟨⊗⟩ F₃) ((F₁ ⟨⊗⟩ (F₂ ⟨⊗⟩ F₃)) ∘F preassoc C₁ C₂ C₃)
    α-over F₁ F₂ F₃ = α ∘ʳ ((F₁ ⁂ F₂) ⁂ F₃)

    PentagonNWSide : NaturalTransformation [[x⊗y]⊗z]⊗w [x⊗y]⊗[z⊗w]
    PentagonNWSide = α-over ⊗ id₁ id₁

    PentagonNESide : NaturalTransformation [x⊗y]⊗[z⊗w] x⊗[y⊗[z⊗w]]
    PentagonNESide = α-over id₁ id₁ ⊗  ∘ʳ  preassoc (Product C C) C C

    PentagonSWSide : NaturalTransformation [[x⊗y]⊗z]⊗w [x⊗[y⊗z]]⊗w
    PentagonSWSide = α ⟨⊗⟩ⁿ id₂

    PentagonSSide : NaturalTransformation [x⊗[y⊗z]]⊗w x⊗[[y⊗z]⊗w]
    PentagonSSide = α ∘ʳ (((id₁ ⁂ ⊗) ∘F preassoc C C C) ⁂ id₁)

    PentagonSESide : NaturalTransformation x⊗[[y⊗z]⊗w] x⊗[y⊗[z⊗w]]
    PentagonSESide = (id₂ ⟨⊗⟩ⁿ α) ∘ʳ (preassoc C (Product C C) C ∘F (preassoc C C C ⁂ id₁))
