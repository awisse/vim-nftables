" nftables keywords for named constants and bitmaps
" Roughly in the order of appearance in the man page

" Properties (tables, chains, sets, maps)
syn keyword nftChainProperty    type hook device priority policy 
syn keyword nftChainType        filter nat route
syn keyword nftPriority         raw mangle dstnat filter security srcnat out
syn keyword nftSetProperty      typeof flags gc-interval elements size auto-merge 

" L4 Protocols
syn keyword nftL4Proto          tcp udp

" SET/MAP FLAGS
syn keyword nftSetFlags         constant dynamic interval 

" Address Families and Hooks
syn keyword nftAddrFamily       ip ip6 inet arp bridge netdev
syn keyword nftHook             prerouting input forward output postrouting ingress egress

" TCP FLAGS
syn keyword nftTCPFlags         fin syn rst psh ack urg ecn cwr

" ICMP TYPE
syn keyword nftICMPType         echo-reply destination-unreachable source-quench redirect 
                                \ echo-request router-advertisement router-solicitation 
                                \ time-exceeded parameter-problem timestamp-request 
                                \ timestamp-reply info-request info-reply address-mask-request
" ICMP CODE
syn keyword nftICMPCode         net-unreachable host-unreachable port-unreachable 
                                \ port-unreachable frag-needed net-prohibited host-prohibited
                                \ admin-prohibited
" ICMPV6 TYPE TYPE
syn keyword nftICMPV6TypeType   packet-too-big mld-listener-query mld-listener-report
                                \ mld-listener-done mld-listener-reduction nd-router-solicit
                                \ nd-router-advert nd-neighbor-solicit nd-neighbor-advert
                                \ nd-redirect router-renumbering ind-neighbor-solicit
                                \ ind-neighbor-advert mld2-listener-report
" ICMPV6 CODE TYPE
syn keyword nftICMPV6CodeType   no-route addr-unreachable policy-fail reject-route

" Conntrack (snat, dnat: highlighted as statements)
"
syn keyword nftCTHelperState    close close_wait established fin_wait last_ack retrans 
                                \ syn_recv syn_sent time_wait unack
syn keyword nftConntrackType    ct_state ct_dir ct_status ct_event ct_label 
syn keyword nftConntrackType    invalid established related new untracked 
syn keyword nftConntrackType    original reply 
syn keyword nftConntrackType    expected seen-reply assured confirmed dying
syn keyword nftConntrackType    destroy protoinfo mark seqadj secmark label
"
" dccp_pkttype
syn keyword nftDCCPType         dccp_pkttype request response data ack dataack closereq close 
                                \ sync syncack


" SCTP CHUNKS/FIELDS (flags: expressions.vim)
syn keyword nftSCTPFields       data init init-ack sack heartbeat 
                              \ heartbeat-ack abort shutdown shutdown-ack error 
                              \ cookie-echo cookie-ack ecne cwr shutdown-complete asconf-ack 
                              \ forward-tsn	asconf type length tsn stream ssn ppid
                              \ init-tag num-outbound-streams num-inbound-streams initial-tsn
                              \ cum-tsn-ack a-rwnd num-gap-ack-blocks num-dup-tsns
                              \ lowest-tsn seqno new-cum-tsn


" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
