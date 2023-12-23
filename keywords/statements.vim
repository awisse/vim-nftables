" Verbs and keywords used in statements
" Verbs. `set`, object or verb? We go with verb.
syn keyword nftVerb         define undefine redefine add delete set update
syn keyword nftVerb         flush ruleset
syn keyword nftInclude      include

" VERDICT STATEMENTS
syn keyword nftStatement            accept drop queue continue return jump goto

" LOG STATEMENT (level, flags: expressions.vim)
syn keyword nftStatement            prefix queue-threshold snaplen 
syn match   nftStatement            "\<log\%(\s\+\%(group\|prefix\)\)\?\>"

" REJECT STATEMENT
syn match nftStatement              "\<reject\%(\s\+with\)\?\>"

" COUNTER STATEMENT (counter, packets, bytes) covered in expressions, types
" CONNTRACK (ct {mark | event | label | zone } set) covered in expressions

" NOTRACK STATEMENT
syn keyword nftStatement            notrack

" META STATEMENT (meta {mark | priority | pkttype | nftrace} set) covered in
" expressions.

" LIMIT STATEMENT (hour day bytes) covered in expressions
"
syn keyword nftStatement            limit rate

" NAT STATEMENTS (Also in CONNTRACK EXPRESSION. Statement has precedence.)
syn keyword nftStatement            snat dnat masquerade redirect to 

" TPROXY STATEMENT (to: covered by NAT)
syn keyword nftStatement            tproxy

" SYNPROXY STATEMENT 
syn keyword nftStatement            synproxy mss wscale

" FLOW STATEMENT (add: covered as verb in basic.vim)
syn keyword nftStatement            flow

" QUEUE STATEMENT (queue: VERDICT, to: NAT, flags: expressions.vim)

" DUP/FWD STATEMENT (to: NAT)
syn keyword nftStatement            dup fwd

" MAP STATEMENT (map: nftObject)

" VMAP STATEMENT 
syn keyword nftStatement            vmap
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
