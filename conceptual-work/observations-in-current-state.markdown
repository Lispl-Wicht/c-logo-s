The system is far from complete now. At this stage, it only targets people who
are curious to learn both: Logo and Common Lisp, and want a programming
environment that can be used to foster computational thinking in school across
subjects.

Common Lisp must be installed and configured. It is highly recommended to use
the combination SBCL, Emacs with SLIME, and the package manager Quicklisp as the
integrated development environment (IDE).

[This tiny project *Portaclish*] is
intended as a low-threshold platform-independent "jump start" for experimenting
with cLogos.  It aims at getting the dedicated IDE working without deeper
knowledge. However, it still aims at confident tinkerers.

The current source of cLogos can be downloaded into the ```quicklisp```
directory, targeting its canonical subdirectory ```local-projects```

With Emacs and SLIME running, the system can then be loaded at the SLIME prompt with:
```
CL-USER> (asdf:load-system :clogos)
```
The core package is entered as follows:
```
CL-USER> (in-package :logo)
LOGO>
```

Two examples may demonstrate a fundamental design choice:
```
LOGO> (word (logo-wd "hell") (logo-wd "o"))
#S(WD :STR "hello" :NMB NIL :SYM NIL :FLAGS NIL)
LOGO> (lookup-procedure "sum")
#S(PROC
   :NAME "sum"
   :PACKAGE LOGO
   :IMPLEMENTATION #<FUNCTION SUM>
   :DEFAULT-ARITY 2
   :OPTIONAL-ARITY -1
   :VISIBILITY :PUBLIC)
```

Custom data types are ```structures``` not ```classes```. Thus, the Common Lisp
Object System (CLOS) is not fully applied for Logo's implementation.

The current development task is to complete the parser, whose first action is to
dissolute the line continuator ```~```:
```
LOGO> (logo/reader:continue-lines "to foo :bar :baz
  repeat 4 ~
   print sum :bar ~
             :baz
end")
"to foo :bar :baz
  repeat 4    print sum :bar              :baz
end"
LOGO> 
```

This pipeline prepares the intermediate datum that will be gradually transformed
into the internal representation of a Logo line to be evaluated and printed. The
current state (not fully correct):
```
LOGO> (verbalize-lines
       (normalize-minus-in-tree
        (repair-bars
         (tokenize-segments 
          (preserve-comments 
           (construct-lines 
            (continue-lines 
             "if ~emptyp :line ~ 
  repeat 5 ~
   [print word \"|hel~lo \"lello|] ; a comment something else
print sum :a 4 + -5")))))))
(:TOKENS
 ((:LINE
   (#S(WD :STR "if" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "~emptyp" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "line" :NMB NIL :SYM NIL :FLAGS (:THING)) (:WHITESPACE " ")
    (:WHITESPACE " ") (:WHITESPACE " ")
    #S(WD :STR "repeat" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "5" :NMB 5 :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    (:WHITESPACE " ") (:WHITESPACE " ") (:WHITESPACE " ") (:OBRACKET "[")
    #S(WD :STR "print" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "word" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "hel~lo lello" :NMB NIL :SYM NIL :FLAGS (:QUOTED :BARRED))
    (:CBRACKET "]") (:WHITESPACE " "))
   :COMMENT " a comment something else")
  (:LINE
   (#S(WD :STR "print" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "sum" :NMB NIL :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "a" :NMB NIL :SYM NIL :FLAGS (:THING)) (:WHITESPACE " ")
    #S(WD :STR "4" :NMB 4 :SYM NIL :FLAGS NIL) (:WHITESPACE " ")
    #S(WD :STR "+" :NMB NIL :SYM NIL :FLAGS (:INFIX)) (:WHITESPACE " ")
    #S(WD :STR "minus" :NMB NIL :SYM MINUS :FLAGS NIL)
    #S(WD :STR "5" :NMB 5 :SYM NIL :FLAGS NIL))
   :COMMENT NIL))
 :EOF T)
```

Barred words like ```"|hel~lo "lello|``` are still not treated correctly. Barred
words in Logo are verbatim representations. Thus it must be transformed to
```#S(WD :STR "hel~lo "lello" :NMB NIL :SYM NIL :FLAGS (:QUOTED :BARRED))```.

Also ```normalize-minus-in-tree``` is not fully matured. 
If the minus sign is switched to the four, it would still be treated as an infix
operator instead of a sign. In the instruction ```print sum :a -4 + 5``` the
```-``` and the ```4``` will be tokenized as ```(:INFIX "-") (:NAME "4")```
instead of 
```#S(WD :STR "minus" :NMB NIL :SYM MINUS :FLAGS NIL) (:NAME "4")```.

