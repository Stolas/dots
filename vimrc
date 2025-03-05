"*****
"**  Thank you Mister Conway, http://tinyurl.com/IBV2013
"**  Also I never forget the folks at http://www.vimbits.com/
"**  /r/vim gave me a number of tips.
"**  The newest tips came from Amir Salihefendic ( http://amix.dk/vim/vimrc.html )
"*****

"====[ Function Keys ]=======
"<F1>
"<F2>
"<F3>
"<F4>
"<F5> Undotree
"<F6>
"<F7> TagList
"<F8>
"<F9>
"<F10>
"<F11>
"<F12> Todo list


" Todo; Add ctags



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
    let iCanHazPlugz=1
    let plugsrc=expand('~/.vim/autoload/plug.vim')

    if !filereadable(plugsrc)
        let iCanHazPlugz=0
        if g:isunix==1
            silent !executable('curl') -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        else
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

        " Easy tabs completions
        Plug 'ervandew/supertab'

        " Better TagBar
        Plug 'majutsushi/tagbar'

        " Fixme list
        Plug 'vim-scripts/TaskList.vim'

        " Markdown Writing
        Plug 'gabrielelana/vim-markdown'

    " Bloat for other addons
        Plug 'tomtom/tlib_vim'
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'xolox/vim-misc'
        Plug 'roxma/nvim-yarp'

    " Language Specific
        " LSP Support
        Plug 'prabirshrestha/vim-lsp'

        " Snort Support
        Plug 'sploit/snort-vim'

        " Python Support
        Plug 'davidhalter/jedi-vim'

    call plug#end()
    let g:deoplete#enable_at_startup = 1 " Auto Complete
    filetype plugin indent on

    if v:version > 799
        packadd termdebug   " Terminal Debugger
    endif

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
    " color darkblue                " Pretty Colours

"====[ Language Servers ]=======
    if executable('clangd')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'alloclist': ['cpp', 'cc', 'h'],
                    \})
    endif
    function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
        let g:lsp_format_sync_timeout = 1000
        autocmd! BufWritePre *.cpp,*.cc,*.h call execute('LspDocumentFormatSync')
    endfunction
    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END

"====[ WildIgnore. ]============
    set wildignore =.*                " Ignore dot files
    set wildignore+=*.o,*.obj,*.pyc   " Ignore objects
    set wildignore+=.git,.hg.svn      " Ignore repos
    set wildignore+=*.png,*.jpg,*.gif " We don't need images in vim.

"====[ Make the status line do something useful. ]====================

    set statusline=%t\                              "tail of the filename
    " set statusline+=\ %{LinterStatus()}           "Syntax Error
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
       if !has('job')
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
    let colorcolumn=150
    hi ColorColumn guibg=#272727 ctermbg=0

"====[ Less Aggressive spell checking ]====================
     highlight clear SpellBad
     highlight SpellBad cterm=underline ctermfg=red
     highlight SpellBad gui=undercurl,bold

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
    exec "set listchars=tab:\uA6\\ ,trail:\uAF,nbsp:~"
    set list

"====[ Todo list ]====
    let g:tlTokenList = ['Todo', 'TODO', 'FixMe']
    let g:tlWindowPosition = 1
    map <F12> <Plug>TaskList

"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode " ]=
    nnoremap    v   <C-V>
    nnoremap <C-V>     v

    vnoremap    v   <C-V>
    vnoremap <C-V>     v

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
    if executable('ag')
        " Use ag over grep
        set grepprg=ag\ --nogroup\ --nocolor

        " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

        " ag is fast enough that CtrlP doesn't need to cache
        let g:ctrlp_use_caching = 0
    endif

"====[ TagList ]=====
    let g:tagbar_ctags_bin=executable('ctags')
    " let Tlist_Ctags_Cmd='/usr/bin/ctags'
    " let Tlist_GainFocus_On_ToggleOpen = 1
    " let Tlist_Close_On_Select = 1
    " let Tlist_Use_Right_Window = 1
    " let Tlist_File_Fold_Auto_Close = 1
    " " ToDo: Something like :TlistAddFilesRecursive {directory} [ {pattern} ]
    nmap <F7> :TagbarToggle<CR>

"====[ Spell Checking ]===

    let b:myLang=0
    let g:myLangList=["nospell", "en_US", "nl"]
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
        " Todo; remove items from menu
        set mousemodel=popup " Allow Modern mouse usage.
        set guioptions+=m  " Use menubar
        " set guioptions+=c  " Remove pop-ups and use console like stuff
        set guioptions-=T  " Remove Toolbar
        set guioptions-=r  " Remove right-scrollbar
        set guioptions-=L  " Remove left-scrollbar

        " let font_choice_one = DejaVu\ Sans\ Mono\ 10
        " let font_choice_two = Hack\ Regular\ 10
        " " Maybe add Gohu?
        set guifont=Hack\ Regular\ 10
        " set guifont=Hack:h12:cANSI:qDRAFT

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
        command! SmallerFont call SmallerFont()

        map <S-Up> :LargerFont<cr>
        map <S-Down> :SmallerFont<cr>
        " Todo; add scoll wheel support.

    endif

"====[ Compile YCM ]====
    function! CompileYouCompleteMe()
        !~/.vim/plugged/YouCompleteMe/install.py --clang-completer
    endfunction

"====[ Undo Tree ]===
    if has('persistent_undo')
        silent !mkdir -p ~/.vim/undodir/
        set undodir="~/.vim/undodir/"
    endif
    nnoremap <F5> :UndotreeToggle<cr>
    " Todo; test this again.

"====[ File Type Settings ]===

    " This is what PEP8 wants.
    autocmd Filetype python set smartindent tabstop=4 shiftwidth=4 expandtab

    " This is for the C-Things..
    autocmd Filetype c   set smartindent tabstop=4 shiftwidth=4 expandtab
    autocmd Filetype cpp set smartindent tabstop=4 shiftwidth=4 expandtab
    autocmd Filetype asm set smartindent tabstop=4 shiftwidth=4 expandtab
    autocmd Filetype s   set smartindent tabstop=4 shiftwidth=4 expandtab

    " Tex friendly
    autocmd Filetype tex set tabstop=2 softtabstop=2 shiftwidth=2 expandtab shiftround smarttab  spell spelllang=en_gb
    "autocmd FileType tex setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\s*%'

    " Research
    au! BufRead,BufNewFile *.markdown set filetype=mkd
    au! BufRead,BufNewFile *.md       set filetype=mkd syntax=markdown colorcolumn=125
    au! BufRead,BufNewFile *.snort    set syntax=hog
    autocmd Filetype md set tabstop=4 softtabstop=4 shiftwidth=3 shiftround smarttab spell spelllang=en_gb noshowmode noshowcmd scrolloff=999

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

"===[ Custom Functions ]===

    function! IsPasteMode()
        if &paste
            return '[PASTE MODE]'
        endif
        return ''
    endfunction


"====[ From VIM-Sensible ]====
    set nrformats-=octal

    if &encoding ==# 'latin1' && has('gui_running')
        set encoding=utf-8
    endif

    if v:version > 703 || v:version == 703 && has("patch541")
        set formatoptions+=j " Delete comment character when joining commented lines
    endif
