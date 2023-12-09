# Notes About Keyword Highlighting

## Decisions

In this directory, we collect keywords to be highlighted, separated by their
function. Colors will be assigned according to the category.

Decide which keyword belongs in which category.

* Basic: Comment, strings, constants and objects.

* Types: integer, bitmask, ether\_addr, ...

* Named constants: echo-reply, destination-unreachable, ...

* Expressions

  - Payload

  - Extension Header

  - Conntrack

* Statements: drop, accept, ...

Multifunction keywords (Keywords that are in two or more categories. 
Examples: `set, ip`). How will these be highlighted?

