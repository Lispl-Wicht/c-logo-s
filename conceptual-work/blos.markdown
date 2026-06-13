# The Berkeley Logo Object System (BLOS) -- implemented without CLOS

> Prototype OOP becomes problematic only when it hides its own lookup graph —
> BLOS avoids this by making the graph explicit, shallow, and inspectable. 

| **Kind**   | **Structure**     | **Access** |
|------------|-------------------|------------|
| Word       | scalar            | identity   |
| List       | ordered n-tuple   | position   |
| Array      | indexed n-tuple   | index      |
| **Object** | **named n-tuple** | **name**   |

> Objects are Logo's structs -- but upgraded into environments.
> They are 
> - not just data
> - not just methods
> - but 
>   - **a self-contained workspace**, 
>   - **workspace with anchestry**,
>   - **participants in name resolution**.

> Lists answer *where*, objects answer *who*.
> Objects abridge data and context.

> Objects add **one more place where Logo variables may live**
> - an object-local variable table
> - accessed *only when that object is current*.

**Conceptually:**
```
object = {
  variables: {name -> value},
  procedures: {name -> procedure},
  parents: [object...]
}
```
with *dynamic* lookup, not lexical. 
-> In Logo, procedures serve also as BLOS methods. 

The Common Lisp implementation artefact (not the semantic center):

```Common-Lisp
(defstruct blos-object
  variables   ; alist or hash-table: symbol -> value
  procedures  ; alist or hash-table: symbol -> procedure
  parents)    ; list of blos-object
```

The ```defstruct``` supports *storage*, but **meaning** emerges from the
evaluator, not from the data structure.

> Crucial distinction:
> In CLOS: *Objects respond to messages.*
> In BLOS: *Procedures are looked up relative to an object.*

| **Logo concept**          | **CL implementation role**              |
|---------------------------|-----------------------------------------|
| Object                    | ```blos-object``` struct                |
| Object variable           | lookup entry in ```variables``` slot    |
| Object procedure (method) | lookup entry in ```procedures``` slot   |
| Inheritance               | parent chain lookup                     |
| Current object            | dynamic variable ```*current-object*``` |
| ```ask```/```talkto```    | dynamic rebinding of context            |
| ```usual.foo```           | explicit parent traversal               |



  **talkto**
  ```TALKTO object```

  changes the current object to object. (Note that the input is an object, not
  the name of an object.) Talkto can be used only at toplevel or within a pause
  (when typing into a Logo prompt, not inside a procedure).

