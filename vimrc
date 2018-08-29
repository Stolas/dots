"*****
"**  Thank you Mister Conway, http://tinyurl.com/IBV2013
"**  Also I never forget the folks at http://www.vimbits.com/
"**  /r/vim gave me a number of tips.
"**  The newest tips came from Amir Salihefendic ( http://amix.dk/vim/vimrc.html )
"*****

"====[ Function Keys ]=======
"<F1>
"<F2> Reserved by commercial tool.
"<F3>
"<F4> Fontswitch
"<F5> Undotree
"<F6> Preview LaTeX (commercial)
"<F7> TagList
"<F8> Show / Hide Menu
"<F9> Run current file
"<F10> Make
"<F11>
"<F12> Todo list

"====[ Init Stuff ]======
    " No things for vim-tiny or vim-small
    if !1 | finish | endif

    if has('vim_starting')
        if $compatible
            set nocompatible  " No vi.
        endif
    endif

    let g:isunix = 1
    if has("win32") || has("win16")
        let g:isunix = 0
    endif

"====[ Plug Plugins ]=============
    " Todo:  Build autoinstall on first run
    let iCanHazPlugz=1
    let plugsrc=expand('~/.vim/autoload/plug.vim')

    if !filereadable(plugsrc)
        let iCanHazPlugz=0
        if g:isunix==1
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        else
            echo "INSTALL PLUG"
        endif

        if iCanHazPlugz==1
            call PlugInstall
        endif
    endif


    call plug#begin()
    " Empower VIM
    " Core Plugins
        " Git plugin
        Plug 'tpope/vim-fugitive'

        " Visualize the undo tree
        Plug 'mbbill/undotree'

        " Syntax checker on file save
        Plug 'w0rp/ale'

        " Pretty colours
        Plug 'vim-scripts/darkspectrum'

        " Awesome search
        Plug 'kien/ctrlp.vim'

        " Fix Whitespaces
        Plug 'bronson/vim-trailing-whitespace'

        " Better CtrlP stuff
        Plug 'tacahiroy/ctrlp-funky'

        " Visualize Marks
        Plug 'kshenoy/vim-signature'

        " Vim File Manager
        Plug 'tpope/vim-vinegar'

        " Fancy Startpage, to easily reach for deep files.
        Plug 'mhinz/vim-startify'

        " EAsy tabs completions
        Plug 'ervandew/supertab'
        Plug 'Shougo/deoplete.nvim'

        " Better TagBar
        Plug 'majutsushi/tagbar'

        " Auto ctags
        " Plug 'xolox/vim-easytags'

        " Header switcher
        Plug 'kris2k/a.vim'

        " Fixme list
        Plug 'vim-scripts/TaskList.vim'

        " Preprocsor
        Plug 'mphe/grayout.vim'

        " CMake
        Plug 'vhdirk/vim-cmake'

        " Clang renamer
        Plug 'uplus/vim-clang-rename'

        " Snippets
        " Todo SirVer/ultisnips for class completion
        " Plug 'Shougo/neosnippet.vim'
        " Plug 'Shougo/neosnippet-snippets'

    " Bloat for other addons
        Plug 'tomtom/tlib_vim'
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'xolox/vim-misc'
        Plug 'roxma/vim-hug-neovim-rpc'
        Plug 'roxma/nvim-yarp'

    " Language Specific
        " C/ C++ Support
        " Plug 'Rip-Rip/clang_complete'
        " Plug 'Shougo/neocomplete.vim'
        Plug 'Valloric/YouCompleteMe'
        " Python Support
        Plug 'davidhalter/jedi-vim'
        " LaTeX Support
        Plug 'lervag/vimtex'

    call plug#end()
    let g:deoplete#enable_at_startup = 1 " Auto Complete
    filetype plugin indent on
    packadd termdebug   " Terminal Debugger

