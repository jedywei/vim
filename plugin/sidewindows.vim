" Name: sidewindows.vim
" Description: Using <A-q> at any window to close all sub windows that cantain
"              buffers as quickfix, location, help, cmd windows
" Author: Jedy Wei 2019/09/25


"Init {{{ 1

if exists('g:loaded_sidewindows') && g:loaded_sidewindows
    finish
endif

let g:loaded_sidewindows = 1

nnoremap <Plug>sidewindows#alt_q  :call sidewindows#alt_q()<CR>
inoremap <Plug>sidewindows#alt_q  :call sidewindows#alt_q()<CR>
nnoremap <Plug>sidewindows#close_quickfix   :call sidewindows#close_quickfix(winnr())<CR>
inoremap <Plug>sidewindows#close_quickfix   :call sidewindows#close_quickfix(winnr())<CR>

command! Allwindows call sidewindows#listwins()
cnoreabbrev allwin  Allwindows

"--------------------------------------------------------------------------------

function! sidewindows#close_quickfix(awin)
    try 
        if !empty(getqflist())
            call setqflist([])
            execute 'cclose'
        elseif !empty(getloclist(a:awin))
            execute 'lclose'
        else
            echoerr "No items in location or quickfix list"
        endif
    catch
        echo v:exception
    endtry
endfunction

function! sidewindows#alt_q()
    for ww in range(1, winnr('$'))
        let abuf = winbufnr(ww)
        let ft = getbufvar(abuf, '&filetype')
        if ft =~ '^\(c\|make\|cpp\)$'
            continue
        endif
        if ft == 'qf'
            call sidewindows#close_quickfix(ww)
        elseif ft == 'help'
            silent execute 'bdelete ' . abuf
        elseif ft == 'vim' && bufname(abuf) == '[Command Line]'
            silent execute 'bdelete ' . abuf
        elseif ft == 'tagbar'
            silent execute 'bdelete ' . abuf
        endif
    endfor
endfunction

function! sidewindows#listwins()
    echo 'winnr(''$'') = ' . winnr('$')
    for ww in range(1, winnr('$'))
        let abuf = winbufnr(ww)
        echo 'win['. l:ww . '] -> buf[' . abuf . '] ft: ' . getbufvar(abuf, '&filetype') . ' name: ' . bufname(abuf)
    endfor
endfunction
