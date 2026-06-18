# The cLogos Charter
*registered: 4 June 2026, Berlin, Germany*

## Mission Statement

**cLogos** is a faithful, living implementation of **Berkeley Logo** designed to 
preserve Logo’s pedagogical depth while extending its expressive power for
contemporary learners and systems. 

Its mission is to support **thinking with symbols, structures, and actions** --
whether those actions move a turtle, transform a word, reshape a list, or
construct a visual form:

cLogos:

- treats **textual Logo** as a first-class medium for rigorous symbolic reasoning,
- treats **turtle geometry** as one concrete, spatial embodiment of those same
  ideas,
- and treats **visual-syntactic forms** as alternative representations of a
  shared underlying semantics.
  
Text, motion, and symbol are not stages to outgrow; they are parallel ways of
thinking.

cLogos honors Logo as a way of thinking, not merely as a language:

- textbooks are specifications, not examples, 
- extensions are explicit, local, and pedagogically motivated,
- and power is introduced without concealing mechanism.

cLogos exists to let people think **clearly, honestly, and joyfully**
-- with symbols, with turtles, and beyond. 

cLogos is not trying to make programming easier; it is trying to make structural
thinking expressible at the level at which it is already being formed in the
learner’s mind.

## 1. Core identity

- **Berkeley Logo is the normative core.**
- Full behavioural compatibility is not optional — it is *definitional*.
- If Berkeley does it, cLogos **must** do it *the same way*, or document the
  difference explicitly.

## 2. Canonical pedagogy

*Textbooks are not “examples”; they are specifications.*

- **Primary canon:**
  *Harvey*, *Computer Science Logo Style*, Vol. 1–3
  → must run categorically, not approximately.

- **Secondary canon:**
  *Solomon, Minsky, Harvey*, *LogoWorks*
  → challenging programs must translate without conceptual distortion.

- **Tertiary canon:**
  *Papert*, *Mindstorms*
  *Abelson & di Sessa*, *Turtle Geometry*
  - These works must be followed without friction, and with minimal concessions
    *only* when coherence demands it.
  - cLogos’ help system explicitly guides users when names diverge.

## 3. Object model: prototype-based, Berkeley-style

- CLOS or class hierarchies are **not** imported into Logo.
- cLogos preserves:
  - late binding
  - exemplar objects
  - learner-accessible object reasoning

## 4. Lexical scope is a *line-based extension*, not a replacement

```logo
with [[x 10] [y 20]] ~
  [print :x + :y]
```

This reads as
> "Evaluate this block *with* these bindings."

The *line continuator* ```~``` provides compound and nested statements within
one Logo line.

- Dynamic scope remains intact.
- Lexical scope is introduced **locally, explicitly, and visually**.
- ```with``` is an *extension*, not a correction.
- cLogos preserves:
  - backward compatibility
  - Logo's exploratory feel
  - pedagogical honesty
- cLogos bridges:
  - lambda
  - closures
  - functional abstraction
  
## 5. Turtle Talk: Berkeley + Atari

- Turtle Talk stays canonical.
- The multimedia capabilities of Atari Logo, as utilised in *LogoWorks*, form
  the reference core for the *organic* growth of cLogo's audiovisual and motoric
  system.
  
## 6. Visual-syntactic programming

- cLogos provides a visual-syntactic programming interface that is *also line-based*.
  → Graphical items representing commands, operations, and their inputs are
  connected horizontally.

- cLogos allows non-verbal symbolic programming, inspired by Matatalab, using its
  own *glyphs* for operations and commands.

- cLogos also supports a mixed model of visual–syntactic symbolic programming,
  inspired by Snap!.

## 7. Extension disciplin

*Logo is a medium for thinking, and cLogos must preserve the conditions under
which that thinking remains valid.* 

The essential cLogos consists of:

- **Logo core** → procedural and pedagogical action system (normative base)
- **Turtle layer** → spatial execution and motion trace

cLogos may suggest directions that extend beyond the Logo core toward
multi-regime symbolic computation. These directions are exploratory only and
have no implementation authority. 

Possible future directions include:

- **CL bridge** (cl:) → general symbolic computation via Common Lisp
- **Math layer** (math:) → symbolic transformation and constraint reasoning
- **Geometric layer** → constraint-based visualisation and dependency-driven structure

These directions are not part of the current system specification.

Any extension must satisfy the following constraints:

- It must preserve Berkeley Logo semantics unless explicitly documented otherwise.
- It must preserve pedagogical transparency and avoid hidden evaluation rules.
- It must not introduce representational opacity that cannot be explained in Logo terms.
- It must remain compatible with reasoning in the Logo core.

--------------------------------------------------------------------------------

**Governance principle:**

Extensions are only admissible if they function as an augmentation of Logo-based
thinking, not as a replacement of it.

--------------------------------------------------------------------------------
