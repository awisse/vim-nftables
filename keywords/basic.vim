" Basic nftables keywords for comments, strings, constants and objects
" Delimiter
syn match   nftDelimiter    /[}{]/
" Values
syn match   nftInt          "\<-\?\d\+\>"
syn match   nftIntRange     "\<\%(\d\+\)\?-\?\d\+\>"
syn match   nftHex          "0x\x\+"
syn match   nftIPv4addr     "\d\{1,3}\%(\.\d\{1,3}\)\{3}\%(\/[1-9]\d\?\)\?" 
syn match   nftIPv6addr     "\<\%(\x\{1,4}::\?\)\+\%(\x\{1,4}\)\?\%(\/[1-9]\d\{,2}\)\?" 
syn match   nftIPv6addr     "\%(::\)"
syn match   nftIPv6addr     "\[\%(\x\{,4}:\)\+\x\{,4}\]\%(\/[1-9]\{,2}\)\?"
" " syn match   nftMACaddr: Covered by nftIPv6addr
" FIXME: Seconds don't need unit. But must not be confused with integer (for
" nftIPv4addr)
syn match   nftTimeSpec     "\<\%(\d\{1,}d\)\?\%(\d\{1,}h\)\?\%(\d\{1,}m\)\?\%(\d\{1,}s\?\)\?\>" contained
syn region  nftString       start=/"/ end=/"/

" Objects. Excluding `set`. See in statements.vim.
" respectively.
syn match   nftObject       "\<\(table\|chain\|map\|element\|rule\|flowtable\|counter\|quota\)\>"

" counter and quota are also statements and types, but with the same meaning 
" as the object: We shall prioritize the "Types" highlighting in types.vim.
" syn keyword nftObject       counter quota

" Address Families and Hooks
syn keyword nftAddrFamily   inet arp bridge netdev ipv4 ipv6
" Used in CONNTRACK EXPRESSION later: ip, ip6
syn match   nftAddrFamily   "\<\%(ip\|ip6\)\>"

" Comments
syn keyword nftTodo         FIXME TODO XXX NOTE contained
syn region  nftComment      start='#' end='$' contains=nftTodo
syn keyword nftComment      comment

"
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
