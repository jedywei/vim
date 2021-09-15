" Name: mruModifiedBuffer.vim
" Description: maintain most rescent used modifed buffer list 
" Author: Jedy Wei 2019/09/24

"Init {{{ 1

" Default disable mruModifiedBuffer.vim
finish

if exists('g:loaded_mruModifiedBuffer') && g:loaded_mruModifiedBuffer
    finish
endif

let g:loaded_mruModifiedBuffer = 1


"nnoremap <silent><C-left>   :call mruModifiedBuffer#navigate('b')<CR>
"nnoremap <silent><C-right>  :call mruModifiedBuffer#navigate('f')<CR>
" 1 }}}
nnoremap <Plug>mruModifiedBuffer_next :call mruModifiedBuffer#navigate('n', bufnr('%'))<CR>
nnoremap <Plug>mruModifiedBuffer_previous :call mruModifiedBuffer#navigate('p', bufnr('%'))<CR>
nnoremap <Plug>mruModifiedBuffer_add :call mruModifiedBuffer#update('i', bufnr('%'))<CR>
nnoremap <Plug>mruModifiedBuffer_del :call mruModifiedBuffer#remove(bufnr('%'))<CR>
nnoremap <Plug>mruModifiedBuffer_print :call mruModifiedBuffer#listall()<CR>

command! MMRU call mruModifiedBuffer#listall() 


augroup mruModifiedBuffer#group
    autocmd!
    autocmd TextChanged * call mruModifiedBuffer#update('n', str2nr(expand('<abuf>')))
    autocmd TextChangedI * call mruModifiedBuffer#update('i', str2nr(expand('<abuf>')))
    autocmd BufDelete * call mruModifiedBuffer#remove(str2nr(expand('<abuf>')))
    autocmd BufAdd * call mruModifiedBuffer#update('n', str2nr(expand('<abuf>')))
    autocmd VimEnter * call mruModifiedBuffer#init()
augroup END

"---------------------------------------------------------------------------
" MRU Modified Buffer List

function! mruModifiedBuffer#init()
    let g:mruModifiedBuffer#tcn_count = get(g:, 'mruModifiedBuffer#tcn_count', 0)
    let g:mruModifiedBuffer#tci_count = get(g:, 'mruModifiedBuffer#tci_count', 0)
    let g:mruModifiedBuffer#idx = get(g:, 'mruModifiedBuffer#idx', -1)
    let g:mruModifiedBuffer#timeout = get(g:, 'mruModifiedBuffer#timeout', 10)
    let g:mruModifiedBuffer#ft = get(g:, 'mruModifiedBuffer#ft','^\(c\|make\|cpp\|vim\|text\)$')

    if g:mruModifiedBuffer#idx >= 0
        g:mruModifiedBuffer#idx = -1
    endif

    " should change the scope from global to script
    let g:mruBufnr = -1
    let g:lastNavigateReltime = [0, 0]

    " init mruModifiedBuffer#list
    let g:mruModifiedBuffer#list =  filter(range(1, bufnr('$')), 'bufloaded(v:val) && getbufvar(v:val, ''&filetype'') =~ g:mruModifiedBuffer#ft')
    if empty(g:mruModifiedBuffer#list)
        g:mruModifiedBuffer#list = [ bufnr('%') ]
    endif

endfunction


function! mruModifiedBuffer#debug(key, abuf)
    echomsg 'key: ' . a:key . ' abuf: '. a:abuf
endfunction

function! mruModifiedBuffer#remove(abuf)
    let l:lastidx =  index(g:mruModifiedBuffer#list, a:abuf)
    if l:lastidx >= 0
        call remove(g:mruModifiedBuffer#list, l:lastidx)
    endif
endfunction

function! mruModifiedBuffer#update(type, abuf)
    if a:abuf == g:mruBufnr
        return
    endif

    let g:mruBufnr = a:abuf

    if  &filetype !~ g:mruModifiedBuffer#ft
        return
    endif

    if a:type == 'n'
        let g:mruModifiedBuffer#tcn_count = g:mruModifiedBuffer#tcn_count + 1
    elseif a:type == 'i'
        let g:mruModifiedBuffer#tci_count = g:mruModifiedBuffer#tci_count + 1
    endif

    " remove currbufnr from mruModifiedBufferList
    " and add it to the last of mruModifiedBufferList
    let l:lastidx =  index(g:mruModifiedBuffer#list, a:abuf)
    if l:lastidx >= 0
        call remove(g:mruModifiedBuffer#list, l:lastidx)
    endif
    call add(g:mruModifiedBuffer#list, a:abuf)
    let g:mruModifiedBuffer#idx = -1
    echo 'Add bufnr [' . a:abuf . '] to modified buffer list'
endfunction

function! mruModifiedBuffer#navigate(key, abuf)

    " if empty(g:mruModifiedBuffer#list)
    "     let g:mruModifiedBuffer#list = [ bufnr('%') ]
    " endif

    let l:now = reltime()
    if a:key == 'n'
        let l:advanced = 1
    else
        let l:advanced = -1
    endif

    if l:now[0] > g:lastNavigateReltime[0] + g:mruModifiedBuffer#timeout 
        if a:key == 'n'
            let g:mruModifiedBuffer#idx = -1 
        else
            let g:mruModifiedBuffer#idx = -2
        endif
    else
        let g:mruModifiedBuffer#idx = g:mruModifiedBuffer#idx + l:advanced
    endif

    let g:lastNavigateReltime = l:now
    let l:msg = ''

    if g:mruModifiedBuffer#idx >= 0
        let g:mruModifiedBuffer#idx = -1
        let l:msg = 'At start of mmru bufferlist ' . g:mruModifiedBuffer#idx
    elseif g:mruModifiedBuffer#idx < -len(g:mruModifiedBuffer#list)
        let g:mruModifiedBuffer#idx = -len(g:mruModifiedBuffer#list)
        let l:msg = 'At end of mmru bufferlist ' . g:mruModifiedBuffer#idx
    endif

    try
        let l:selectBufnr = g:mruModifiedBuffer#list[g:mruModifiedBuffer#idx]
        if l:selectBufnr != bufnr('%')
            silent execute 'buffer ' . l:selectBufnr
            let l:msg = 'Switch to buffer ' . l:selectBufnr
        endif
    catch
        let l:msg = 'list index out of range: ' . g:mruModifiedBuffer#idx . ' list: ' . string(g:mruModifiedBuffer#list)
        let g:mruModifiedBuffer#idx = -1
    endtry

    echo l:msg

endfunction

function! mruModifiedBuffer#listall()
    let idx = 0
    echo 'list: ' . string(g:mruModifiedBuffer#list) . ' idx: ' . g:mruModifiedBuffer#idx
    for nr in g:mruModifiedBuffer#list
        echo printf("%2d [%2d] %s", idx, nr, bufname(nr))
        let idx = idx + 1
    endfor
endfunction
