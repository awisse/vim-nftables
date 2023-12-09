" Keywords appearing in expressions
" META EXPRESSIONS
syn keyword nftExpression           length nfproto l4proto protocol priority mark iif iifname
                                    \ iiftype oif oifname oiftype skuid skgid nftrace rtclassid
                                    \ ibrname obrname pkttype cpu iifgroup oifgroup cgroup 
                                    \ random ipsec iifkind oifkind time hour day

" SOCKET EXPRESSION (mark: covered)
syn keyword nftExpression           socket transparend wildcard cgroupv2 level

" OSF EXPRESSION
syn keyword nftExpression           osf ttl loose skip name version

" FIB EXPRESSION (iif oif oifname mark: covered by META)
syn keyword nftExpression           fib saddr daddr type

" ROUTING EXPRESSIONS
syn keyword nftExpression           rt classid nexthop mtu ipsec

" IPSEC EXPSESSIONS (ipsec saddr daddr: covered FIB ROUTING)
syn keyword nftExpression           in out reqid spi

" NUMGEN EXPRESSION (random: covered my META)
syn keyword nftExpression           numgen inc mod offset

" HASH EXPRESSION (saddr daddr: covered before)
syn keyword nftExpression           jhash tcp dport udp sport ether seed symhash

" ETHERNET HEADER EXPRESSION (ether daddr saddr type: covered before)

" VLAN HEADER EXPRESSION (type: covered before)
syn keyword nftExpression           id dei pcp

" ARP HEADER EXPRESSION (saddr daddr ether: covered before)
syn keyword nftExpression           htype ptype hlen plen operation

" IPV4 HEADER EXPRESSION (version length id protocol checksum saddr daddr)
syn keyword nftExpression           hdrlength dscp ecn frag-off ttl checksum

" ICMP HEADER EXPRESSION (type checksum type id: covered)
syn keyword nftExpression           icmp code sequence gateway mtu

" IGMP HEADER EXPRESSION (type checksum: covered)
syn keyword nftExpression           igmp mrt group

" IPV6 HEADER EXPRESSION (version length checksum saddr daddr: covered)
syn keyword nftExpression           dscp ecn flowlabel nexthdr hoplimit

" ICMPV6 HEADER EXPRESSION (type code checksum id sequence: covered)
syn keyword nftExpression           icmpv6 parameter-problem packet-too-big max-delay

" TCP HEADER EXPRESSION (tcp sequence checksum: covered) 
syn keyword nftExpression           sport dport ackseq doff reserved flags window urgptr

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

" EXTENSION HEADER EXPRESSIONS
" (hdrlength nexthdr frag-off id type checksum flags: covered)
syn keyword nftExpression           hbh frag more-fragments seg-left rt dst mh srh tag sid 
" (tcp window: covered)  
syn keyword nftExpression           option eol  nop  maxseg  sack-perm  sack  sack0  
                                    \ sack1  sack2  sack3  timestamp 
" (option: covered)
syn keyword nftExpression           lsrr ra rr ssrr        
" (hbh frag rt dst mh: covered)
syn keyword nftExpression           exthdr 

" CONNTRACK EXPRESSIONS (mark id saddr daddr: covered)
syn keyword nftExpression           ct state direction status expiration helper label l3proto
                                    \ count original reply bytes  packets  avgpkt  zone
                                    \ proto-src  proto-dst 

" EXPRESSION FOR NAT FLAGS (random: covered by META)
syn keyword nftExpression           persistent fully-random
" EXPRESSION FOR SYNPROXY FLAGS (timestamp: covered by EXTENSION HEADER)
syn keyword nftExpression           sack-perm 
" EXPRESSION FOR QUEUE FLAGS (symhash: HASH, numgen: NUMGEN)
syn keyword nftExpression           bypass fanout hash
" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
