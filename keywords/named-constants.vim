" nftables keywords for named constants and bitmaps
" Roughly in the order of appearance in the man page

" Standard priority names (out: expressions.vim)
syn keyword nftNamedConstant    raw mangle dstnat security srcnat
" filter: Chain Type in nftables.vim
syn match   nftNamedConstant    "\<filter\>"

" L4 Protocols (tcp, udp: defined in HASH EXPRESSION, expressions.vim)
" syn keyword nftNamedConstant    tcp udp

" SET/MAP FLAGS
syn keyword nftNamedConstant    constant dynamic interval 

" TCP FLAGS
syn keyword nftNamedConstant    fin syn rst psh ack urg ecn cwr

" ICMP TYPE (parameter-problem: ICMPV6 HEADER EXPRESSION)
syn keyword nftNamedConstant    echo-reply destination-unreachable source-quench
                                \ echo-request router-advertisement router-solicitation 
                                \ time-exceeded timestamp-request 
                                \ timestamp-reply info-request info-reply address-mask-request
" (redirect: used in NAT STATEMENT. Not defined here.)
" ICMP CODE
syn keyword nftNamedConstant    net-unreachable host-unreachable port-unreachable 
                                \ frag-needed net-prohibited host-prohibited
                                \ admin-prohibited
" ICMPV6 TYPE TYPE (packet-too-big: ICMPV6 HEADER EXPRESSION)
syn keyword nftNamedConstant    mld-listener-query mld-listener-report
                                \ mld-listener-done mld-listener-reduction nd-router-solicit
                                \ nd-router-advert nd-neighbor-solicit nd-neighbor-advert
                                \ nd-redirect router-renumbering ind-neighbor-solicit
                                \ ind-neighbor-advert mld2-listener-report
" ICMPV6 CODE TYPE
syn keyword nftNamedConstant    no-route addr-unreachable policy-fail reject-route

" Conntrack (snat, dnat: highlighted as statements)
"
syn keyword nftNamedConstant    close close_wait established fin_wait last_ack retrans 
                                \ syn_recv syn_sent time_wait unack
syn keyword nftNamedConstant    invalid related new untracked 
" (original, reply: used in CONNTRACK EXPRESSION)
syn match   nftNamedConstant    "\<\%(original\|reply\)\>"
syn keyword nftNamedConstant    expected seen-reply assured confirmed dying
" (mark: expressions.vim)
syn keyword nftNamedConstant    destroy protoinfo seqadj secmark
" (label: used in CONNTRACK EXPRESSION)
syn match   nftNamedConstant    "\<label\>"
"
" dccp_pkttype (close: Conntrack, ack: TCP FLAGS)
syn keyword nftNamedConstant    request response dataack closereq
                                \ sync syncack


" SCTP CHUNKS/FIELDS (flags: expressions.vim,
"                     cwr: TCP FLAGS, length: META EXPR, type: FIB EXPR,
"                     sack: EXTENSION HEADER EXPRESSIONS)
syn keyword nftNamedConstant    data init init-ack heartbeat 
                              \ heartbeat-ack abort shutdown shutdown-ack error 
                              \ cookie-echo cookie-ack ecne shutdown-complete asconf-ack 
                              \ forward-tsn	asconf tsn stream ssn ppid
                              \ init-tag num-outbound-streams num-inbound-streams initial-tsn
                              \ cum-tsn-ack a-rwnd num-gap-ack-blocks num-dup-tsns
                              \ lowest-tsn seqno new-cum-tsn


" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
