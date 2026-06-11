# Logo variables

> Logo variables are not bindings but mutable places stored in dynamic frames
> and object environments; Common Lisp provides the host machinery, but the
> semantics must be implemented explicitly. 
> 
> Bindings are promises that a value will exist where the binding name is used.
> They will be implemented in line-based lexical environments introduced by
> ```with```.

**Logo**
- variables = places
- procedures = transformations
- objects = environments

**Common Lisp implementation**
- frames = alists
- objects = structs
- lookup = explicit algorithm

This preserves:
- Logo’s *thinking model*
- Lisp’s *implementation strength*
- pedagogical transparency

## The three variable strata in Logo

Logo variables live in **three distinct layers**:

### Procedure-local variables

Introduced by:
- procedure inputs (```:foo```)
- ```local```/```localmake```

Properties:
- dynamically scoped
- shadow outer variables
- lifetime = procedure activation

### Object variables (workspace variables)

Introduced by:
- ```make```
- ```havemake``` (in objects)

Properties:
- stored in the **current object**
- persist beyond procedure calls
- inherited via BLOS parent chain

### Global variables

Global variables are the object variables of ```logo```.
-> "Global" just means "owned by ```logo```".

## Dynamic scope: what cLogos *actually* does

cLogos variable lookup is **environment chaining plus dynamic frames***:
1. check **procedure-local dynamic environment**
2. check **current object variables**
3. check **parent objects**
4. ultimately check ```logo```.

### Variable lookup algorithm (precise)

When evaluating :x:

1. walk *logo-dynamic-frames* (top → bottom)
2. if found → return value
3. else check (current-object.variables)
4. else walk parent objects (left to right)
5. else error

## Common Lisp model

> Logo variables are data, not Lisp bindings, so 
> Logo variable lookup must be implemented manually.

### Dynamic procedure frame stack

```Common-Lisp
(defvar *logo-dynamic-frames* '())
```

Each frame is:
```Common-Lisp
((name . value) ...)
```

On procedure entry:
- push frame
On exit:
- pop frame

### Object variable tables

Each object including ```logo``` has:
```
variables : hash-table (name -> value)
```
inherited via BLOS parent chain.

### ```local```

```Logo
local "x
make "x 10
```

Meaning:
- introduce a *new dynamic* slot
- shadow outer ```x```
- lifetime = current procedure

Implementation:
```Common-Lisp
(push-frame (list (cons 'x *unassigned*)))
```

```make``` then mutates that slot.

## Invariants

*Logo is a medium for thinking.*
Variables are places where that thinking can settle, change, and be observed.

> **Major Principle**
> Variables in Logo are not conveniences for the machine. They are cognitive
> anchors for the learner. 
> Any implementation choice that weakens this role is invalid.

### 1. Variables are places, not bindings

- A Logo variable denotes a mutable place associated with a name.
- Variables are not lexical bindings and not immutable values. 
- Assignment (```make```, ```localmake```, ```havemake```) changes the content
  of a place, not the structure of an expression.

**Invariant:**
No variable operation may rely on lexical binding semantics.

### 2. Variable names are symbolic data

- Variable names are Logo words.
- Variable lookup is performed by symbolic name, not by host-language
  identifiers. 
- Variable existence is discoverable and inspectable.

**Invariant:**
Variables must not be compiled into or hidden behind host-language bindings.

### 3. Dynamic scope is normative

- Variable resolution is **dynamic**, not lexical.
- The active variable environment is determined by the runtime call context.
- Later calls may affect earlier variable meanings.

**Invariant:**
Any form of lexical scoping must be introduced explicitly and locally
(e.g. ```with```) and must not replace dynamic scope. 

### 4. Three variable strata exist and are distinct

Logo variables exist in exactly three conceptual strata:

1. **Procedure-local variables**
   - Introduced by procedure inputs, local, localmake
   - Lifetime: procedure activation
   - Highest lookup priority
2. **Object variables**
   - Introduced by make, havemake
   - Owned by the current object
   - Persist beyond procedure calls
3. **Global variables**
   - Object variables of the root object logo
   - No special global mechanism exists

**Invariant:**
No variable may bypass these strata or collapse them.

### 5. Variable lookup order is fixed

Variable lookup proceeds strictly in this order:

1. Procedure-local dynamic frames (most recent first)
2. Current object variables
3. Parent object variables (left-to-right, depth-first)
4. Root object (logo)

**Invariant:**
This order is not configurable and must be preserved exactly.

### 6. Assignment respects existing places

- ```make``` modifies the nearest accessible variable place.
- ```localmake``` always creates or modifies a procedure-local place.
- ```havemake``` always creates or modifies an object-local place.

**Invariant:**
Assignment must never silently create variables in unintended strata.

### 7. Variable shadowing is allowed and visible

- Inner variables may shadow outer ones.
- Shadowing is temporary and context-bound.
- The system must support querying ownership (whosename).

**Invariant:**
Shadowing must be transparent and introspectable.

### 8. Variable ownership is semantic, not syntactic

- Every variable place has an owner:
  - a procedure frame, or
  - an object
- Ownership determines lifetime, visibility, and mutation rights.

**Invariant:**
Variable ownership must be representable and queryable at runtime.

### 9. Variables are independent of evaluation regime

- Variable semantics are identical in:
  - primitive procedures
  - user procedures
  - object methods
  - turtle commands
- No evaluation context may introduce special variable rules.

**Invariant:**
Variables behave the same across all execution contexts.

### 10. Error behaviour is explicit

- Referencing an inaccessible variable is an error.
- Silent fallbacks or implicit defaults are not permitted.
- Errors must report which name and why it failed.

**Invariant:**
Variable errors must be pedagogically informative.

### 11. Compatibility with Berkeley Logo is mandatory

- All Berkeley Logo variable behaviour must be reproducible.
- Any deviation must be:
  - explicitly documented
  - pedagogically justified

**Invariant:**
If Berkeley Logo accepts a variable program, cLogos must accept it with
identical meaning. 

### 12. Host-language isolation

- The host language (Common Lisp) must not leak:
  - bindings
  - scoping rules
  - mutation semantics
- The host language is an implementation detail.

**Invariant:**
Logo variables must remain Logo variables, conceptually and observably.
