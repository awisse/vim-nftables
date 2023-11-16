" vim: tabstop=2:shiftwidth=2:softtabstop=2:
let b:nft_debug = 1 " XXX: Set to 0 when not debugging
if b:nft_debug
  syntax clear 
elseif exists(b:current_syntax) || &compatible
  finish 
endif

" 1. the "-" character appears in certain keywords (ex: gc-interval)
" 2. Allow chain and table names which contain keywords separated with "-"
set iskeyword+=-

" Multi-use keywords which can be verbs or other types
" set: Verb, Object : Map to verb. "add set" is technically a composed verb
" map: Verb, Object : Map to verb. "add map" is technically a composed verb
"
" Comments
syn keyword nftTodo         FIXME TODO XXX NOTE contained
syn match   nftComment      /#.*/ contains=nftTodo
syn keyword nftComment      comment

" Verbs
syn keyword nftInclude      include
syn keyword nftVerb         define add delete reset flush set map

" Objects
syn keyword nftObject       chain element flowtable rule ruleset table element
syn keyword nftStatefulObj  counter quota 

" Stateful Objects
syn match   nftCTObject     "\<ct \%(helper\|timeout\|expectation\)\>"

" Statements
syn match   nftCTStatement  "\<ct expectation set\>"

" Parameters (in tables, chains, sets, maps)
syn keyword nftTableParam   flags
syn keyword nftChainParam   type hook device priority policy 
syn keyword nftSetParam     typeof flags timeout gc-interval elements size auto-merge
syn keyword nftElementParam expires
syn keyword nftFlowtbParam  devices

" Predefined constants
" TCP FLAGS
syn keyword nftTCPFlags     fin syn rst psh ack urg ecn cwr
" ICMP TYPE
syn keyword nftICMPType     echo-reply destination-unreachable source-quench redirect 
                              \ echo-request router-advertisement router-solicitation 
                              \ time-exceeded parameter-problem timestamp-request 
                              \ timestamp-reply info-request info-reply address-mask-request
" ICMP CODE
syn keyword nftICMPCode     net-unreachable host-unreachable port-unreachable 
                              \ port-unreachable frag-needed net-prohibited host-prohibited
                              \ admin-prohibited
" ICMPV6 TYPE TYPE
syn keyword nftICMPV6TypeType  
                              \ packet-too-big mld-listener-query mld-listener-report
                              \ mld-listener-done mld-listener-reduction nd-router-solicit
                              \ nd-router-advert nd-neighbor-solicit nd-neighbor-advert
                              \ nd-redirect router-renumbering ind-neighbor-solicit
                              \ ind-neighbor-advert mld2-listener-report
" ICMPV6 CODE TYPE
syn keyword nftICMPV6CodeType     
                              \ no-route addr-unreachable policy-fail reject-route
" ct_state
syn keyword nftCTState     invalid established related new untracked 
" ct_dir
syn keyword nftCTDir       original reply 
" ct_status
syn keyword nftCTStatus    expected seen-reply assured confirmed snat dnat dying
" ct_event
syn keyword nftCTEvent     destroy protoinfo helper mark seqadj secmark label
" dccp_pkttype
syn keyword nftPKTType     request response data ack dataack closereq close sync syncack

" Types
syn keyword nftDataType     integer bitmask string ipv4_addr ipv6_addr boolean
syn keyword nftCTType       ct_state ct_dir ct_status ct_event ct_label
syn keyword nftICMPType     icmp_type icmp_code icmpx_code icmpv6_code 
syn keyword nftDCCPType     dccp_pkttype

" Values
syn match   nftVariable     /\$\?\a\w\?/
syn region  nftString       start=/"/ end=/"/
syn match   nftHex          "\<0x\x\+\>"
syn match   nftIP4addr      "\<\d\{1,3}\%(\.\d\{1,3}\)\{3}\%(\/[1-9]\d\)\?\>"
syn match   nftIP6addr      "\%(\x\{0,4}:\)\+\x\{0,4}\%(\/[1-9]\d\{0,2}\)\?"
syn match   nftIP6addr      "\[\%(\x\{0,4}:\)\+\x\{0,4}\]\%(\/[1-9]\{0,2}\)\?"
syn match   nftMACaddr      "\<\x\{2}\%(:\x\{2}\)\{5}\>"
syn match   nftTimespec     "\<\%(\d\{1,2}d\)\?\%(\d\{1,2}h\)\?\%(\d\{1,2}m\)\?\%(\d\{1,2}s\)\?\>"

" Address Families and Hooks
syn keyword nftAddrFamily   ip ip6 inet arp bridge netdev
syn keyword nftHook         hook prerouting input forward output postrouting ingress egress


" Meta Expressions
syn match   nftMeta           "\<meta\s\+\%(length\|nfproto\|l4proto\|protocol\|priority\)\>"
syn keyword nftMeta           meta mark iif iifname iiftype oif oifname oiftype sdif sdifname
                              \ skuid skgid nftrace rtclassid ibrname obrname pkttype cpu 
                              \ nftrace rtclassid ibrname obrname pkttype cpu 
                              \ iifgroup oifgroup cgroup random ipsec iifkind oifkind 
                              \ time hour day
" Socket Expression
syn match   nftSocket         "\<socket\s\+\%(transparent\|mark\|wildcard\)\>"
syn match   nftSocket         "\<socket\s\+cgroupv2\s\+level\s\+\d\>"

" OSF Expression
syn match   nftOSF            "\<osf\%(ttl\s\+\%(loose\|skip\)\)\?\s\+\%(name\|version\)\>"

" FIB Expression
syn match   nftFib            "\<fib\s\+\%(saddr\|daddr\|mark\|iif\|oif\)\>"
syn keyword nftMeta           type

" Routing expressions
syn match   nftRouting        "\<rt\%(\s\+ip\|\s\+ip6\)\?\s\+\%(classid\|nexthop\|mtu\|ipsec\)\>"

" IPSEC expressions
syn match   nftIPSEC          "\<ipsec\%(\s\+in\|\s\+out\)\%(\s\+spnum\s\+\d\+\)\?\s\+\%(ip\|ip6\|reqid\|spi\)\%(\s\+saddr\|\s\+daddr\)\>"

" Colors and highlights
hi nftType                    ctermfg=3
hi nftVerb                    ctermfg=12
hi nftValue                   ctermfg=9
hi nftObject                  ctermfg=38

hi def link nftInclude        Include
hi def link nftString         String
hi def link nftTodo           Todo
hi def link nftComment        Comment

hi def link nftCTVerb         nftVerb
hi def link nftVariable       Identifier

hi def link nftParameter      PreProc
hi def link nftConstant       Constant
hi def link nftHex            nftValue
hi def link nftMACaddr         nftValue

hi def link nftICMPType       nftType
hi def link nftExpression     Identifier
hi def link nftVariable       Identifier

hi def link nftAddrFamily     Type



if b:nft_debug
  let b:current_syntax = 'nft'
endif
