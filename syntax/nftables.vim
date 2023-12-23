" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
" TODO: 
" 1. Reduce number of syntax groups (Done)
" 2. Assign colors to groups (Done)
" 3. Write test examples.
let b:nft_debug = 1 " XXX: Set to 0 when not debugging
if b:nft_debug == 1
  syntax clear 
elseif exists("b:current_syntax") || &compatible
  finish 
endif

let s:cpo_save = &cpo
set cpo&vim

" 1. the "-" character appears in certain keywords (ex: gc-interval)
" 2. Allow chain and table names which contain keywords separated with "-"
syntax iskeyword    @,48-57,@-@,_,-

runtime! keywords/basic.vim
runtime! keywords/types.vim
runtime! keywords/named-constants.vim
runtime! keywords/expressions.vim
runtime! keywords/statements.vim

" Multi-word definitions last
" Chain Type
syn match   nftDataType     "\<type\s\+\%(filter\|nat\|route\)\>" contains=nftNamedConstant
syn match   nftDataType     "\<priority\s\+\%(\k\+\|-\?\d\+\)\>" contains=nftNamedConstant,nftInt
" Exception for meta expression:
syn match   nftExpression   "\<priority\s\+set\>" contains=nftVerb

" Set/Map Properties
syn match   nftProperty     "\<type\s\+\%(ipv4_addr\|ipv6_addr\|ether_addr\|inet_proto\|inet_service\|mark\)\>" 
syn match   nftProperty     "\<\%(gc-interval\|expires\|timeout\)\s\+\%(\d\{1,}d\)\?\%(\d\{1,}h\)\?\%(\d\{1,}m\)\?\%(\d\{1,}s\?\)\?\>" contains=nftTimeSpec,nftInt
syn match   nftProperty     "\<flags\s\+\%(constant\|dynamic\|interval\|timeout\)" contains=nftNamedConstant
syn keyword nftProperty     devices

" Stateful Objects ("ct helper" is also a CONNTRACK EXPRESSION. We stick with
" the Object highlighting)
syn match   nftObject       "\<ct\s\+\%(helper\|timeout\|expectation\)\>"

" Statements
syn match   nftStatement    "\<ct\s\+\%(event\|helper\|mark\|label\|zone\)\>"

" Colors and highlights
" Brown
hi nftType                ctermfg=3
" Red
hi nftValue               ctermfg=Red
" LightBlue 
hi nftObject              ctermfg=124

hi link nftVerb           Statement
" basic.vim
hi link nftAddrFamily     Identifier
hi link nftHook           nftNamedConstant
hi link nftTodo           Todo
hi link nftComment        Comment
hi link nftString         nftValue
hi link nftInt            nftValue
hi link nftTimeSpec       nftValue
hi link nftIntRange       nftValue
hi link nftHex            nftValue
hi link nftIPv4addr       nftValue
hi link nftIPv6addr       nftValue
hi link nftObject         Identifier 
hi link nftDelimiter      Delimiter 

" types.vim
hi link nftProperty       nftType
hi link nftDataType       nftType

" named-constants.vim
hi link nftNamedConstant  Identifier

" expressions.vim
hi link nftExpression     Identifier

" statements.vim
hi link nftStatement      Statement 
hi link nftInclude        Include



let b:current_syntax = 'nftables'

let &cpo = s:cpo_save
unlet s:cpo_save

