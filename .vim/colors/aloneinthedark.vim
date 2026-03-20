" Maintainer: slicklash@gmail.com

set background=dark

hi clear

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'aloneinthedark'

function! s:hi(group, fg, bg, gui)
    let l:hi = 'hi! ' . a:group
    if !empty(a:fg)
        let l:fg = type(a:fg) == v:t_string ? split(a:fg) : a:fg
        let l:hi .= ' guifg=' . l:fg[0] . ' ctermfg=' . l:fg[1]
    endif
    if !empty(a:bg)
        let l:bg = type(a:bg) == v:t_string ? split(a:bg) : a:bg
        let l:hi .= ' guibg=' . l:bg[0] . ' ctermbg=' . l:bg[1]
    endif
    let l:hi .= !empty(a:gui) ? ' gui=' . a:gui . ' cterm=' . a:gui : ''
    exec l:hi
endfunction

let s:color = map({
    \ 'FG'           : '#949494 246',
    \ 'BG'           : '#262626 235',
    \ 'BG_HIGHLIGHT' : '#303030 236',
    \ 'WHITE'        : '#cdcecf 252',
    \ 'BLACK'        : '#3a3a3a 237',
    \ 'GREY'         : '#626262 241',
    \ 'DARKGREY'     : '#4e4e4e 239',
    \ 'RED'          : '#bf616a 167',
    \ 'DARKRED'      : '#af5f5f 131',
    \ 'GREEN'        : '#a3be8c 107',
    \ 'BLUE'         : '#80a1c1 110',
    \ 'DARKBLUE'     : '#015faf 25',
    \ 'ORANGE'       : '#d79a5b 215',
    \ 'DARKORANGE'   : '#ac5e03 130',
    \ 'YELLOW'       : '#ebcb8b 227',
    \ 'PURPLE'       : '#b48dad 175',
    \ 'DARKPURPLE'   : '#af5f86 132',
    \ 'VIOLET'       : '#af87ff 141',
\ }, {key, val -> split(val)})

let s:SELECTION_BG        = s:color.DARKGREY
let s:LINENO_FG           = s:color.DARKGREY
let s:LINENO_BG           = s:color.BG
let s:STATUSLINE_FG       = s:color.FG
let s:STATUSLINE_NC_FG    = s:color.GREY
let s:CURSOR_LINE         = s:color.BG_HIGHLIGHT
let s:WINDOW_SEPARATOR_BG = s:color.BLACK
let s:FOLD_FG             = s:color.BG
let s:FOLD_BG             = s:color.GREY
let s:MATCHPAREN_FG       = s:color.WHITE
let s:MATCHPAREN_BG       = s:color.DARKPURPLE

let s:KEYWORD             = s:color.BLUE
let s:FUNCTION            = s:color.PURPLE
let s:ARG                 = s:color.ORANGE
let s:OPERATOR            = s:color.WHITE
let s:STRING              = s:color.GREEN
let s:CONSTANT            = s:color.YELLOW
let s:COMMENT             = s:color.GREY
let s:PREPROC             = s:color.RED
let s:TODO                = s:color.RED

call s:hi('Normal', s:color.FG, s:color.BG, 'none')
call s:hi('Visual', '', s:SELECTION_BG, '')

call s:hi('LineNr', s:LINENO_FG, s:LINENO_BG, '')
call s:hi('FoldColumn', s:FOLD_FG, s:LINENO_BG, '')
call s:hi('Folded', s:FOLD_FG, s:FOLD_BG, 'italic')
call s:hi('SignColumn', '', s:LINENO_BG, '')

call s:hi('Cursor', '', s:color.WHITE, '')
call s:hi('CursorLineNr', s:color.GREY, '', '')
call s:hi('CursorLine', '', s:CURSOR_LINE, 'none')
hi! link CursorColumn CursorLine
call s:hi('ColorColumn', '', s:CURSOR_LINE, 'none')

