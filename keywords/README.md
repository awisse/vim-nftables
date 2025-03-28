# Notes About Keyword Highlighting

There are a total of 431 keywords in nftables (computed with kw-count.py)

In this directory, we collect keywords to be highlighted, separated by their
function. Colors will be assigned according to the category.

* Basic: Comment, strings, constants and objects.

* Types: `integer`, `bitmask`, `ether_addr`, ...

* Named constants: echo-reply, destination-unreachable, ...

* Expressions

  - Payload

  - Extension Header

  - Conntrack

* Statements: `drop`, `accept`, ...

## Keywords that are in two or more categories. 
Examples: `set`: object or statement, `counter`: object, statement or type). A 
choice is made in each case and the choice is documented in the keyword file.
Where possible, distinct highlighting is used with `syntax match` commands.  