"====[ Generic Source Code Editing ]====================

    " Auto Change to the directory of the edited file.
    autocmd BufEnter * silent! lcd %:p:h
    " With a map leader it's possible to do extra key combinations
    " like <leader>w saves the current file
    let mapleader = "\<Space>"
    let g:mapleader = "\<Space>"

    set clipboard+=unnamed            " Sane default
    set expandtab                     " Spaces instead of tabs
    set title                         " Keep our terminals sane
    set autoread                      " Auto read changed files, I can handle it
    set hidden                        " Unsaved background buffers can be undo'd
    set hlsearch                      " Hilight search
    set incsearch                     " Increase Search
    set linebreak                     " No word breaking
    set mouse=a                       " Enable Mouse-Support
    set number                        " Show number -- Hybrid mode
    set relativenumber                " Show Relative numbers
    set shiftwidth=4                  " Assume tab with of 4
    set tabstop=4                     " Assume tab with of 4
    set nofoldenable                  " We hate folding
    set directory^=$HOME/.vim/tmp/    " Dont make a mess out of my filesystem
    set complete=.,w,b,u,t,i          " Vim can help me being less dyslectic

    set background=dark               " Dark Background

    syntax on
    color darkspectrum                " Pretty Colours
    " color inkpot

"====[ WildIgnore. ]============
    set wildignore =.*                " Ignore dot files
    set wildignore+=*.o,*.obj,*.pyc   " Ignore objects
    set wildignore+=.git,.hg.svn      " Ignore repos
    set wildignore+=*.png,*.jpg,*.gif " We don't need images in vim.

"====[ Make the status line do something useful. ]====================

    set statusline=%t\                              "tail of the filename
    set statusline+=\ %{LinterStatus()}           "Syntax Error
    set statusline+=\ \ %{FugitiveHead(5)}\              "Show the current git branch
    set statusline+=%{IsPasteMode()}                "show pastemode state

    if v:version < 800                               "Warn me when I use old stuff
       set statusline+=[Outdated\ :\ 
       set statusline+=%{v:version}
       set statusline+=\ ]
    endif

    if !has('python3') || !has('terminal') || !has('job')
       set statusline+=[Not\ Found\ :\ "
       if !has('python3')
           set statusline+=Python\ 3\ "
       endif
       if !has('terminal')
           set statusline+=Terminal\ "
       endif
       if !has('python3')
           set statusline+=Job\ "
       endif
       set statusline+=]

    endif

    set statusline+=%=                              "left/right separator


    set statusline+=[Line:%l/%L\ |                  "cursor line/total lines
    set statusline+=Col:%c]\                        "cursor column

    set statusline+=<%H                             "help file flag
    set statusline+=%M                              "modified flag
    set statusline+=%R>\                            "read only flag

    set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
    set statusline+=%{&ff}]                         "file format
    set statusline+=%y                              "filetype
    set laststatus=2

"====[ Startify ]================
     let g:startify_session_dir = '~/.vim/session'

"====[ Make the 81st column of wide lines stand out.. ]====================
     highlight ColorColumn ctermbg=magenta guibg=#dc322f
     call matchadd('ColorColumn', '\%81v', 100)

"====[ Less Aggressive spell checking ]====================
     highlight clear SpellBad
     highlight SpellBad cterm=undercurl

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
    exec "set listchars=tab:\uA6\\ ,trail:\uAF,nbsp:~"
    set list

"====[ Todo list ]====
    let g:tlTokenList = ['Todo', 'TODO', 'FixMe']
    let g:tlWindowPosition = 1
    map <F12> <Plug>TaskList

"====[ Set Compiler ]====
    let g:cmake_c_compiler = "/usr/bin/clang"
    let g:cmake_cxx_compiler = "/usr/bin/clang++"

"====[ Greyout on a timer ]====
    " Todo; Get this to work correctly
    " call timer_start(2000, 'GrayoutUpdate<CR>', {'repeat': -1})

"====[ Execute current file with F9 ]====
    nnoremap <F9> :!%:p<cr>

"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode " ]=

    nnoremap    v   <C-V>
    nnoremap <C-V>     v

    vnoremap    v   <C-V>
    vnoremap <C-V>     v