call s:hi('StatusLine', s:STATUSLINE_FG, s:WINDOW_SEPARATOR_BG, 'none')
call s:hi('StatusLineNC', s:STATUSLINE_NC_FG, s:WINDOW_SEPARATOR_BG, 'none')
call s:hi('VertSplit', s:WINDOW_SEPARATOR_BG, s:WINDOW_SEPARATOR_BG, 'none')
call s:hi('Pmenu', s:STATUSLINE_FG, s:color.BLACK, '')
call s:hi('PmenuSel', s:color.BLACK, s:color.WHITE, '')
hi! link WildMenu PmenuSel
hi! link QuickFixLine PmenuSel

call s:hi('MenuSel', '', s:color.BLACK, '')
call s:hi('MenuMatch', s:color.DARKPURPLE, '', '')

call s:hi('Search', s:color.RED, s:color.BG_HIGHLIGHT, 'underline')
call s:hi('IncSearch', s:color.BLACK, s:color.PURPLE, 'none')

call s:hi('MatchParen', s:MATCHPAREN_FG, s:MATCHPAREN_BG, '')
call s:hi('Special', s:color.WHITE, '', '')
call s:hi('SpecialKey', '#242424 255', s:color.BG, '')
call s:hi('ExtraWhiteSpace', s:color.WHITE, '#962634 131', 'none')

call s:hi('Error', '', '#962634 238', 'none')
call s:hi('ErrorMsg', '', '#962634 88', 'none')
call s:hi('ModeMsg', '#962634 168', '', '')
call s:hi('MoreMsg', '#53723C 255', '', '')
call s:hi('WarningMsg', '#E3A230 255', '', '')
call s:hi('Question', '#53723C 255', '', '')

call s:hi('DiffAdd', '#efefef 252', '#437019 22', '')
call s:hi('DiffDelete', '#bababa 8', '#700009 52', '')
call s:hi('DiffChange', '#efefef 252', '#2B5B77 24', '')
call s:hi('DiffText', '#000000 232', '#e09146 214', 'none')

call s:hi('TabLineFill', s:STATUSLINE_NC_FG, s:WINDOW_SEPARATOR_BG, 'none')
call s:hi('TabLine', 'red 242', 'red 236', 'none')
call s:hi('TabLineSel', s:color.FG, 'red 238', 'none')
call s:hi('TabSeparator', s:color.DARKGREY, 'red 236', 'none')

call s:hi('Directory', s:color.BLUE, '', '')
call s:hi('NonText', '#382920 59', s:color.BG, '')

" syntax highlighting {{{

call s:hi('User1', 'red 0', '#7f7f7f 248', '')
call s:hi('User2', 'green 65', '#1f1f21 237', 'none')
call s:hi('Keyword', s:KEYWORD, '', '')
call s:hi('Function', s:FUNCTION, '', 'none')
call s:hi('Arg', s:ARG, '', '')
call s:hi('Operator', s:OPERATOR, '', 'none')
call s:hi('String', s:STRING, '', 'none')
call s:hi('Constant', s:CONSTANT, '', 'none')
call s:hi('Comment', s:COMMENT, '', '')
call s:hi('PreProc', s:PREPROC, '', '')
call s:hi('Todo', s:TODO, s:color.BG, '')

" }}}

" choosewin {{{

let s:_ = str2nr(s:color.DARKGREY[1])

let g:choosewin_color_overlay = {
            \ 'cterm': [s:_, s:_]
            \ }

let s:_ = str2nr(s:color.WHITE[1])

let g:choosewin_color_overlay_current = {
            \ 'cterm': [s:_, s:_]
            \ }

" }}}

" lightline {{{

let s:status_fg = s:STATUSLINE_FG
let s:status_bg = s:WINDOW_SEPARATOR_BG

let s:dark_on_light = [s:status_bg[0], s:status_fg[0], s:status_bg[1], s:status_fg[1]]
let s:light_on_dark = [s:status_fg[0], s:status_bg[0], s:status_fg[1], s:status_bg[1]]

