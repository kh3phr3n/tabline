" File: tabline.vim
" Source: https://github.com/kh3phr3n/tabline
" Original: https://github.com/mkitt/tabline.vim

" Initialization
" --------------

if exists('g:loaded_tabline_vim')
    finish
endif

let g:loaded_tabline_vim = 1
let s:save_cpo = &cpo
set cpo&vim

" Helper functions
" ----------------

function! Superscript(n)
    let unicodes = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
    return a:n < len(unicodes) ? unicodes[a:n] : '⁺'
endfunction

function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        " Get tab infos
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let splits = tabpagewinnr(tab, '$')
        " Get buf infos
        let buflist = tabpagebuflist(tab)
        let bufspnr = buflist[winnr - 1]
        let bufname = bufname(bufspnr)

        " Set tab state
        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        " Set tab label
        let s .= ' ' . tab . (splits > 1 ? Superscript(splits) : '') . ' '
        let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        " Set modified flag
        if getbufvar(bufspnr, '&mod') | let s .= '● ' | endif
    endfor

    " Finalize tabline
    let s .= '%#TabLineFill#' | return s
endfunction

" Set/Cleanup tabline
" -------------------

set tabline=%!Tabline()
let &cpo = s:save_cpo
unlet s:save_cpo