"====[ ALE mode ]=========
    function! LinterStatus() abort
        let l:counts = ale#statusline#Count(bufnr(''))

        let l:all_errors = l:counts.error + l:counts.style_error
        let l:all_non_errors = l:counts.total - l:all_errors

        return l:counts.total == 0 ? 'No Errors' : printf(
        \   'Warnings: %d Errors: %d',
        \   all_non_errors,
        \   all_errors
        \)
    endfunction

    let g:ale_sign_column_always = 1
    " let g:ale_sign_error = '[!!]'
    " let g:ale_sign_warning = '[-]'
    let g:ale_fix_on_save = 1
    let g:ale_completion_enabled = 1
    let g:ale_keep_list_window_open = 1
    let g:ale_linter = {
    \   'asm': ['gcc'],
    \   'c': ['cppcheck', 'clang', 'flawfinder', 'gcc'],
    \   'cpp': ['cppcheck', 'clang', 'flawfinder', 'gcc'],
    \   'latex': ['chktex','proselint'],
    \   'python': ['flake8'],
    \   'r': ['lintr'],
    \   'text': ['proselint'],
    \   'vim': ['vint']
    \}

    let g:ale_fixer = {
    \   'asm': ['remote_trailing_lines'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'latex': ['remove_trailing_lines','trim_whitespace'],
    \   'python': ['autopep8', 'isort'],
    \}

"====[ Open any file with a pre-existing swapfile in readonly mode "]=========
    augroup NoSimultaneousEdits
        autocmd!
        autocmd SwapExists * let v:swapchoice = 'o'
        autocmd SwapExists * echo 'Duplicate edit session (readonly)'
        autocmd SwapExists * echohl None
        autocmd SwapExists * sleep 1
    augroup END

"====[ Ctrl-P ]====
    nnoremap <Leader>fu :CtrlPFunky<Cr>
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_funky_syntax_highlight = 1

    "The Silver Searcher
    if executable('/usr/bin/ag')
        " Use ag over grep
        set grepprg=ag\ --nogroup\ --nocolor

        " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

        " ag is fast enough that CtrlP doesn't need to cache
        let g:ctrlp_use_caching = 0
    endif

"====[ TagList ]=====
    " let Tlist_Ctags_Cmd='/usr/bin/ctags'
    " let Tlist_GainFocus_On_ToggleOpen = 1
    " let Tlist_Close_On_Select = 1
    " let Tlist_Use_Right_Window = 1
    " let Tlist_File_Fold_Auto_Close = 1
    " " ToDo: Something like :TlistAddFilesRecursive {directory} [ {pattern} ]
    nmap <F7> :TagbarToggle<CR>

" "====[ VIM Exploit Development ]==
"
"     let g:exploit_copyright = "This file is part of the Raptor exploit pack and is subject\n# to redistribution and commercial restrictions."
"

