" Vim color file
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

let s:candle_light = strftime('%H') > 23 || strftime('%H') < 8 ? 1 : 0

let s:color = map({
    \ 'FG'           : '#949494 246',
    \ 'BG'           : '#262626 235',
    \ 'BG_HIGHLIGHT' : '#2f2e2d 236',
    \ 'WHITE'        : '#bababa 252',
    \ 'BLACK'        : '#3a3a3a 237',
    \ 'GREY'         : '#606060 241',
    \ 'DARKGREY'     : '#383E42 239',
    \ 'RED'          : '#d75f5f 167',
    \ 'DARKRED'      : '#af5f5f 131',
    \ 'GREEN'        : '#99ad6a 107',
    \ 'BLUE'         : '#77add2 110',
    \ 'DARKBLUE'     : '#005F87 25',
    \ 'ORANGE'       : '#e09146 215',
    \ 'DARKORANGE'   : '#af5f00 130',
    \ 'YELLOW'       : '#f8fa83 227',
    \ 'PURPLE'       : '#ca729e 175',
    \ 'DARKPURPLE'   : '#8c3561 132',
    \ 'VIOLET'       : '#bd78af 141',
\ }, {key, val -> split(val)})


if s:candle_light == 1
    " let s:FG = '#808080 245'
    " let s:BG = '#121212 233'
    " let s:BLUE = '#618eb0 67'
    " let s:WHITE = '#bababa 251'
    " let s:ORANGE = '#E3A230 179'
    " let s:YELLOW = '#f8fa83 185'
    " let s:PURPLE = '#896492 139'
    " let s:GREEN = '#53723C 65'
    " let s:RED = '#b14646 167'
    " let s:DARKGREY = '#404040 238'
    "
    " let s:LINENO_FG = '#242424 237'
    " let s:LINENO_BG = s:color.BG
    " let s:STATUSLINE_FG = '#646464 244'
    " let s:STATUSLINE_NC_FG = '#4a4a4a 239'
    " let s:FOLD_FG = '#5e6b79 234'
    " let s:FOLD_BG = '#384048 239'
    " let s:MATCHPAREN_FG = '#bababa 253'
    " let s:MATCHPAREN_BG = '#8c3561 132'
    " let s:WINDOW_SEPARATOR_BG = '#262626 235'
    " let s:CURSOR_LINE = '#2f2e2d 234'
    "
    " call s:hi('Error', '', '#962634 238', 'none')
    " call s:hi('ErrorMsg', s:color.WHITE, '#962634 52', 'none')
    " call s:hi('ModeMsg', 'red 1', '', '')
    " call s:hi('MoreMsg', '#53723C 255', '', '')
    " call s:hi('WarningMsg', '#E3A230 255', '', '')
    " call s:hi('Question', '#53723C 255', '', '')
endif

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
" call s:hi('WildMenu', s:color.BLACK, s:color.WHITE, '')
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

" LanguageClient
hi LanguageClientError ctermbg=52
hi! link LanguageClientErrorSign Todo
hi! link LanguageClientWarningSign Number
hi! clear LanguageClientWarning

hi ALEError ctermbg=52
hi! link ALEErrorSign Todo

" sneak
hi! link Sneak Search
hi! link SneakCurrent CurSearch

" defx
call s:hi('Defx_filename_3_directory', s:color.BLUE, '', '')
call s:hi('Defx_filename_3_directory_icon', s:color.BLUE, '', '')
call s:hi('Defx_mark_3_directory', s:color.BLUE, '', '')
call s:hi('Defx_filename', s:color.BLUE, '', '')

" Tagbar
call s:hi('TagbarSignature', s:color.GREY, '', '')
call s:hi('TagbarScope', s:color.PURPLE, '', '')
call s:hi('TagbarVisibilityPublic', s:color.GREEN, '', '')
call s:hi('TagbarVisibilityProtected', s:color.BLUE, '', '')
call s:hi('TagbarVisibilityPrivate', s:color.RED, '', '')

" pandoc
hi! link pandocStrong DiffChange

" lsp
highlight LspDiagInlineError ctermbg=88

delfunction s:hi
