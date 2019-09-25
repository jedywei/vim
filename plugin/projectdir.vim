" Name: projectdir.vim
" Descrption: search recursivly ascent root marker to set up project directory
" Author:   Jedy Wei    2019/09/20
" 

" Init {{{ 1
if exists('g:loaded_projectdir') && g:loaded_projectdir
    finish
endif

let g:loaded_projectdir = 1
let g:projectdir#path = ''


function! s:getparent(item)
    let parent = substitute(a:item, '[\/][^\/]\+[\/:]\?$', '', '')
    if parent == '' || parent !~ '[\/]'
        let parent .= s:lash
    endif
    return parent
endfunction

function! s:fnesc(path, type, ...)
    if exists('*fnameescape')
        if exists('+ssl')
            if a:type == 'c'
                let path = escape(a:path, '%#')
            elseif a:type == 'f'
                let path = fnameescape(a:path)
            elseif a:type == 'g'
                let path = escape(a:path, '?*')
            endif
            let path = substitute(path, '[', '[[]', 'g')
        else
            let path = fnameescape(a:path)
        endif
    else
        if exists('+ssl')
            if a:type == 'c'
                let path = escape(a:path, '%#')
            elseif a:type == 'f'
                let path = escape(a:path, " \t\n%#*?|<\"")
            elseif a:type == 'g'
                let path = escape(a:path, '?*')
            endif
            let path = substitute(path, '[', '[[]', 'g')
        else
            let path = escape(a:path, " \t\n*?[{`$\\%#'\"|!<")
        endif
    endif
    return a:0 ? escape(path, a:1) : path
endfunction

function! s:findrootmarker(curr, mark, depth)
    let [depth, found] = [a:depth+1, 0]
    if type(a:mark) == 1  " string
        let found = globpath(s:fnesc(a:curr, 'g', ','), a:mark, 1) != ''
    elseif type(a:mark) == 3 "array
        for amarker in a:mark
            if globpath(s:fnesc(a:curr, 'g', ','), amarker, 1) != ''
                let found = 1
                break
            endif
        endfor
    endif

    if found
        return a:curr
    elseif depth > 100
        return  getcwd()
    else
        let parent = s:getparent(a:curr)
        if parent != a:curr
            return s:findrootmarker(parent, a:mark, depth)
        endif
    endif

    return ''
endfunction

function! projectdir#reset()
    let g:projectdir#path == ''
endfunction

function! projectdir#get()
    if g:projectdir#path != ''
        return g:projectdir#path
    endif

    let s:lash = &ssl || !exists('+ssl') ? '/' : '\'

    if exists('g:projectdir_rootmarkers')
        let result = s:findrootmarker(getcwd(), g:projectdir_rootmarkers, 0)
        if result != ''
            let g:projectdir#path = result
            return result
        endif
    endif

    let markers = ['.git', '.hg', '.svn', '.bzr', '_darcs']

    let result = s:findrootmarker(getcwd(), markers, 0)
    if result != '' 
        let g:projectdir#path = result
    else
        let g:projectdir#path = getcwd()
    endif

    return g:projectdir#path
endfunction



