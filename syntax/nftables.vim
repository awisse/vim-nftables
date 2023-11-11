" vim: ts=4:sw=2:sts=2:
syntax clear
if exists('b:current_syntax') || &compatible
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match nftablesSet           /{.*}/ contains=nftablesSetEntry
syn match nftablesSetEntry      /[a-zA-Z0-9]\+/ contained

" Hexadecimal Numbers
syn match nftablesHex           "\<0x[0-9A-Fa-f]\+\>"
" syn match nftablesDelimiter     "[./:]" contained
" syn match nftablesMask          "/[0-9.]\+" contained contains=nftablesDelimiter

" Addresses
syn match nftablesIP4addr       "\d\{1,3\}\(\.\d\{1,3\}\)\{3\}\(\/[1-9]\d\)\?"
syn match nftablesIP6addr       "\(\x\{0,4\}:\)\+\x\{0,4\}\(\/[1-9]\d\{0,2\}\)\?"
syn match nftablesIP6addr       "\[\(\x\{0,4\}:\)\+\x\{0,4\}\]\(\/[1-9]\{0,2\}\)\?"
syn match nftablesMACaddr           "\<\x\{2\}\(:\x\{2\}\)\{5\}\>"

"syn keyword Type length protocol mark skuid skgid rtclassid
"
" Interfaces
syn match nftablesInterface     "\<-\@<!\(iif\|iifname\|iiftype\|oif\|oifname\)\>"

" TCP Flags
syn match nftablesTCPFlags      "\<-\@<!\(fin\|syn\|rst\|psh\|ack\|urg\|ecn\|cwr\)\>"

" Comments
syn keyword nftablesTodo        FIXME TODO XXX NOTE contained
syn match   nftablesComment     "#.*" contains=nftablesTodo
syn match   nftablesComment     "\<-\@<!\<comment\>"

" Tables, Chains
syn match   nftablesTable       "\<\(add\|create\|delete\|flush\)\s\+table\>"
syn match   nftablesTable       "-\@<!\<table\>"
syn match   nftablesChain       "\<\(add\|create\|delete\|flush\)\?\s\+chain\>"
syn match   nftablesChain       "-\@<!\<chain\>"

" Priority
syn match   nftablesPriority    "priority\s\+\(raw\|mangle\|dstnat\|filter\|security\|srcnat\|out\|-\?\d\+\)"
"
" String
syn region  nftablesString      start=/"/ end=/"/

" syn keyword Function map
"syn keyword Type ct
"syn keyword Type length protocol mark skuid skgid rtclassid

" Address families
syn match nftablesAddrFamily    "[^-]\<ip\>"
syn match nftablesAddrFamily    "[^-]\<ip6\>"
syn match nftablesAddrFamily    "[^-]\<inet\>"
syn match nftablesAddrFamily    "[^-]\<arp\>"
syn match nftablesAddrFamily    "[^-]\<bridge\>"
syn match nftablesAddrFamily    "[^-]\<netdev\>"

" Ruleset
syn match nftablesRuleset   "[^-]\<ruleset\>"
syn match nftablesRuleset   "[^-]\<list\>"
syn match nftablesRuleset   "[^-]\<flush\>"

" Protocols
syn match nftablesProto     "[^-]\<ether\>"
syn match nftablesProto     "[^-]\<vlan\>"
syn match nftablesProto 	"[^-]\<arp\>"
syn match nftablesProto 	"[^-]\<ip\>"
syn match nftablesProto 	"[^-]\<icmp\>"
syn match nftablesProto 	"[^-]\<igmp\>"
syn match nftablesProto 	"[^-]\<ip6\>"
syn match nftablesProto 	"[^-]\<icmpv6\>"
syn match nftablesProto 	"[^-]\<tcp\>"
syn match nftablesProto 	"[^-]\<udp\>"
syn match nftablesProto 	"[^-]\<udplite\>"
syn match nftablesProto 	"[^-]\<sctp\>"
syn match nftablesProto 	"[^-]\<dccp\>"
syn match nftablesProto 	"[^-]\<ah\>"
syn match nftablesProto 	"[^-]\<esp\>"
syn match nftablesProto 	"[^-]\<comp\>"
syn match nftablesProto 	"[^-]\<icmpx\>"

