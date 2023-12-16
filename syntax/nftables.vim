" vim: tabstop=4:shiftwidth=4:softtabstop=4:expandtab
" TODO: 
" 1. Reduce number of syntax groups. 
" 2. Assign colors to groups. 
" 3. Write test examples.
let b:nft_debug = 1 " XXX: Set to 0 when not debugging
if b:nft_debug == 1
  syntax clear 
elseif exists(b:current_syntax) || &compatible
  finish 
endif

let s:cpo_save = &cpo
set cpo&vim

" 1. the "-" character appears in certain keywords (ex: gc-interval)
" 2. Allow chain and table names which contain keywords separated with "-"
syntax iskeyword=@,48-57,$,_,-

" Order is important to respect multi-word definitions
runtime! keywords/basic.vim
runtime! keywords/types.vim
runtime! keywords/named-constants.vim
runtime! keywords/expressions.vim
runtime! keywords/statements.vim

" Multi-word definitions last
" Chain Type
syn match   nftDataType           "\<type\s\+\%(filter\|nat\|route\)\>"

" Properties
syn match   nftProperty  "\<timeout\s\+\d\+\>" contains=nftInt
syn match   nftProperty "\<\%(expires\|timeout\)\s\+\%(\d\{1,2}d\)\?\%(\d\{1,2}h\)\?\%(\d\{1,2}m\)\?\%(\d\{1,2}s\?\)\?\>" 
syn keyword nftProperty  devices

" Stateful Objects ("ct helper" is also a CONNTRACK EXPRESSION. We stick with
" the Object highlighting)
syn match   nftObject       "\<ct\s\+\%(helper\|timeout\|expectation\)\>"


" Colors and highlights
hi nftType                    ctermfg=3
hi nftVerb                    ctermfg=219 
hi nftValue                   ctermfg=9
hi nftObject                  ctermfg=38

" Linked highlight groups
" In basic.vim
hi link nftIdentifier     Identifier
hi link nftAddrFamily     nftType
hi link nftHook           nftType
hi link nftTodo           Todo
hi link nftComment        Comment
hi link nftString         String
hi link nftInt            nftValue
hi link nftHex            nftValue
hi link nftIPv4addr       nftValue
hi link nftIPv6addr       nftValue
hi link nftMACaddr        nftValue
hi link nftTimeout        nftValue



hi link nftProperty       PreProc
hi link nftDataType       nftType

hi link nftExpression     Identifier
hi link nftNamedConstant  Identifier


hi link nftStatement      Statement 



let b:current_syntax = 'nftables'

let &cpo = s:cpo_save
unlet s:cpo_save