let s:mode_insert_bg = s:color.DARKBLUE
let s:mode_visual_bg = s:color.DARKORANGE
let s:mode_replace_bg = s:color.DARKRED

" [[guifg, guibg, ctermfg, ctermbg], ...]
let s:p = {
            \'normal':   {
                \'left':  [
                    \ s:light_on_dark,
                    \ s:dark_on_light],
                \'middle': [
                    \ s:light_on_dark],
                \'right': [
                    \ s:dark_on_light,
                    \ s:dark_on_light]
            \},
            \'inactive': {
                \'left': [
                    \ s:light_on_dark,
                    \ s:light_on_dark],
                \'middle': [
                    \ s:light_on_dark],
                \'right': [
                    \ s:light_on_dark,
                    \ s:light_on_dark],
            \},
            \ 'insert':   {
                \ 'left': [
                    \ [s:status_fg[0], s:mode_insert_bg[0], s:status_fg[1], s:mode_insert_bg[1]],
                    \ s:dark_on_light],
                \ 'middle': [
                    \ [s:status_fg[0], s:mode_insert_bg[0], s:status_fg[1], s:mode_insert_bg[1]]]
            \},
            \ 'replace':  {
                \ 'left': [
                    \ [s:status_bg[0], s:mode_replace_bg[0], s:status_bg[1], s:mode_replace_bg[1]],
                    \ s:dark_on_light],
                \ 'middle': [
                    \ [s:status_bg[0], s:mode_replace_bg[0], s:status_bg[1], s:mode_replace_bg[1]]]
            \},
            \ 'visual':   {
                \ 'left': [
                    \ [s:status_bg[0], s:mode_visual_bg[0], s:status_bg[1], s:mode_visual_bg[1]],
                    \ s:dark_on_light],
                \ 'middle': [
                    \ [s:status_bg[0], s:mode_visual_bg[0], s:status_bg[1], s:mode_visual_bg[1]]]
            \},
            \ 'tabline':  {
                \ 'left': [
                    \ s:light_on_dark],
                \ 'middle': [
                    \ s:light_on_dark],
                \ 'right': [
                    \ s:light_on_dark,
                    \ s:light_on_dark],
                \ 'tabsel': [
                    \ s:dark_on_light]
            \}}

let g:lightline#colorscheme#aloneinthedark#palette = s:p

" }}}

" less is more
hi! link Identifier     Keyword
hi! link Statement      Keyword
hi! link Conditional    Keyword
hi! link Repeat         Keyword
hi! link Exception      Keyword
hi! link Boolean        Keyword
hi! link Number         Constant
hi! link Title          Constant
hi! link Type           Keyword

hi! link helpExample    String

hi! link vimVar         Arg

hi! link htmlTagName    Keyword
hi! link htmlArg        Arg
hi! link htmlTag        Operator
hi! link htmlEndTag     Operator
hi! link htmlSpecialChar Constant

hi! link xmlTagName     Keyword
hi! link xmlAttrib      Arg
hi! link xmlTag         Operator
hi! link xmlEndTag      Operator
hi! link xmlNamespace   Number

hi! link javaIdentifier Normal

