" nftables keywords for data types and associated named constants
" Roughly in the order of appearance in the man page

" Properties (tables, chains, sets, maps)
" Chain: type: defined as multi-word later in nftables.vim
"        priority: Defined in META EXPRESSION (expressions.vim)
"        flags: TCP HEADER EXPRESSION
" Set/Map
syn keyword nftProperty     typeof elements auto-merge 
syn match   nftProperty     "\<size\>" 

" Data types
syn keyword nftDataType     integer bitmask string boolean 
syn keyword nftDataType     lladdr ipv4_addr ipv6_addr 
syn keyword nftDataType     icmp_type icmp_code icmpx_code icmpv6_code icmpv6_type 
syn keyword nftDataType     hook device policy
syn keyword nftDataType     handle index
" CONNTRACK TYPES
syn keyword nftDataType     ct_state ct_dir ct_status ct_event ct_label
syn keyword nftDataType     dccp_pkttype

" Extra types in sets and maps (mark: expressions.vim)
syn keyword nftDataType     ether_addr inet_proto inet_service 
"
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab

