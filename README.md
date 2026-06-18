# cLogos

```
                  /
          \     _________________
    ___    \   /   _   ___   _   \    ___
   /   \   /\ |     | /   \ |     |  /   \
  |       /  \ \___/ |     | \___/  |
   \_____/    \_______\___/          \___
                       \__               \
                       /  \            __/
                      |    |
                       \__/
```

## The Common (Lisp) Logo Setup cLogos
 
Version 0.0.2 (11 June 2026 -- 18 June 2026)
 
*cLogos* is a faithful, living implementation of
[**Berkeley Logo**](https://github.com/jrincayc/ucblogo-code), written in
[**Common Lisp**](https://common-lisp.net/) as the host language. 
Current development targets [**SBCL**](https://www.sbcl.org/).

cLogos is not a Logo-*inspired* language, nor a Lisp DSL with Logo syntax.
Berkeley Logo as described in its 
[Berkeley Logo Reference
Manual](https://people.eecs.berkeley.edu/~bh/v2ch14/manual.html) 
is its **normative core**.

---

## Why cLogos?

Logo already exists — so why build another implementation?

**Because Logo is not merely a language.**
It is a *way of thinking*, and that way of thinking deserves implementations
that are both faithful and alive.

**Berkeley Logo** exists precisely in this role:
a running, stable, minimal implementation that preserves the canonical Logo
language core with exceptional clarity and focus on powerful ideas in computer
science education. Its restraint is a feature, not a limitation.

cLogos does not seek to replace Berkeley Logo, nor to "improve" it.
Instead, cLogos exists to **preserve *and extend*** Logo’s original strengths
*without disturbing its core*.

In particular, cLogos aims to support Logo’s parallel modes of thinking:

- treating **textual Logo** as a first-class medium for rigorous symbolic reasoning,
- treating **turtle geometry** as a concrete, spatial embodiment of those same ideas,
- and treating **visual and syntactic forms** as alternative representations of a
  shared underlying semantics.

Text, motion, and symbol are not stages to outgrow — they are 
*coexisting modes of thought*. 

cLogos does **not** aim to make programming easier.
It aims to make **structural thinking expressible** at the level at which it is
already being formed in the learner’s mind.

---

## Design commitments

cLogos is governed by an explicit design charter (**The cLogos Charter**), which
defines what the system *is* — and what it is *not*. 

In summary:

- **Berkeley Logo compatibility is definitional.**
  If Berkeley Logo does something, cLogos must do it the same way — or document
  the difference explicitly. 

- **Textbooks are specifications.**
  Canonical works by 
  - [*Brian Harvey (1985/1997)*](https://people.eecs.berkeley.edu/~bh/v1-toc2.html), 
  - [*Cynthia Solomon, Margaret Minsky and Brian Harvey
  eds. (1986)*](https://logothings.github.io/logothings/logoworks/Home.html), 
  - [*Seymour Papert
  (1980)*](https://worrydream.com/refs/Papert_1980_-_Mindstorms,_1st_ed.pdf), 
  - and [*Harold Abelson and Andrea diSessa
  (1980)*](https://direct.mit.edu/books/oa-monograph/4663/Turtle-GeometryThe-Computer-as-a-Medium-for) 
  must *run*, not merely "mostly work".

- **Power is introduced without hiding mechanisms.**
  Extensions are local, explicit, and pedagogically motivated.

- **Logo remains the unit of explanation.**
  New features must be explainable *in Logo terms*, not imported abstractions.

The Charter is not aspirational documentation; it is a **binding specification**.

---

## About the name

The name *cLogos* reflects both lineage and intent.

- **“c”** stands for *common*.
- **“L”** refers to the Greek lambda (Λ, λ), visually echoing two *l*s and
  symbolizing both *Lisp* and *Logo*. 
- **“s”** stands for *setup* — historically, though cLogos is no longer
  conceived as a mere embedding or façade. 

The name also points to the ancient Greek **Λόγος (Lógos)** — commonly
translated as *"word"*, but carrying broader philosophical meanings tied to 
reasoning, structure, and expression. These meanings resonate deeply with Logo's
original goals. 

For historical background see: 
- [*Wallace Feurzeig (1984)*](https://www.atariarchives.org/deli/logo.php))
- [*Brian Harvey
  (1985/1997)*](https://people.eecs.berkeley.edu/~bh/pdf/v1ch01.pdf), p. 1
- [*Wallace Feurzeig (2010)*](https://link.springer.com/article/10.1007/s10758-010-9168-4)
- [*Wallace Feurzeig (2011)*](https://www.walden-family.com/waterside/bbn-print2.pdf), p. 291
- [*Cynthia Solomon et. al. (2020)*](https://dl.acm.org/doi/10.1145/3386329), p. 20-22

---

## From Lisp assumptions to Logo integrity

cLogos began with the mistaken assumption that *Logo is essentially a Lisp*.
Early experimentation under that assumption made the truth clear:

Logo and Lisp are **close siblings**, but they are **not the same language**,
and they embody different pedagogical commitments. 

As a result, cLogos deliberately moved away from "Logo as Lisp wear" toward a
cleaner, Logo-centered design. That shift is formalized in the Charter and
guides all current and future development. 

So, cLogos is not a new language.
It is a deliberately designed crossing between two cognitive registers of
programming and mathematics:

- Procedural / temporal / narrative
- Algebraic / relational / atemporal

Lisp demonstrated that such a crossing is possible.
Logo demonstrated that this bridge can be stabilised for learners.
cLogos is designed to keep the crossing open, inspectable, and reversible.

For conceptual background see:
- [Heller, Joachim (2026)](https://doi.org/10.13140/RG.2.2.28632.46087)
- [Heller, Joachim (2025)](https://doi.org/10.18452/36740)

For further historical background see:
- [Logo Memo 11a/A.I. Memo 307a (1975)](https://dspace.mit.edu/entities/publication/e872965e-f6e2-423c-885e-33163c9d3d63)
- [LLOGOS MACLISP source](https://github.com/PDP-10/its/tree/master/src/llogo)

---

## Project scope

cLogos is intended to become a **real Logo implementation**, not a simulation
and not a DSL. 

It treats Logo as:

- Turing-complete
- high-level
- general-purpose
- and uniquely suited to learning in literacy, mathematics, and structural reasoning.

Future directions may explore bridges to other symbolic systems, but **only**
where such extensions augment Logo-based thinking rather than replace it. 

---

*For the full set of governing principles, see:*
[**The cLogos Charter**](clogos-charter.markdown)

## Usage

⚠️ **Status notice**
cLogos is under active development and is **not yet a complete Logo system**.
At this stage it primarily targets curious tinkerers who want to explore:

- Logo as a language and a way of thinking,
- Common Lisp as an implementation medium,
- and the design of pedagogically honest programming systems.

It is already usable for **experiments, inspection, and learning**, but not yet
for classroom deployment.

---

### Prerequisites

A working **Common Lisp** environment is required.

The recommended setup is:

- **SBCL**
- [**Emacs**](https://www.gnu.org/software/emacs/) with 
  [**SLIME**](https://slime.common-lisp.dev/)
- [**Quicklisp**](https://www.quicklisp.org/beta/) 

This combination provides a transparent and inspectable development environment,
well aligned with cLogos’ goals.

---

### Getting started quickly

For a low-threshold, platform-independent jump start, see the small companion
project:

[**Portaclish**](https://github.com/Lispl-Wicht/Portaclish)

Portaclish aims to get the recommended IDE running with minimal setup effort.
It is intended for confident beginners and tinkerers rather than complete novices.

---

### Installing and loading cLogos

Clone the cLogos repository into Quicklisp’s canonical directory:

```text
~/quicklisp/local-projects/
```
With Emacs and SLIME running, first load the external dependencies explicitly 
(if they are not already installed): 
```common-lisp
CL-USER> (ql:quickload '(str parse-number))
```
Then load cLogos via ASDF:
```common-lisp
CL-USER> (asdf:load-system :c-logo-s)
```
> Although ```c-logo-s``` could also be loaded directly via ```ql:quickload```,
> this project deliberately uses ```asdf:load-system```.
>
> During development, calling ASDF directly is less forgiving than going
> through Quicklisp’s convenience layer. Missing or misdeclared dependencies
> surface immediately, which helps keep the system definition explicit and
> honest.
>
> ```ql:quickload``` is only required to *install* missing dependencies.
> Once the required libraries (`str` and `parse-number`) are present,
> `asdf:load-system` loads them automatically as declared dependencies.

Enter the core Logo package:
```common-lisp
CL-USER> (in-package #:logo)
LOGO>
```
---

#### Tooling philosophy made more explicit

> cLogos distinguishes between **system definition** and **environmental convenience**, 
> in alignment with its broader commitment to explicit, inspectable structure.
>
> The project uses ```asdf:load-system``` as the primary mechanism for loading systems 
> during development, because ASDF makes dependency structure visible at the point of 
> definition. This supports the cLogos principle that mechanisms should remain 
> **locally readable, non-concealed, and pedagogically transparent**, allowing missing 
> or underspecified dependencies to surface immediately rather than being implicitly 
> resolved.
>
> Quicklisp (```ql:quickload```) is treated as a **distribution and acquisition layer**, 
> not as a substitute for system definition. It provides a convenient mechanism for 
> installing external libraries and managing curated releases, but it introduces an 
> additional layer of environmental mediation that can reduce visibility of incomplete 
> or implicit system specifications in evolving or experimental development contexts.
>
> In accordance with the cLogos Charter, tooling is chosen not for maximal convenience, 
> but for structural honesty, explicit dependency representation, and preservation of 
> inspectable computational processes. Quicklisp is therefore used for setup and dependency 
> acquisition, while ASDF remains the authoritative mechanism for system loading and 
> development-time structure.

---

### Inspecting Logo from Common Lisp

A fundamental design choice of cLogos is inspectability.
Logo data and procedures are represented explicitly and can be examined directly
from Common Lisp.

**Examples:**

```common-lisp
LOGO> (word (logo-wd "hell") (logo-wd "o"))
#S(WD :STR "hello" :NMB NIL :SYM NIL :FLAGS NIL)
```

```common-lisp
LOGO> (lookup-procedure "sum")
#S(PROC
   :NAME "sum"
   :PACKAGE LOGO
   :IMPLEMENTATION #<FUNCTION SUM>
   :DEFAULT-ARITY 2
   :OPTIONAL-ARITY -1
   :VISIBILITY :PUBLIC)
```

Custom Logo data types are implemented as **structures**, not CLOS classes.
This is a deliberate choice: the **Common Lisp Object System (CLOS)** is *not* 
projected wholesale into Logo’s object model.

---

### Current focus: the reader and parser pipeline

The current development focus is the **Logo reader and parser.**

Its first transformation step resolves the *line continuator* ```~```:
```common-lisp
LOGO> (continue-lines "to foo :bar :baz
  repeat 4 ~
   print sum :bar ~
             :baz
end")
```
Result:
```common-lisp
"to foo :bar :baz
  repeat 4    print sum :bar              :baz
end"
```
This prepares an intermediate representation that is gradually transformed into
an evaluable Logo line.

The current pipeline (still incomplete) looks like this:
```common-lisp
(replace-first-order-proc-words-in-document   ;        ^
 (replace-infix-in-document                   ;        |
  (minus-sanity-check-in-document             ;        |
   (decontract-infix-words-in-document        ;        |
    (flag-lexical-bindings-in-document        ;        |
     (flag-scope-introducer-in-document       ;        |
      (verbalize-document                     ;        |
       (normalize-minus-in-tree               ;        |
        (check-structural-balance             ;        |
         (repair-bars                         ;        |
          (tokenize-segments                  ;        |
           (number-lines                      ;        |
            (preserve-comments                ;        |
             (construct-lines                 ;        |
              (continue-lines "...")))))))    ;        _
```
**surface normalisation:**
- ```continue-lines```
- ```construct-lines```
- ```preserve-comments```
- ```number-lines```
  
**lexical analysis:**
- ```tokenize-segments```
- ```repair-bars```
  
**structural analysis:**
- ```check-structural-balance```
  
**syntactic refinement:**
- ```normalize-minus-in-tree```
- ```verbalize-lines```
- ```flag-scope-introducer-in-document``` (Charter Sec. 4)
- ```flag-lexical-bindings-in-document``` (Charter Sec. 4)
- ```minus-sanity-check-in-document```
- ```decontract-infix-words-in-document```
  
**semantic binding:**
- ```replace-infix-in-document```
- ```replace-first-order-proc-words-in-document```

Issues are documented here on [Github](https://github.com/Lispl-Wicht/c-logo-s/issues); 
they are part of the current work.

The current phase of development is marked as **[CURRENT]** in the [roadmap](phases.markdown).

---

### What cLogos is good for *right now*

- inspecting cLogos' internal representations,
- experimenting with reader and parser design,
- studying Logo and Lisp side by side,
- thinking about pedagogy, language design, and semantics.

---

### Learning Common Lisp

For readers new to Common Lisp, two books are especially recommended:

- [*Practical Common Lisp*](https://gigamonkeys.com/book/) — Peter Seibel;
  pragmatic, thorough, and widely regarded as the standard entry point.
- [*Land of Lisp*](http://landoflisp.com/) — Conrad Barski;
  playful, motivating, and conceptually solid.
  
Both pair well with cLogos’ exploratory nature.

## A sketch of a Lisp/cLogos logo

This could look nice as an SVG in red:

![Logo](Lisp-clogos.jpg)

Inspired by this classic Lisp emblem:

![Lisp](conceptual-work/Lisp-emblem.png)

# License

This educational project is licensed under the GNU General Public License v3.0 (GPL-3.0).

In short, this means:

- You are free to use, study, modify, and redistribute this software.
- Any modified or derived works must also be licensed under GPL-3.0.
- The source code must remain open and available when the software is distributed.
- The software is provided without warranty.

See the [LICENSE file](LICENSE) for the full license text.