hi! link javaScriptFuncDef Function
hi! link javaScriptFuncExp Function
hi! link javaScriptFuncKeyword Keyword
hi! link javaScriptFuncArg Arg
hi! link javaScriptNull Keyword
hi! link javaScriptEventListenerMethods Keyword
hi! link javaScriptExceptions Exception
hi! link javaScriptBrowserObjects Normal
hi! link javaScriptDomElemAttrs Normal
hi! link javaScriptBraces Normal
hi! link javaScriptParens Normal
hi! link javaScriptEndColons Normal
hi! link javaScriptHtmlElemProperties Normal
hi! link javascriptSFunction Function
hi! link javascriptQData Function
hi! link javascriptQTraversing Function
hi! link javascriptAMFunctions Function
hi! link javascriptQAttributes Function
hi! link javascriptQAjax Function
hi! link javascriptQEvents Function
hi! link javascriptQManipulation Function
hi! link javascriptQUtilities Function
hi! link javascriptQEffects Function
hi! link javascriptQDimensions Function
hi! link javascriptQOffset Function
hi! link javascriptQCSS Function
hi! link javascriptQProperties Function
hi! link javascriptBEvents Function
hi! link javascriptBModel Function
hi! link javascriptBCollection Function
hi! link javascriptpFunction Function
hi! link javascriptjQuery Function
hi! link jsThis Keyword
hi! link jsPrototype Function
hi! link javascriptAwaitFuncKeyword Keyword
hi! link javascriptAsyncFuncKeyword Keyword
hi! link jsExportDefault PreProc
hi! link jsFuncArgs Arg
hi! link jsClassProperty Function
call s:hi('jsObjectKeyComputed', s:color.VIOLET, '', '')
call s:hi('jsObjectKey', s:color.DARKPURPLE, '', '')
hi! link jsDestructuringBlock jsObjectKey
hi! link jsSpreadExpression jsObjectKey
hi! link jsGlobalObjects Keyword
hi! link jsGlobalNodeObjects Keyword
hi! link jsTemplateBraces Keyword
hi! link jsFuncParens Keyword
hi! link jsParens Operator
hi! link jsSuper Keyword
hi! link jsBuiltins Keyword

hi! link typeScriptExceptions Exception
hi! link typeScriptEndColons Normal
hi! link typescriptFuncKeyword Keyword
hi! link typescriptReserved PreProc
hi! link typescriptImport PreProc
hi! link typescriptExport PreProc
hi! link typescriptArrayMethod Function
hi! link typescriptArrayStaticMethod Function
hi! link typescriptArrowFuncArg Arg
hi! link typescriptBOMHistoryMethod Function
hi! link typescriptBOMNavigatorMethod Function
hi! link typescriptBOMNavigatorProp Function
hi! link typescriptBOMWindowMethod Function
hi! link typescriptCacheMethod Function
hi! link typescriptCall Arg
hi! link typescriptConsoleMethod Function
hi! link typescriptDOMDocMethod Function
hi! link typescriptDOMEventMethod Function
hi! link typescriptDateMethod Function
hi! link typescriptDateStaticMethod Function
hi! link typescriptES6MapMethod Function
hi! link typescriptES6SetMethod Function
hi! link typescriptFuncTypeArrow Keyword
hi! link typescriptFunctionMethod Function
hi! link typescriptGeolocationMethod Function
hi! link typescriptGlobal Keyword
hi! link typescriptGlobalMethod Function
hi! link typescriptHeadersMethod Function
hi! link typescriptJSONStaticMethod Function
hi! link typescriptMathStaticMethod Function
hi! link typescriptNumberMethod Function
hi! link typescriptNumberStaticMethod Function
hi! link typescriptObjectMethod Function
hi! link typescriptObjectStaticMethod Function
hi! link typescriptPromiseMethod Function
hi! link typescriptPromiseStaticMethod Function
hi! link typescriptReflectMethod Function
hi! link typescriptRegExpMethod Function
hi! link typescriptSpecMethod Function
hi! link typescriptStringMethod Function
hi! link typescriptStringStaticMethod Function
hi! link typescriptTypeReference Function
call s:hi('typescriptPropertySignature', s:color.DARKPURPLE, '', '')
call s:hi('typescriptPredefinedType', s:color.GREY, '', '')
call s:hi('typescriptObjectLabel', s:color.DARKPURPLE, '', '')
call s:hi('typescriptComputedPropertyName', s:color.VIOLET, '', '')

hi! link cssClassName Normal
hi! link cssImportant PreProc
hi! link cssProp Keyword

hi! link pythonString String
hi! link pythonStatement Keyword
hi! link pythonBuiltin Keyword
hi! link pythonBuiltinFunc Keyword
hi! link pythonFunction Function
hi! link pythonNone Keyword

hi! link phpDefine Keyword
hi! link phpSpecialChar Function

hi! link vimFunction Function
hi! link vimUserFunc Function