"====[ Spell Checking ]===

    let b:myLang=0
    let g:myLangList=["nospell", "en_gb", "nl"]
    function! ToggleSpell()
        if !exists(b:myLang)
          let b:myLang=0
        endif
        let b:myLang=b:myLang+1
        if b:myLang>=len(g:myLangList)
            let b:myLang=0
        endif

        if b:myLang==0
            setlocal nospell
        else
            "execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
            execute "set spelllang=".get(g:myLangList, b:myLang)
        endif
        echo "spell checking language:" g:myLangList[b:myLang]
    endfunction

    map <leader>st :call ToggleSpell()<CR>
    map <leader>sn ]s
    map <leader>sp [s
    map <leader>sa zg
    map <leader>s? z=

"===[ GUI stuff ]===

    if has('gui_running')
        " Remove bloat
        set guioptions+=c  " Remove pop-ups and use console like stuff
        set guioptions-=T  " Remove Toolbar
        set guioptions+=m  " Remove menubar
        set guioptions-=r  " Remove right-scrollbar
        set guioptions-=L  " Remove left-scrollbar

        " " Todo; Make eays switcher
        " let font_choice_one = DejaVu\ Sans\ Mono\ 10
        " let font_choice_two = Hack\ Regular\ 10
        " " Maybe add Gohu?
        set guifont=Hack\ Regular\ 10

        let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
        let s:minfontsize = 6
        let s:maxfontsize = 64
        function! AdjustFontSize(amount)
            let fontname = substitute(&guifont, s:pattern, '\1', '')
            let cursize = substitute(&guifont, s:pattern, '\2', '')
            let newsize = cursize + a:amount
            if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
                let newfont = fontname . newsize
                let &guifont = newfont
            endif
        endfunction

        function! LargerFont()
          call AdjustFontSize(1)
        endfunction
        command! LargerFont call LargerFont()

        function! SmallerFont()
            call AdjustFontSize(-1)
        endfunction

        map <S-Up> :LargerFont<cr>
        map <S-Down> :SmallerFont<cr>

    endif

"====[ Compile YCM ]====
    function! CompileYouCompleteMe()
        !~/.vim/plugged/YouCompleteMe/install.py --clang-completer
    endfunction

"====[ Undo Tree ]===
    if has('persistent_undo')
        silent !mkdir -p ~/.vim/undodir/
        set undodir='~/.vim/undodir/'
        set undofile
    endif
    nnoremap <F5> :UndotreeToggle<cr>

"====[ File Type Settings ]===

    " This is what PEP8 wants.
    autocmd Filetype python set smartindent tabstop=4 shiftwidth=4 expandtab

    " This is for the C-Things..
    au FileType c,cpp nmap <buffer><silent>,lr <Plug>(clang_rename-current)
    autocmd Filetype c set smartindent tabstop=8 shiftwidth=8 noexpandtab
    autocmd Filetype cpp set smartindent tabstop=8 shiftwidth=8 noexpandtab
    autocmd Filetype asm set smartindent tabstop=8 shiftwidth=8 noexpandtab
    autocmd Filetype s set smartindent tabstop=8 shiftwidth=8 noexpandtab

    " Tex friendly
    autocmd Filetype tex set tabstop=2 softtabstop=2 shiftwidth=2 expandtab shiftround smarttab  spell spelllang=en_gb

"====[ Remaps ]===
    " Really annoying Ex-mode
    nnoremap Q <nop>

    " sudo Write
    cmap w!! %!sudo tee > /dev/null %

    " Easy paste
    if has("gui_running")
        map  <silent>  <S-Insert>  "+p
        imap <silent>  <S-Insert>  <Esc>"+pa
    endif

    " Visual Studio Header Body Switch (requires a.vim)
    inoremap <C-k><C-o> <Esc>:A<CR>
    noremap <C-k><C-o> <Esc>:A<CR>

"===[ Custom Functions ]===
    function! IsPasteMode()
        if &paste
            return '[PASTE MODE]'
        endif
        return ''
    endfunction

    if has("gui_running")
        function! ToggleMenuBar()
            let l:menu_option = strridx(&guioptions, "m")
            let l:toolbar_option = strridx(&guioptions, "T")
            if l:menu_option > 0
                set guioptions-=m
            else
                set guioptions+=m
            endif
            if l:toolbar_option > 0
                set guioptions-=T
            else
                set guioptions+=T
            endif
        endfunction

        command! ToggleMenu call ToggleMenuBar()
        map <F8> :ToggleMenu<CR>

        let g:font = 1
        function! ToggleFont()
            if g:font > 0
                let g:font = 0
                set guifont=DejaVu\ Sans\ Mono\ 10
            else
                let g:font = 1
                set guifont=DejaVu\ Sans\ Mono\ 16
            endif
        endfunction

         command! ToggleFont call ToggleFont()
         map <F4> :ToggleFont<CR>
     endif

"====[ Build and Run ]===
    let &makeprg = 'if [ -f Makefile ]; then make; else make -C build; fi'

    nmap <F10> :make<CR>
    imap <F10> :make<CR>
    imap <F12> terminal gdb -tui /bin/ls<CR>

"====[ From VIM-Sensible ]====
    set nrformats-=octal

    if &encoding ==# 'latin1' && has('gui_running')
        set encoding=utf-8
    endif

    if v:version > 703 || v:version == 703 && has("patch541")
        set formatoptions+=j " Delete comment character when joining commented lines
    endif

"====[ Propiatry Plugins ]====
    let g:propiatryplugs=expand('~/.vimsecret')

    if filereadable(g:propiatryplugs)
        source /home/robin/.vimsecret
    endif
