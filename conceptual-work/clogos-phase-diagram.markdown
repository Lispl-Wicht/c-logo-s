# The core idea: cLogos is a stratified system

cLogos is a **stack of transformations**, each with a strict responsibility:

> meaning flows downward, representation flows upward

**Invariant!**
> Nothing is allowed to "reach backward" into a previous phase. 
> -> Forward flow only.

TEXT
  ↓
PARSING (syntax + infix + structure)
  ↓
LOGO EVALUATION (objects, procedures, runtime)
  ↓
VALUE SPACE (wd, list, array, object)
  ↓
VALUE → RNODE (semantic normalization)
  ↓
RENDERING (context-sensitive presentation)
  ↓
OUTPUT TEXT

Each layer corresponds to a *cognitive register*

| Phase      | Cognitive mode            |
|------------|---------------------------|
| Syntax     | symbolic manipulation     |
| Evaluation | procedural thinking       |
| RNODE      | structural reflection     |
| Rendering  | perceptual interpretation |

# Canonical Pipeline

## Phase 0 -- Textual input (surface syntax)

```logo
with   [x 10  ~
        y 20] ~
    print   sum :x ~
                product  :x      :y
```

**Responsibility:**
- raw character stream
- infix + prefix mix
- indentation optional (editor help only)

**Output:**
-> parse tree (syntax structure)

## Phase 1 -- Parse structure (syntactic form)

**Responsibility:**
resolving 
- line continuations (```~```),
- infix expansion (via tables + weights),
- grouping,
- ```with``` blocks,
- procedure calls

**Output**
-> AST (Abstract Syntax Tree)

important:
- still *not meaning*
- just structured instructions


## Phase 2 -- Semantic resolution (Logo world)

**Berkeley Logo core layer -- Responsibility:**
- object resolution
- procedure lookup
- variable binding
- ```ask```, ```talkto```, ```self```
- inheritance (```kindof```, ```oneof```)

**Output:**
-> evaluated values in Logo domain

Examples:
- words
- logo-lists
- logo-arrays
- logo-objects (dynamic)
-> execution reality

## Phase 3 -- Normalisation layer (cLogos bridge)

```value -> rnode```

**Responsibility:**
Convert **semantic Logo values** into:
- a uniform representation tree
- independent runtime behaviour

**Output:**
-> RNODE tree

**Invariants!!**
> RNODEs are snapshots, not live objects!
  They answer:
> "What is this thing as structure?"
  not:
> "What can it do?"

## Phase 4 -- Presentation layer (rendering)

This is
> ```render-node```

**Responsibility:**
- convert RNODE -> string
- apply print-context
- apply list/array style rules
- apply separator rules

**Output:**
-> final textual output

## Phase 5 -- IO / user-facing system

Including:
- ```show```
- ```print```
- REPL output
- future GUI / turtle / visual syntax.

It is the only layer that touches the outside world.

# Phase mapping

## ```with```
> Phase 1 (syntax) + Phase 2 (semantic binding)

## infix + weight tables
> Phase 1 only

## ```*workspace-infix-table*```
> Phase 1 (parser configuration only)

## Berkeley Logo object system
> Phase 2 only (runtime semantics)

## rnode system
> Phase 3 (bridge layer)

## show/print
> Phase 4 + 5

# Invariants:

## Law 1 -- No upward semantic leakage

- RNODE must *not* influence evaluation
- rendering must *not* trigger computation

## Law 2 -- Evaluation does not know about presentation

Berkeley layer must be blind to:
- indentation
- infix formatting
- print context
- visual context

## Law 3 -- RNODE is a frozen snapshot

- no object mutation inside RNODE
- no "live references" that change meaning during render

## Law 4 -- Infix is purely syntactic sugar

- resolved before evaluation
- never visible to Logo runtime

## Law 5 -- Context only affects rendering

- ```print-context``` only lives in Phase 4
- never earlier


