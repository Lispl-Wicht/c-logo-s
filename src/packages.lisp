(eval-when (:compile-toplevel :load-toplevel :execute)
  (defpackage #:logo
    (:use #:cl)
    (:export #:word #:logo-list #:sentence #:logo-array 
             #:logo-first #:logo-last #:logo-butfirst #:logo-butlast #:logo-item
             #:setitem 
             #:wordp #:word? #:logo-sequencep #:logo-sequence?
             #:logo-arrayp #:logo-array? #:emptyp #:empty?
             #:logo-count
             #:kindof #:something #:oneof
             #:exist #:have #:havemake
             #:self #:parents #:mynames #:mynamep #:myname?
             #:myprocs #:myprocp #:myproc?
             #:talkto #:ask
             #:whosename #:whoseproc
             #:logo-print #:show
             #:sum #:difference #:minus #:product #:quotient
             #:lessp #:greaterp #:lessequalp #:greaterequalp
             #:logo-if))
  
  (defpackage #:logo/library
    (:use #:logo)
    (:export #:mdarray #:combine #:reverse #:logo-gensym
             #:mditem #:pick #:remove #:remdup #:quoted
             #:mdsetitem #:push #:pop #:queue #:dequeue
             #:backslashedp #:backslashed?
             #:closeall #:filep
             #:iseq #:rseq
             #:name #:localmake
             #:namelist #:pllist
             #:poall #:pops #:pons #:popls #:pon #:popl #:pots
             #:ern #:erpl #:buryname #:unburyall #:unburyname
             #:edall #:edps #:edns #:edpls #:edn #:edpl #:savel
             #:ignore #:for #:do.while #:while #:do.until #:until
             #:logo-case #:logo-cond
             #:invoke #:foreach #:map #:map.se #:filter #:find #:reduce #:crossmap
             #:cascade #:cascade.2 #:transfer))

;; (defpackage #:logo/reader
;;    (:use #:cl #:logo)
;;    (:export #:continue-lines #:construct-lines #:split-comment-in-line
;;             #:preserve-comments #:split-bars-in-line
;;             #:tokenize-normal #:tokenize-segments #:repair-bars
;;             #:normalize-minus #:verbalize-lines))

;;  (defpackage #:logo/evaluator
;;    (:use #:cl #:logo))

  (defpackage #:logo/raylib
    (:use #:cl))

  (defpackage #:logo/graphics
    (:use #:cl #:logo/raylib))

  (defpackage #:logo/sound
    (:use #:cl ;; ...)
          ))
  

  (defpackage #:logo/turtle-geometry
    (:use #:logo #:logo/library #:logo/graphics)
    (:export #:forward #:fd #:back #:bk #:left #:lt #:right #:rt  
             #:setpos #:setxy #:setx #:sety #:setheading #:seth #:home #:arc
             #:pos #:heading #:towards #:scrunch
             #:showturtle #:st #:hideturtle #:ht #:clean #:clearscreen #:cs
             #:wrap #:window #:fence #:fill #:filled #:label #:setlabelheight
             #:closeturtle
             #:setscrunch #:refresh #:norefresh
             #:showpnp #:turtlemode #:labelsize
             #:pendown #:pd #:penup #:pu #:penpaint #:ppt #:penerase #:pe
             #:penreverse #:px #:setpencolor #:setpc #:setpalette #:setpensize
             #:setpenpattern #:setpen #:setbackground
             #:pendownp #:penmode #:pencolor #:pen #:palette #:pensize #:background
             #:savepict #:loadpict #:pdfpict #:jpgpict
             #:mousepos #:clickpos #:buttonp #:button ))

  (defpackage #:logo/workspace
    (:use #:logo #:logo/library
          #:logo/turtle-geometry)))
