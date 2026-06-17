# NSF -- Normalized Syntactic Form

## 1. What NSF is

> **NSF is the linear, fully disambiguated syntactic representation of a**
> **Logo program, immediately prior to structural (AST) construction.**

Or: **NFS** is the last representation of a cLogos program that still reflects
how the user wrote it, while already encoding how the reader understood it. 

It is:

- syntactic
- local
- disambiguated
- still linear
- still reversible in principle

NSF is the bridge between surface syntax and semantic structure.

## 2. What NSF is not

NSF is **not**:

- an AST
- executable
- grouped by precedence
- optimized
- canocicalized beyond local necessity

In particular:
> NSF **does not impose structure** -- it only removes ambiguity.

## 3. NSF position in the pipeline

The pipeline has a *natural stratification*:

```
Source text
  ↓
Tokens (with whitespace, comments, bars)
  ↓
Minus normalisation (local syntactic disambiguation)
  ↓
Infix word decontraction
  ↓
Minus sanity check
  ↓
INFIX replacement
  ↓
-----------------
NSF
-----------------
  ↓
Infix AST construction
  ↓
Procedure AST
  ↓
Compilation
```

This is the **semantic point of no return** -- and that is why NSF exists.

## 4. Core invariants of NSF

These invariants define the contract of the stage.

### 4.1 Linear order invariant

NSF preserves **token order**.

- No reordering
- No implicit grouping
- No tree structure

Everything is still a **flat sequence** inside lines.

### 4.2 Disambiguation invariant

All syntactic ambiguities that are resolvable *without semmantic knowledge*
**must already be resolved**.

This includes:

- unary vs infix ```-```
- adjacency-sensitive minus
- infix vs procedure words
- decontracted infix expressions (```4-3``` → ```4 - 3```)
- generated words are explicitly marked

After NSF:

> There is **no remaining syntactic ambiguity**.

### 4.3 Explicit operator invariant

Every operator is explicit and typed:

- Infix operators are ```#S(INFIX ...)```
- Unary operators are already ```#S(PROC ...)```
- Variables are ```WD``` with ```:THING``` flag
- No symbol ```"+"```, ```"-"```, etc. remains ambiguous

The reader never has to "guess" again.

### 4.4 Context locality invariant

All decisions made in NSF are:

- local
- context-bounded
- syntax-only

No evaluation, no arity reasoning, no procedure lookup.

Example:

```logo
sum :a - 4
```

remains unresolved semantically -- correctly.

### 4.5 Reconstructability invariant (weak)

From NSF, it is still possible to:

- pretty-print a faithful representation
- explain to the user how the input was read
- reason about spacing and style

But:

- exact original text reconstruction is not required, only nearly possible
- stylistic loss is acceptable

This is intentional.

## 5. NSF data model expectations

In NSF:

- Lines are still ```(:LINE ...)```
- Whitespace tokens may still exist
- Comments may still exist
- ```WD```, ```PROC```, ```INFIX``` delimiters are all explicit
- Flags like ```:thing``` or ```:quoted``` are meaningful

AST nodes **must not*** appear.

## 6. Relationship to ```GLOSS :SOURCE```

```GLOSS :SOURCE```

- Stores **final AST**
- Represents *what is executed*
- Canonical
- Stable

**NSF**

- Stored optionally (workspace / history /debugging)
- Represents *how input was understood*
- Pedagogical
- Inspectable
- Disposable


