" vim: tabstop=2:shiftwidth=2:softtabstop=2:
let b:nft_debug = 1 " XXX: Set to 0 when not debugging
if b:nft_debug == 1
  syntax clear 
elseif exists(b:current_syntax) || &compatible
  finish 
endif

" 1. the "-" character appears in certain keywords (ex: gc-interval)
" 2. Allow chain and table names which contain keywords separated with "-"
set iskeyword+=-

" Identifiers match many strings. We define them first in case we want to
" override them with other matches later. (example: `ct helper`)
syn match   nftIdentifier   /[@$]\?\h[A-Za-z0-9_-]*/

" Multi-use keywords which can be verbs or other types
" set: Verb, Object : Map to verb. "add set" is technically a composed verb
" map: Verb, Object : Map to verb. "add map" is technically a composed verb
"
" Comments
syn keyword nftTodo         FIXME TODO XXX NOTE contained
syn match   nftComment      /#.*/ contains=nftTodo
syn keyword nftComment      comment

" Verbs
syn keyword nftVerb         include define undefine redefine add delete reset set map
syn match   nftFlushRuleset "\<flush\s\+ruleset\>"

" Objects
syn keyword nftObject       chain element flowtable rule table element
syn keyword nftStatefulObject  counter quota 

" Stateful Objects
syn match   nftStatefulObject     "\<ct \%(helper\|timeout\|expectation\)\>"

" Statements
syn match   nftStatefulObject  "\<ct expectation set\>"

" Properties (tables, chains, sets, maps)
syn keyword nftChainType    filter nat route
syn keyword nftChainProperty   type hook device priority policy 
syn keyword nftPriority     raw mangle dstnat filter security srcnat out
syn keyword nftSetProperty      typeof flags gc-interval elements size auto-merge 
syn match nftCTExpProperty  "\<timeout\s\+\d\+\>" contains=nftINT
syn match nftElementProperty "\<\%(expires\|timeout\)\s\+\%(\d\{1,2}d\)\?\%(\d\{1,2}h\)\?\%(\d\{1,2}m\)\?\%(\d\{1,2}s\?\)\?\>" contains=nftSetTimeout
syn keyword nftFlowtableProperty  devices
syn keyword nftCTHelperSpec protocol l3proto
syn keyword nftCTHelperState close close_wait established fin_wait last_ack retrans syn_recv syn_sent time_wait unack


" Predefined constants
" L4 Protocols
syn keyword nftL4Proto      tcp udp
" SET/MAP FLAGS
syn keyword nftSetFlags     constant dynamic interval 
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
syn keyword nftCTEvent     destroy protoinfo mark seqadj secmark label
" syn keyword nftCTEvent   helper 
" dccp_pkttype
syn keyword nftPKTType     request response data ack dataack closereq close sync syncack

" Types
syn keyword nftDataType     integer bitmask string ipv4_addr ipv6_addr boolean 
syn keyword nftDataType     ether_addr inet_proto inet_service mark counter quota

syn keyword nftCTType       ct_state ct_dir ct_status ct_event ct_label
syn keyword nftICMPType     icmp_type icmp_code icmpx_code icmpv6_code 
syn keyword nftDCCPType     dccp_pkttype

" Values
syn region  nftString       start=/"/ end=/"/
syn match   nftINT          "\<-\?\d\+\>"
syn match   nftDecimal      "\<-\?\d\+\%(\.\d\+\)\>"
syn match   nftHex          "\<0x\x\+\>"
syn match   nftIPv4addr     "\<\d\{1,3}\%(\.\d\{1,3}\)\{3}\%(\/[1-9]\d\)\?\>"
syn match   nftIPv6addr     "\%(\x\{0,4}:\)\+\x\{0,4}\%(\/[1-9]\d\{0,2}\)\?"
syn match   nftIPv6addr     "\[\%(\x\{0,4}:\)\+\x\{0,4}\]\%(\/[1-9]\{0,2}\)\?"
syn match   nftMACaddr      "\<\x\{2}\%(:\x\{2}\)\{5}\>"
syn match   nftSetTimeout   "\<\%(\d\{1,2}d\)\?\%(\d\{1,2}h\)\?\%(\d\{1,2}m\)\?\%(\d\{1,2}s\?\)\?\>" contained

" Address Families and Hooks
syn keyword nftAddrFamily   ip ip6 inet arp bridge netdev
syn keyword nftHook         prerouting input forward output postrouting ingress egress

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
"syn keyword nftMeta           type

" Routing expressions
syn match   nftRouting        "\<rt\%(\s\+ip\|\s\+ip6\)\?\s\+\%(classid\|nexthop\|mtu\|ipsec\)\>"

" IPSEC expressions
syn match   nftIPSEC          "\<ipsec\%(\s\+in\|\s\+out\)\%(\s\+spnum\s\+\d\+\)\?\s\+\%(ip\|ip6\|reqid\|spi\)\%(\s\+saddr\|\s\+daddr\)\>"

" STATEMENT
" VERDICT STATEMENT
syn keyword nftVerdict        accept drop queue continue return jump goto 
" Colors and highlights
hi nftType                    ctermfg=3
hi nftVerb                    ctermfg=219 
hi nftValue                   ctermfg=9
hi nftObject                  ctermfg=38
hi nftTest                    ctermfg=11
hi nftVerdict                 ctermfg=199

hi link nftFlushRuleset   nftVerb
hi link nftInclude        Include
hi link nftString         String
hi link nftTodo           Todo
hi link nftComment        Comment

hi link nftCTVerb         nftVerb
hi link nftIdentifier     Identifier

hi link nftIPv4addr       nftValue
hi link nftIPv6addr       nftValue
hi link nftTimespec       nftValue
hi link nftSetTimeout     nftValue

hi link nftChainType      nftType
hi link nftProperty       PreProc
hi link nftChainProperty  nftProperty
hi link nftSetProperty    nftProperty
hi link nftElementProperty nftProperty
hi link nftFlowtableProperty nftProperty
hi link nftCTHelperSpec   nftProperty  
hi link nftCTExpProperty  nftProperty
hi link nftCTHelperState  nftType
hi link nftCTState        nftType
hi link nftDataType       nftType
hi link nftSetFlags       nftType
hi link nftFlagOfSet      nftType
hi link nftPriority       nftType
hi link nftPKTType        nftType 
hi link nftL4Proto        nftType  
hi link nftAddrFamily     nftType

hi link nftStatefulObject nftObject
hi link nftHook           nftType

hi link nftConstant       Constant
hi link nftINT            nftValue
hi link nftDecimal        nftValue
hi link nftHex            nftValue
hi link nftMACaddr        nftValue
hi link nftMeta           nftType

hi link nftICMPType       nftType


if b:nft_debug
  let b:current_syntax = 1
endif
