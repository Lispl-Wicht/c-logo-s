# Representational Experiments (Non-Normative)

## Logo's infix operators (8 June 2026)

> Pedagogical potential:
>
> Letting learners *define* the mapping between
> *infix* as the symbolic-relational register, and
> *prefix* as the operational-discursive register,
> **conversion** (transformation of representations) is 
> supported, not just treatment (transformation of values).
>
> Prefix becomes
> - the canonical semantic form
> - the reference shown by the system
> - the hover explanation
> - the fallback rendering
>
> Infix becomes:
> - a convenience
> - a cultural bridge
> - a representational experiment



The infix operators 

- ```^``` for ```power```, 
- ```*```, ```×``` or ```⋅``` for ```product```, 
- ```/``` or ```÷``` for ```quotient```,
- ```+``` and ```-``` for ```sum``` and ```difference```,
- ```=``` for ```equalp```,
- ```<``` and ```>```  for ```lessp``` and ```greaterp```,
- ```<=``` or ```≤``` for ```lessequalp```, 
- ```>=```, ```≥```  for ```greaterequalp```,
- and ```←``` for ```make```

constitute an exception to Logo's regular prefix notation.

The arithmetical and relational operators connect with the conventional notation
used in mathematics class. 

The assignment operator ```←``` emphasises a physical L-value/R-value notion by
highlighting the assignment direction instead of suggesting equivalence of both
values with a ```=``` or a purely mathematical definition context with
```:=```. It provides an unequivocal use of the equal sign and connects with
formal CS notation, used e.g. by Donald Knuth.

However, infix operators in Logo are directives that are syntactic sugar over
procedures.  Logo's regular prefixed syntax lets instructions be read nearly as
natural language sentences. This is the priority. 

Infix operators introduce a relational perspective which is represented in a
highly condensed symbolised form and cannot be read as an action unfolding in
time. Therefore, the flow of reading is interrupted through the integration of a
different semiotic register in Duval's sense.

To justify the use of infix operators beyond the connection to conventional math
class customs and honour Logo's primary representation style at the same time,
the following extension is debatable:

Fostering the invention of own infix symbols to support creative experiences may
be possible in cLogos by making the representational shift explicit.

For this purpose the keywords ```infix```, ```weight``` and ```associativity```
are introduced, e.g.: 

```logo
to [my.sum.product infix "*+ weight 45 associativity left] :a :b
  output sum :a product :a :b
end
```

The concrete surface syntax shown here is illustrative, not normative. But this
corresponds with the underlying Common Lisp constructor:

```common-lisp
(define-infix :sign "^"
  :weight 100
  :associativity :right
  :procedure (lookup-procedure "power"))
```

This enables two possible calls:
```logo
print my.sum.product 4 5
print 4 ?: 5
```
The environment must make the presence of custom infix operators explicit and
explainable. Therefore the following constraints apply:
- infix must be declared *adjacent* to its definition
- the editor must show the underlying procedure on hover
- infix usage must be visually marked (colour / underline)
- infix cannot override existing primitives

Thus, custom infix operators must not appear *implicitly* in introductory
materials. Learners can *invent* symbols only 
**after they understand procedures**. 

Custom infix operators must rely on procedures that are diadic by default, and
their symbols must not consist of more than two Unicode characters.

**Primitive infix operators** can be modified according to their **weight** and
associativity with the commands:
```logo
set.infix.weight "+ 70
set.infix.assoc "* "right
```
This enables experiments with deviating precedence rules and conflict resolution
rules for the traditional operators. 

Modifications of the primitive infix operators and the introduction of custom
infix operators take place in the workspace (```*workspace-infix-table*```).  They
overshadow the stable operators in the core of the language.

**INVARIANT:**
> ```←``` is *the assignment operator* and *not* part of the infix
> operator lattice. 
> It has *fixed precedence* and *right associativity* 
> and *cannot be overridden, shadowed, or redefined.*
> Additional warning message:
> "The assignment operator does not compute values; it assigns values to
>  variables and cannot be redefined.” 
> But still, the error messages is:
> "set.infix.weight/set.infix.assoc doesn't like ← as input."

## Alternatives for reconciliation

As a general principle, Logo favors **verbs** as names for *commands*
(procedures called for their effect), and **nouns** as names for *operations*
(procedures called for their output).

Turtle Talk partially deviates from this scheme through historically grown
vocabulary choices.

As a possible reconciliation, *alternative names* may be introduced as
**aliases or meta-commands**, without replacing the canonical Berkeley Logo
vocabulary.

---

### Meta-commands for turtle motion

An additional command `move` may be introduced as a **meta-command** that
composes existing directional commands such as `forward`, `backward`, `left`,
and `right`.

The meaning of the second input depends on the direction:

```logo
move forward 10   ; second input is distance
move left 270     ; second input is angle
```

This preserves the original primitives while allowing motion to be expressed as
a compositional sentence.

---

### Meta-commands for state toggling

Another possible meta-command is toggle, used with symbolic state names:

```Logo
toggle textscreen
toggle fullscreen
toggle splitscreen
```

Optional shorthands may be provided:

```Logo
tts
ttf
tss
```

These forms do not replace existing commands; they provide an alternative,
linguistically explicit layer.

---

### Aliases for communicative clarity

Some commands may be complemented with aliases that emphasize communicative
intent:

- ```label``` → ```say```
  Prints text at the turtle’s current position.
- ```filled``` → ```paint.in```
  Takes a color code and an instruction list describing a polygon; the effect
  is the filled polygon.
  
### Explicit scope vocabulary

Alternatives for the scope-related commands:

- ```global``` → ```globalize```
- ```local``` → ```localize```

These aliases make the effect of the command explicit, without altering
semantics.

## Complex numbers

*Complex numbers* may be introduced as an **explicit numeric extension**.

Literal notation:
```Logo
(0.0,1.4142135)c
```

This corresponds to the Common Lisp representation: 
```Common-Lisp
#C(0.0 1.14142135)
``` 
and aligs naturally with vector notation used in turtle geometry.

This literal form is complemented by a constructor operation:
```Logo
complex 0.0 1.4142135
```
which evaluates to:
```Logo
(0.0,1.4142135)c
```
analogous to how:
```Logo
int 1.3
```
evaluates to:
```Logo
1
```
No implicit coercions are introduced; complex numbers remain explicit symbolic
objects.
