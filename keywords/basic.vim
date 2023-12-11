" Basic nftables keywords for comments, strings, constants and objects

" Identifiers match many strings. We define them first in case we want to
" override them with other matches later. (example: `ct helper`)
syn match   nftIdentifier   /[@$]\?\h[A-Za-z0-9_-]*/

" Objects. Excluding `set`. See in statements.vim.
" respectively.
syn match   nftObject       "\<\(table\|chain\|map\|element\|rule\|flowtable\)\>"

" counter and quota are also statements and types, but with the same meaning 
" as the object: We shall prioritize the "Types" highlighting in types.vim.
" syn keyword nftObject       counter quota

" Address Families and Hooks
syn keyword nftAddrFamily   inet arp bridge netdev
" Used in CONNTRACK EXPRESSION later: ip, ip6
syn match   nftAddrFamily   "\<\%(ip\|ip6\)\>"

syn keyword nftHook         prerouting input forward output postrouting ingress egress

" Comments
syn keyword nftTodo         FIXME TODO XXX NOTE contained
syn match   nftComment      /#.*/ contains=nftTodo
syn keyword nftComment      comment

" Values
syn region  nftString       start=/"/ end=/"/
syn match   nftInt          "\<-\?\d\+\>"
syn match   nftHex          "\<0x\x\+\>"
syn match   nftIPv4addr     "\<\d\{1,3}\%(\.\d\{1,3}\)\{3}\%(\/[1-9]\d\)\?\>"
syn match   nftIPv6addr     "\%(\x\{0,4}:\)\+\x\{0,4}\%(\/[1-9]\d\{0,2}\)\?"
syn match   nftIPv6addr     "\[\%(\x\{0,4}:\)\+\x\{0,4}\]\%(\/[1-9]\{0,2}\)\?"
syn match   nftMACaddr      "\<\x\{2}\%(:\x\{2}\)\{5}\>"
syn match   nftTimeout      "\<\%(\d\{1,2}d\)\?\%(\d\{1,2}h\)\?\%(\d\{1,2}m\)\?\%(\d\{1,2}s\?\)\?\>" 
"
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