syn keyword nimPreProc result import from
hi! link nimPreProc PreProc
hi! link nimBuiltin Keyword

syn keyword csharpSystemValueType Uri RegexOptions Regex ArgIterator Boolean Byte Char Currency DateTime Decimal Double Guid Int16 Int32 Int64 ParamArray RuntimeArgumentHandle RuntimeFieldHandle RuntimeMethodHandle RuntimeTypeHandle SByte Single TimeSpan TypedReference UInt16 UInt32 UInt64 Void
hi! link csharpSystemValueType Type

hi! link sqlKeyword Keyword
hi! link sqlSpecial Function

" ALE
hi ALEError ctermbg=52
hi! link ALEErrorSign Todo

" LSP
hi! link LspDiagInlineError ALEError
hi LspDiagInlineWarning ctermbg=235
hi LspDiagInlineHint ctermbg=235
hi LspDiagInlineInfo ctermbg=235

hi! link LspDiagSignErrorText Todo
hi! link LspDiagSignWarningText Number

" defx
call s:hi('defx_filename_directory', s:color.BLUE, '', '')
call s:hi('defx_icon_directory_icon', s:color.BLUE, '', '')

" Tagbar
call s:hi('TagbarSignature', s:color.GREY, '', '')
call s:hi('TagbarScope', s:color.PURPLE, '', '')
call s:hi('TagbarVisibilityPublic', s:color.GREEN, '', '')
call s:hi('TagbarVisibilityProtected', s:color.BLUE, '', '')
call s:hi('TagbarVisibilityPrivate', s:color.RED, '', '')

" pandoc
hi! link pandocStrong DiffChange

" fugitive

call s:hi('FugitivePath1', s:color.FG, '', '')
call s:hi('FugitivePath2', s:color.WHITE, '', '')
call s:hi('FugitivePath3', s:color.PURPLE, '', '')
call s:hi('FugitivePath4', s:color.BLUE, '', '')
call s:hi('FugitivePath5', s:color.ORANGE, '', '')
call s:hi('FugitivePath6', s:color.GREEN, '', '')
call s:hi('FugitivePath7', s:color.YELLOW, '', '')
call s:hi('FugitivePath8', s:color.VIOLET, '', '')
call s:hi('FugitivePath9', s:color.RED, '', '')

" delfunction s:hi

