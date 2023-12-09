" nftables keywords for data types and associated named constants
" Roughly in the order of appearance in the man page

" Data types
syn keyword nftDataType     integer bitmask string boolean 
syn keyword nftDataType     lladdr ipv4_addr ipv6_addr 
syn keyword nftDataType     icmp_type icmp_code icmpx_code icmpv6_code 
syn keyword nftDataType     ct_state ct_dir ct_status ct_event ct_label
syn keyword nftDataType     dccp_pkttype

" Extra types in sets and maps
syn keyword nftDataType     ether_addr inet_proto inet_service mark counter quota
"
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab

