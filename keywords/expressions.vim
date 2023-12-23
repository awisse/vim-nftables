" Keywords appearing in expressions
" QUOTA EXPRESSION
syn keyword nftExpression           over kbytes mbytes
syn keyword nftExpression           used until
" META EXPRESSIONS
syn keyword nftExpression           meta length nfproto l4proto protocol 
syn match   nftExpression           "\<priority\>"
" [META] EXPRESSIONS
syn keyword nftExpression           mark iif iifname iiftype oif oifname oiftype 
                                    \ skuid skgid nftrace rtclassid
                                    \ ibrname obrname pkttype cpu iifgroup 
                                    \ oifgroup cgroup random ipsec iifkind 
                                    \ oifkind time hour day

" SOCKET EXPRESSION (mark: [META]))
syn keyword nftExpression           socket cgroupv2 wildcard
syn match   nftExpression           "\<\%(transparent\|level\)\>"

" OSF EXPRESSION
syn keyword nftExpression           osf ttl loose skip name version

" FIB EXPRESSION (iif oif oifname mark: META)
syn keyword nftExpression           fib saddr daddr
" type defined as match for future multi-word
syn match   nftExpression           "\<type\>"

" ROUTING EXPRESSIONS (ipsec: META)
syn keyword nftExpression           rt classid nexthop mtu

" IPSEC EXPSESSIONS (ipsec saddr daddr: covered FIB ROUTING)
syn keyword nftExpression           in out reqid spi

" NUMGEN EXPRESSION (random: covered my META)
syn keyword nftExpression           numgen inc mod offset

" HASH EXPRESSION (saddr daddr: covered before, ether: named-constants.vim)
syn keyword nftExpression           jhash tcp dport udp sport seed symhash

" ETHERNET HEADER EXPRESSION (ether daddr saddr type: covered before)

" VLAN HEADER EXPRESSION (type: covered before)
syn keyword nftExpression           id dei pcp

" ARP HEADER EXPRESSION (saddr daddr ether: HASH EXPRESSION)
syn keyword nftExpression           htype ptype hlen plen operation

" IPV4 HEADER EXPRESSION (version length id protocol checksum saddr daddr,
"                         ttl: OSF. ecn: TCP FLAG)
syn keyword nftExpression           hdrlength dscp frag-off checksum

" ICMP HEADER EXPRESSION (type checksum type id mtu: covered)
syn keyword nftExpression           icmp code sequence gateway 

" IGMP HEADER EXPRESSION (type checksum: covered)
syn keyword nftExpression           igmp mrt group

" IPV6 HEADER EXPRESSION (version length checksum saddr daddr dscp 
"                         ecn: TCP FLAG)
syn keyword nftExpression           flowlabel nexthdr hoplimit

" ICMPV6 HEADER EXPRESSION (type code checksum id sequence: covered)
syn keyword nftExpression           icmpv6 parameter-problem packet-too-big max-delay

" TCP HEADER EXPRESSION (tcp sequence checksum: covered; dport, sport: HASH) 
syn keyword nftExpression           ackseq doff reserved window urgptr
syn match   nftExpression           "\<flags\>"

" UDP[-LITE] HEADER EXPRESSION (udp sport dport length checksum: covered)
syn keyword nftExpression           udplite

" SCTP HEADER EXPRESSION (sport dport checksum: covered)
syn keyword nftExpression           sctp vtag chunk

" DCCP HEADER EXPRESSION (sport dport type: covered)
syn keyword nftExpression           dccp

" AUTHENTICATION HEADER EXPRESSION (nexthdr hdrlength spi reserved sequence: covered)
syn keyword nftExpression           ah

" ENCRYPTED SECURITY PAYLOAD HEADER EXPRESSION (spi sequence: covered)
syn keyword nftExpression           esp

" IPCOMP HEADER EXPRESSION (nexthdr flags: covered)
syn keyword nftExpression           comp cpi

" RAW PAYLOAD EXPRESSION 
syn match   nftExpression           "\<@\%(ll\|nh\|th\)\>"
" EXTENSION HEADER EXPRESSIONS
" (hdrlength nexthdr frag-off id type checksum flags rt: covered)
syn keyword nftExpression           hbh frag more-fragments seg-left dst mh srh tag sid 
" (tcp window: covered)  
syn keyword nftExpression           option eol nop maxseg sack-perm sack  sack0  
                                    \ sack1  sack2  sack3  timestamp 
" (option: covered)
syn keyword nftExpression           lsrr ra rr ssrr        
" (hbh frag rt dst mh: covered)
syn keyword nftExpression           exthdr 

" CONNTRACK EXPRESSIONS (mark, protocol: META, saddr, daddr: FIB, id: VLAN,
" helper: stick with Stateful Object highlighting in basic.vim)
syn match   nftExpression           "\<ct\>"

" EXPRESSION FOR NAT FLAGS (random: covered by META)
syn keyword nftExpression           persistent fully-random
" EXPRESSION FOR SYNPROXY FLAGS (timestamp: covered by EXTENSION HEADER,
"                                sack-perm: covered)
" EXPRESSION FOR QUEUE FLAGS (symhash: HASH, numgen: NUMGEN)
syn keyword nftExpression           bypass fanout hash
"
" EXPRESSION FOR LIMIT STATEMENT (over bytes kbytes mbytes: QUOTA EXPR, hour
" day: META EXPR)
syn keyword nftExpression           burst second minute 
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