function! MyColorTest() abort
  " Open scratch buffer
  vnew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  setlocal filetype=mycolortest
  setlocal modifiable

  " Define test highlight groups
  call s:hi('TestFg',           s:color.FG,           s:color.BG, 'none')
  call s:hi('TestBg',           s:color.BG,           s:color.WHITE, 'none')
  call s:hi('TestBgHighlight',  s:color.BG_HIGHLIGHT, s:color.BG, 'none')
  call s:hi('TestWhite',        s:color.WHITE,        '', 'none')
  call s:hi('TestBlack',        s:color.BLACK,        '', 'none')
  call s:hi('TestGrey',         s:color.GREY,         '', 'none')
  call s:hi('TestDarkGrey',     s:color.DARKGREY,     '', 'none')
  call s:hi('TestRed',          s:color.RED,          '', 'none')
  call s:hi('TestDarkRed',      s:color.DARKRED,      '', 'none')
  call s:hi('TestGreen',        s:color.GREEN,        '', 'none')
  call s:hi('TestBlue',         s:color.BLUE,         '', 'none')
  call s:hi('TestDarkBlue',     s:color.DARKBLUE,     '', 'none')
  call s:hi('TestOrange',       s:color.ORANGE,       '', 'none')
  call s:hi('TestDarkOrange',   s:color.DARKORANGE,   '', 'none')
  call s:hi('TestYellow',       s:color.YELLOW,       '', 'none')
  call s:hi('TestPurple',       s:color.PURPLE,       '', 'none')
  call s:hi('TestDarkPurple',   s:color.DARKPURPLE,   '', 'none')
  call s:hi('TestViolet',       s:color.VIOLET,       '', 'none')

  call s:hi('TestKeyword',      s:KEYWORD,            '', 'none')
  call s:hi('TestFunction',     s:FUNCTION,           '', 'none')
  call s:hi('TestArg',          s:ARG,                '', 'none')
  call s:hi('TestOperator',     s:OPERATOR,           '', 'none')
  call s:hi('TestString',       s:STRING,             '', 'none')
  call s:hi('TestConstant',     s:CONSTANT,           '', 'none')
  call s:hi('TestComment',      s:COMMENT,            '', 'italic')
  call s:hi('TestPreProc',      s:PREPROC,            '', 'none')
  call s:hi('TestTodo',         s:TODO,               '', 'bold')

  " Clear and define syntax for this buffer
  syntax clear

  " Literal color names
  syntax keyword TestFg          FG
  syntax keyword TestBg          BG
  syntax keyword TestBgHighlight BG_HIGHLIGHT
  syntax keyword TestWhite       WHITE
  syntax keyword TestBlack       BLACK
  syntax keyword TestGrey        GREY
  syntax keyword TestDarkGrey    DARKGREY
  syntax keyword TestRed         RED
  syntax keyword TestDarkRed     DARKRED
  syntax keyword TestGreen       GREEN
  syntax keyword TestBlue        BLUE
  syntax keyword TestDarkBlue    DARKBLUE
  syntax keyword TestOrange      ORANGE
  syntax keyword TestDarkOrange  DARKORANGE
  syntax keyword TestYellow      YELLOW
  syntax keyword TestPurple      PURPLE
  syntax keyword TestDarkPurple  DARKPURPLE
  syntax keyword TestViolet      VIOLET

  " Semantic examples
  syntax keyword TestKeyword  let const if else return func
  syntax match   TestFunction /\<[A-Z][A-Za-z0-9_]*\ze(/
  syntax match   TestArg      /\<arg[0-9_]*\>/
  syntax match   TestOperator /[-+*=<>!|&\/]\+/
  syntax region  TestString   start=/"/ skip=/\\"/ end=/"/
  syntax match   TestConstant /\<\d\+\>\|\<true\|false\|nil\>/
  syntax match   TestComment  /#.*/
  syntax match   TestPreProc  /^\s*#\w\+/
  syntax keyword TestTodo     TODO FIXME XXX

  call setline(1, [
        \ '=== palette ===',
        \ 'FG',
        \ 'BG',
        \ 'BG_HIGHLIGHT',
        \ 'WHITE',
        \ 'BLACK',
        \ 'GREY',
        \ 'DARKGREY',
        \ 'RED',
        \ 'DARKRED',
        \ 'GREEN',
        \ 'BLUE',
        \ 'DARKBLUE',
        \ 'ORANGE',
        \ 'DARKORANGE',
        \ 'YELLOW',
        \ 'PURPLE',
        \ 'DARKPURPLE',
        \ 'VIOLET',
        \ '',
        \ '=== semantic ===',
        \ '#define MAX 10',
        \ 'func MyFunc(arg1, arg2) {',
        \ '  # comment',
        \ '  let x = 42',
        \ '  let s = "hello"',
        \ '  if x > 0 && true {',
        \ '    TODO fix this',
        \ '    return MyFunc(arg1 + arg2)',
        \ '  }',
        \ '}',
        \ '',
        \ '=== raw semantic names ===',
        \ 'KEYWORD FUNCTION ARG OPERATOR STRING CONSTANT COMMENT PREPROC TODO',
        \ ])

  " Highlight raw semantic names too
  syntax keyword TestKeyword  KEYWORD
  syntax keyword TestFunction FUNCTION
  syntax keyword TestArg      ARG
  syntax keyword TestOperator OPERATOR
  syntax keyword TestString   STRING
  syntax keyword TestConstant CONSTANT
  syntax keyword TestComment  COMMENT
  syntax keyword TestPreProc  PREPROC
  syntax keyword TestTodo     TODO

  setlocal nomodifiable
  normal! gg
endfunction
