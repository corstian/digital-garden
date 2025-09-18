---
title: "Monads"
date: 2025-08-10
---

[Wikipedia](https://en.wikipedia.org/wiki/Monad_(functional_programming)) describes a monad as being a type constructor [^1] having two operations:

- `return : <A>(a : A) -> M(A)`  
    _A method accepting value a of `A`, returning a monad holding a value of type `A`._
- `bind : <A,B>(m_a : M(A), f : A -> M(B)) -> M(B)`  
    _Method accepting a monad of type `A` (this), and a function mapping a value of `A` to a monad of type `B`._


[^1]: [type constructor](https://en.wikipedia.org/wiki/Type_constructor) creates new types from old types
