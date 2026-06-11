# cLogos style considerations

Style recommendations in cLogos are meant to support reading, discussion, and
reflection. They are not correctness criteria. 

## Indentation is not syntax, it is optics (7 June 2026)

*Logo is a medium for thinking.*

That is why indentation is a *diagrammatic cue*, not a rule. 
The language ignores whitespace. The learner does not.

Historically, Logo inherited:

- line orientation from teletype culture,
- flat textuality from early Lisp read-eval-print loops.

This lead to a layout style without indentation, such as:
```logo
to foo :bar :baz
repeat 4 :bar + :baz
end
```

This layout, fostered in many Logo textbooks, is not forbidden. But the cLogos 
environment supports indentation as an editor feature, because

> whitespace helps humans to see the structure of the instructions.

```logo
to foo :bar :baz
  repeat 4 :bar + :baz
end
```

and

```logo
to foo :bar :baz
  repeat 4 ~
    :bar + :baz
end
```

will be preset in the environment by default, still adjustable by the learners
to their own taste, for instance:

```logo
to foo :bar :baz
  repeat 4 ~
         :bar + :baz
end
```

## Logo's abbreviations (7 June 2026)

In Logo textbooks, the shorthands of procedure names are frequently used, like
```pr``` for ```print```, ```op``` for ```output```, ```fd``` for ```forward```
etc. 

This habit may have one or more of these possible backgrounds:

- Machines with small memory could be more efficiently be used with shorter
  procedure names.
- A hacker culture fostered mnemonic codes as a sort of signature for the
  adepts, the "leet hackers" ("leet" = "elite").
- Shorthands of commands as verbs appeared as performative, spoken contractions
  like "going to" -> "gonna", or "because"  -> "cause".
- The teletype keyboards in the 1960s were sluggish, so that children were
  relieved by typing shorter procedure names.
- Shorter aliases relieved younger children from correct spelling of the full
  procedure names.
  
The latter reason still justifies the traditional shortcuts for younger learners.

Therefore, cLogos preserves Logo’s historical abbreviations.

However, for clarity and comprehensibility, the environment prioritises full
procedure names and will autocomplete shorthands to their expanded forms.

## Object-orientation adds expressiveness not a paradigm

Although experimental in Berkeley Logo, still being worked on, and only
optionally compiled into Berkeley Logo, the concept is implemented in cLogos as
an extension layer: the Berkeley Logo Object System (BLOS).

However,  BLOS does not change the way Logo programs are written. The core
thinking model of Logo remains procedures and lists, just as the core thinking
model of Common Lisp remains functions and macros. BLOS is Logo’s structured
extension of identity, behaviour, and inheritance, just as CLOS is Common Lisp’s
structured extension of dispatch and identity.

Both cLogos and Common Lisp can be used entirely without object orientation.
The respective object systems provide additional expressive power but are not
the dominant mode of expression.

Thus, plain Logo programming remains the primary pedagogical mode, and object
orientation is introduced only when it provides clear, pedagogically meaningful
and structurally useful advantages.
