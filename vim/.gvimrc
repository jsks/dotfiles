" GUI settings
colorscheme lucius
LuciusWhite

set guioptions-=mTlrb
set display+=lastline
set textwidth=0
set spell
set expandtab

fu! ToggleMenu()
    if &guioptions =~# 'm'
        set guioptions-=m
    else
        set guioptions+=m
    endif
endfu

map <silent> <F11> <Esc>:call ToggleMenu()<cr>
map <F5> :setlocal spell! spelllang=en_us<cr>
