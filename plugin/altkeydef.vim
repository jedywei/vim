" Name: altkeydef.vim
" Description: define <A-key> for ssh, console and macos
" Author: Jedy Wei 2019/09/25


if exists('g:loaded_altkeydef') && g:loaded_altkeydef == 1
    finish
endif

let g:loaded_altkeydef = 1

execute "set <A-1>=\e1"
execute "set <A-2>=\e2"
execute "set <A-3>=\e3"
execute "set <A-4>=\e4"
execute "set <A-5>=\e5"
execute "set <A-6>=\e6"
execute "set <A-7>=\e7"
execute "set <A-8>=\e8"
execute "set <A-9>=\e9"
execute "set <A-0>=\e0"
execute "set <A-->=\e-"
execute "set <A-=>=\e="
execute "set <A-a>=\ea"
execute "set <A-b>=\eb"
execute "set <A-c>=\ec"
execute "set <A-d>=\ed"
execute "set <A-e>=\ee"
execute "set <A-f>=\ef"
execute "set <A-g>=\eg"
execute "set <A-h>=\eh"
execute "set <A-i>=\ei"
execute "set <A-j>=\ej"
execute "set <A-k>=\ek"
execute "set <A-l>=\el"
execute "set <A-m>=\em"
execute "set <A-n>=\en"
execute "set <A-o>=\eo"
execute "set <A-p>=\ep"
execute "set <A-q>=\eq"
execute "set <A-s>=\es"
execute "set <A-t>=\et"
execute "set <A-u>=\eu"
execute "set <A-v>=\ev"
execute "set <A-w>=\ew"
execute "set <A-x>=\ex"
execute "set <A-y>=\ey"
execute "set <A-z>=\ez"
"execute "set <A-Space>=\e<Space>"   "not working well, that will enter Replace mode
execute "set <A-.>=\e."
execute "set <A-,>=\e,"
"execute "set <A-[>=\e["             "not working well, that will enter Replace mode
execute "set <A-]>=\e]"
execute "set <A-\\>=\e\\"

" end of altkeydef.vim
 
