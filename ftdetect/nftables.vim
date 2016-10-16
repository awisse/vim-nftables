function! s:DetectFiletype()
    if getline(1) =~# '^#!\s*\%\(/\S\+\)\?/\%\(s\)\?bin/\%\(env\s\+\)\?nft\>'
        setfiletype nftables
    endif
endfunction

autocmd BufRead,BufNewFile * call s:DetectFiletype()
autocmd BufRead,BufNewFile *.nft setfiletype nftables
