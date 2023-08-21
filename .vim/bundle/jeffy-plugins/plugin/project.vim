" File: project.vim
" Version: 0.3
"
" History:
" Author: Daniel Ni <tgni@triductor.com>
"  Support Java, Python, C, C++
" Author: Jeffy Du <jeffy.du@163.com>
" Version: 0.1
"
" Description:
" ------------
" This plugin provides a solution for creating project tags and cscope files.
" If you want to run this plugin in Win32 system, you need add the system-callings
" (ctags,cscope,find,grep,sort) to your system path. Usually, you can find these
" system-callings in Cygwin.
"
" Installation:
" -------------
" 1. Copy project.vim to one of the following directories:
"
"       $HOME/.vim/plugin    - Unix like systems
"       $VIM/vimfiles/plugin - MS-Windows
"
" 2. Start Vim on your project root path.
" 3. Use command ":ProjectCreate" to create project.
" 3. Use command ":ProjectLoad" to load project.
" 4. Use command ":ProjectUpdate" to update project.
" 5: Use command ":ProjectQuit" to quit project.

if exists('loaded_project')
        finish
endif
let loaded_project=1
if v:version < 700
        finish
endif

" Line continuation used here
let s:cpo_save = &cpo
let s:filetype = ''
set cpo&vim
" Global variables
if !exists('g:project_data')
        let g:project_data = ".project_vim"
endif

let s:HLUDCFlag = []
let s:HLUDCType = []

" HLUDLoad                      {{{1
" load user types
function! s:HLUDLoad(udtagfile)
        if filereadable(a:udtagfile)
		"let s:HLUDCType = split(system('rfex ' . a:udtagfile), ',', 1)
		let s:HLUDCType = readfile(a:udtagfile)
        endif
endfunction

" HLUDGetTags                   {{{1
" get tag data by tag flag
function! s:HLUDGetTags(flag)
	let idx = index(s:HLUDCFlag, a:flag)
	if idx != -1
		return s:HLUDCType[idx]
	endif
	return ' '
endfunction

" HLUDColor                     {{{1
" highlight tags data
function! s:HLUDColor()
	if (s:filetype == "c" || s:filetype == "c++")
		exec 'syn keyword cUserTypes ' . s:HLUDGetTags('t') . s:HLUDGetTags('u') .  s:HLUDGetTags('s') . s:HLUDGetTags('g') . s:HLUDGetTags('c')
		exec 'syn keyword cUserDefines ' . s:HLUDGetTags('d') . s:HLUDGetTags('e')
		exec 'syn keyword cUserFunctions ' . s:HLUDGetTags('f')
		exec 'syn keyword cUserVariables ' . s:HLUDGetTags('v') . s:HLUDGetTags('x')
		exec 'hi cUserTypes ctermfg=green guifg=green'
		exec 'hi cUserDefines ctermfg=blue guifg=blue'
		exec 'hi cUserFunctions ctermfg=red guifg=red'
		exec 'hi cUserVariables ctermfg=cyan guifg=cyan'
		exec 'hi cUserNamespace ctermfg=Magenta guifg=Magenta'
	elseif (s:filetype == "java")
		exec 'syn keyword UserClasses X_X_X ' . s:HLUDGetTags('c')
		exec 'syn keyword UserFields X_X_X ' . s:HLUDGetTags('f')
		exec 'syn keyword UserInterfaces X_X_X ' . s:HLUDGetTags('i')
		"exec 'syn keyword UserLocalVars X_X_X ' . s:HLUDGetTags('l')
		"exec 'syn keyword UserMethods X_X_X ' . s:HLUDGetTags('m')
		exec 'syn keyword UserPkgs X_X_X ' . s:HLUDGetTags('p')

		exec 'hi UserClasses ctermfg=green guifg=green'
		exec 'hi UserFields ctermfg=blue guifg=bule'
		exec 'hi UserInterfaces ctermfg=lightred guifg=lightred'
		"exec 'hi UserLocalVars ctermfg=white guifg=white'
		"exec 'hi UserMethods ctermfg=lightred guifg=lightred'
		exec 'hi UserPkgs ctermfg=Magenta guifg=Magenta'
	elseif (s:filetype == "python")
		exec 'syn keyword UserTypes X_X_X ' . s:HLUDGetTags('t') . s:HLUDGetTags('u') .  s:HLUDGetTags('s') . s:HLUDGetTags('g') . s:HLUDGetTags('c')
		exec 'syn keyword UserDefines X_X_X ' . s:HLUDGetTags('d') . s:HLUDGetTags('e')
		exec 'syn keyword UserFunctions X_X_X ' . s:HLUDGetTags('f') . s:HLUDGetTags('p') . s:HLUDGetTags('m')
		exec 'syn keyword UserVariables X_X_X ' . s:HLUDGetTags('v') . s:HLUDGetTags('x')
		exec 'syn keyword UserClasses X_X_X ' . s:HLUDGetTags('c')
		exec 'syn keyword UserNamespace X_X_X ' . s:HLUDGetTags('n')
		exec 'hi UserClasses ctermfg=green guifg=green'
		exec 'hi UserTypes ctermfg=green guifg=green'
		exec 'hi UserDefines ctermfg=blue guifg=blue'
		exec 'hi UserFunctions ctermfg=red guifg=red'
		exec 'hi UserNamespace ctermfg=Magenta guifg=Magenta'
	elseif (s:filetype == "matlab")
		"exec 'syn keyword UserFunctions X_X_X ' . s:HLUDGetTags('f')
		"exec 'hi UserFunctions ctermfg=red guifg=red'
	endif
