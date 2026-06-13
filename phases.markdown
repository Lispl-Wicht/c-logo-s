# Phases of implementing the Logo core

## Phase 1 [CURRENT]

**Lexing, parsing, evaluation of:**

- words
- lists
- procedures
- basic primitives

## Phase 2

**Logo variable system**

- ```make```
- NAME lookup rules
- procedure locals
- workspace variables
- dynamic scope 
- line-bounded lexical scope through ```with``` extension

## Phase 3

**[BLOS](conceptual-work/blos.markdown) (on top of a stable variable system)**

- objects as environments
- ```ask``` / ```talkto```
- ```have``` / ```havemake```
- inheritance lookup
- ```usual```

## Phase 4

**Completing the core** 