" Hooks
syn match nftablesHook 		"\<hook prerouting\>"
syn match nftablesHook 		"\<hook input\>"
syn match nftablesHook 		"\<hook forward\>"
syn match nftablesHook 		"\<hook output\>"
syn match nftablesHook 		"\<hook postrouting\>"
syn match nftablesHook 		"\<hook ingress\>"

" Chain Type
syn match nftablesChainType "\<type \(filter\|nat\|route\)\>"
syn match nftablesPolicy    "-\@<!\<policy\>"

" Rules
syn match nftablesConntrack "-\@<!\<ct\s\+state\>"

" Statements
" Verdict
syn match nftablesVerdict   "-\@<!\<accept\>"
syn match nftablesVerdict   "-\@<!\<drop\>"
syn match nftablesVerdict   "-\@<!\<queue\>"
syn match nftablesVerdict   "-\@<!\<continue\>"
syn match nftablesVerdict   "-\@<!\<return\>"
syn match nftablesVerdict   "-\@<!\<jump\>"
syn match nftablesVerdict   "-\@<!\<goto\>"
" Payload, Extension Header
syn match nftablesPayldExtH "-\@<!\<set\>"
" Log
syn match nftablesLog       "-\@<!\<log\>"
syn match nftablesLog       "-\@<!\<prefix\>"
syn match nftablesLog       "-\@<!\<level\>"
syn match nftablesLog       "-\@<!\<flags\>"
syn match nftablesLog       "-\@<!\<group\>"
syn match nftablesLog       "-\@<!\<snaplen\>"
syn match nftablesLog       "-\@<!\<audit\>"
syn match nftablesLog       "-\@<!\<queue-threshold\>"
" Reject 
syn match nftablesReject    "-\@<!\<reject\(\s\+with\)\?\>"
" Counter
syn match nftablesCounter   "-\@<!\<counter\>"
syn match nftablesCounter   "-\@<!\<packets\>"
syn match nftablesCounter   "-\@<!\<bytes\>"
syn match nftablesCounter   "-\@<!\<limit\>"
" Conntrack
syn match nftablesCTStatemt "\<ct\s\+\(mark\|event\|label\|zone\)\s\+set\>"


syn keyword Special snat dnat masquerade redirect
syn keyword Keyword counter log limit
syn keyword Keyword define

" Colors and highlights
hi def link nftablesSet         Keyword
hi def link nftablesTCPFlags    Constant
hi def link nftablesSetEntry    Operator
hi def link nftablesNumber      Number
hi def link nftablesHex         Number
hi def link nftablesHook        PreProc
hi def link nftablesAddrFam     Type
hi def link nftablesProto       Type
hi def link nftablesInterface   Type
hi def link nftablesVerdict     Statement
hi def link nftablesPayldExtH   Statement
hi def link nftablesLog         Statement
hi def link nftablesReject      Statement
hi def link nftablesCounter     Statement
hi def link nftablesCTStatemt   Statement
hi def link nftablesIP4addr     Identifier
hi def link nftablesIP6addr     Identifier
hi def link nftablesMACaddr     Identifier
hi def link nftablesTODO        Todo
hi def link nftablesComment     Comment
hi def link nftablesString      String
hi def link nftablesTable       Function
hi def link nftablesChain       Function
hi def link nftablesChainType   Type
hi def link nftablesConntrack   Type
hi def link nftablesPolicy      PreProc
hi def link nftablesPriority    Special

let b:current_syntax = 'nftables'

let &cpo = s:cpo_save
unlet s:cpo_save