endfunction

" WarnMsg                       {{{1
" display a warning message
function! s:WarnMsg(msg)
        echohl WarningMsg
        echon a:msg
        echohl None
endfunction
" }}}
" ProjectCreate                 {{{1
" create project data
"
function! s:ProjectCreate()
        " create project data directory.
        if !isdirectory(g:project_data)
                call mkdir(g:project_data, "p")
        endif

	let l:profile = g:project_data . '/profile'
	if !filereadable(l:profile)
		call system('filetype.sh >' . l:profile)
	endif

	let l:data=readfile(l:profile)
	let s:filetype=l:data[0]

        " create cscope.files 
	if (s:filetype == "c" || s:filetype == "c++")
		"call system('find '. getcwd() . ' -path ./make -prune -o -name "*.[chxsS]" -o -name "*.cpp" -o -name "*.cc" >' . g:project_data . "/cscope.files")
		call system('find '. getcwd() . ' -path ' . getcwd() . '/make ' . ' -prune -o -name "*.[chxsS]" -o -name "*.cpp" -o -name "*.cc" >' . g:project_data . "/cscope.files")
	elseif (s:filetype == "java")
		call system('find '. getcwd() . ' -name "*.java" >' . g:project_data . "/cscope.files")
	elseif (s:filetype == "python")
		call system('find '. getcwd() . ' -name "*.py" >' . g:project_data . "/cscope.files")
	elseif (s:filetype == "matlab")
		call system('find '. getcwd() . ' -name "*.m" >' . g:project_data . "/cscope.files")
	endif

        " create tags file
        if executable('ctags')
		"call system('ctags -R --c-kinds=+lpx --c++-kinds=+lpx --java-kinds=+l --fields=+iaS --extra=+q -o ' . g:project_data . '/tags ' . '-L ' . g:project_data . "/cscope.files")
		call system('ctags -R --fields=+iaS --extra=+q -o ' . g:project_data . '/tags ' . '-L ' . g:project_data . "/cscope.files")
        else
                call s:WarnMsg("command 'ctags' not exist.")
                return -1
        endif

        " create cscope file
        if executable('cscope')
                call system('cscope -i ' . g:project_data . "/cscope.files" . ' -bkq -f ' . g:project_data . "/cstags")
                "call system('cscope -bkqR -f ' . g:project_data . "/cstags")
        else
                call s:WarnMsg("command 'cscope' not exist.")
                return -1
        endif

	if executable('crudt')
		call system('crudt ' . s:filetype . ' ' . g:project_data . '/tags ' . g:project_data . '/udtags')
	endif

        echon "create project done, "

        call s:ProjectLoad()
        return 1
endfunction
" }}}
" ProjectLoad                   {{{1
" load project data
function! s:ProjectLoad()
        " find the project root directory.
        let l:proj_data = finddir(g:project_data, getcwd() . ',.;')
        if l:proj_data == ''
                return 1
        endif

	let l:profile = l:proj_data . '/profile'
	if filereadable(l:profile)
		let l:data = readfile(l:profile)
		let s:filetype = l:data[0]
	endif

        exe 'cd ' . l:proj_data . "/.."

	" change tags flags of java
	if (s:filetype == "java")
		let s:HLUDCFlag = ['c', 'f', 'i', 'l', 'm', 'p']
		let s:HLUDCType = [' ', ' ', ' ', ' ', ' ', ' ']
	elseif (s:filetype == "c" || s:filetype == "c++" || s:filetype == "python")
		let s:HLUDCFlag = ['c', 'd', 'e', 'f', 'g', 's', 't', 'u', 'v', 'x']
		let s:HLUDCType = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
	elseif (s:filetype == "matlab")
		let s:HLUDCFlag = ['f']
		let s:HLUDCType = [' ']
	endif

        " load tags.
	let &tags = l:proj_data . '/tags,' . &tags

        " load cscope.
        if filereadable(l:proj_data . '/cstags')
                set csto=1
                set cst
                set nocsverb
                exe 'cs add ' . l:proj_data . '/cstags'
                cs reset
                set csverb
        endif

	" color user defined.
	call s:HLUDLoad(l:proj_data . '/udtags')
	call s:HLUDColor()

	echon "load project done."
	return 1
endfunction
" }}}
" ProjectQuit                   {{{1
" quit project
function! s:ProjectQuit()
        " find the project root directory.
        let l:proj_data = finddir(g:project_data, getcwd() . ',.;')
        if l:proj_data == ''
                return
        endif

        " quit vim
        exe 'qa'
        return 1
endfunction

" }}}

command! -nargs=? -complete=file ProjectCreate call s:ProjectCreate()
command! -nargs=? -complete=file ProjectLoad call s:ProjectLoad()
command! -nargs=? -complete=file ProjectQuit call s:ProjectQuit()

aug Project
	au VimEnter * call s:ProjectLoad()
        au VimLeavePre * call s:ProjectQuit()
        au BufEnter,FileType c,cpp,java,python call s:HLUDColor()
aug END

nnoremap <leader>jc :ProjectCreate<cr>
nnoremap <leader>jl :ProjectLoad<cr>
nnoremap <leader>jq :ProjectQuit<cr>

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set foldenable foldmethod=marker:
