" Vim syntax file
" Language:	SaC
" Maintainer:	Artem Shinkarov <artyom.shinkaroff@gmail.com>
" Last Change:	2010 Dec 01

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn keyword	sacStatement	return step width
syn keyword	sacConditional	if else switch
syn keyword	sacRepeat	while for do with
syn keyword     sacBoolean      true false
syn keyword     sacStatement    module import export provide
syn keyword     sacStatement    use all except depecated
syn keyword     sacStatement    objdef

syn keyword	sacTodo		contained TODO FIXME XXX

syn cluster     sacGrKw         contains=sacStatement,sacConditional,
                                \ sacRepeat,sacBoolean,sacWlModify,
                                \ sacStructure,
                                \ sacStorageClass,sacOperator,sacType

syn cluster     sacGrCst        contains=sacString,sacCharacter,sacNumbers

syn cluster     sacGrStruct     contains=sacBlock,sacParen,sacBracket

syn cluster     sacGrPrep       contains=sacPreCondit,sacPreProc,sacDefine,
                                \ sacInclude,sacCppOut

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	sacSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match	sacSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
" TODO check the format we use in SaC
syn match	sacFormat	display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match	sacFormat	display "%%" contained
syn region	sacString	start=+"+ skip=+\\\\\|\\"+ end=+"+ 
                                \ contains=sacSpecial,sacFormat,@Spell

" If we want we can add support for special characters like '\xff'
syn match       sacCharacter	"'[^\\]'"
syn match	sacCharacter	"'[^']*'" contains=sacSpecial

" Numbers
syn case ignore
syn cluster     sacNum          contains=sacNumber,sacReal,sacOctal 
syn match	sacNumbers	display transparent "\<\d\|\.\d" contains=@sacNum
syn match	sacNumbersCom	display contained transparent 
                                \ "\<\d\|\.\d" contains=@sacNum
syn match	sacNumber	display contained "\d\+\(u\=[bsil]\|u\=ll\)\=\>"
" hex number
" FIXME we cannot currently have hex number with u?(b|s|i|u|l|ll)
" 0x[0-9a-f]* (b|s|i|l|ll)? 
syn match	sacNumber	display contained "0x\x\+\>"

" Flag the first zero of an octal number as something special
" FIXME Again we cannot have postfix in octal numbers
syn match	sacOctal	display contained "0\o\+\>" contains=sacOctalZero
syn match	sacOctalZero	display contained "\<0"
syn match	sacReal		display contained "\d\+[fd]"
" floating point number, with dot, optional exponent
syn match	sacReal	        display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fd]\="
" floating point number, starting with a dot, optional exponent
syn match	sacReal 	display contained "\.\d\+\(e[-+]\=\d\+\)\=[fd]\=\>"
"floating point number, without dot, with exponent
syn match	sacReal		display contained "\d\+e[-+]\=\d\+[fd]\=\>"
syn case match

" With loop modifiers
syn match       sacWlModify     /:\s*modarray/ 
syn match       sacWlModify     /:\s*genarray\>/ 
syn match       sacWlModify     /:\s*fold\(fix\)\=/ 
syn match       sacWlModify     /:\s*propagate/ 

" Fold written without : is most likely an error
syn match       sacModifyErr    /\<fold\(fix\)\=\>/
syn match       sacModifyErr    /\<propagate>/

syn region	sacBlock	start="{" end="}" transparent fold
"                                \ contains=@sacGrPerp,sacComment

" Wrong parenthesis and bracket errors
syn region      sacParen        transparent start="(" end=")"
                                \ contains=@sacGrKw,@sacGrCst,@sacGrStruct,
                                \ @sacGrPrep,sacComment,sacErrInParen,sacRexpDot
                    
syn match       sacParenError   display /[\])]/
syn match       sacErrInParen   display contained "[\]]\|<%\|%>"
syn region	sacBracket	transparent start='\[\|<::\@!' end=']\|:>' 
                                \ contains=@sacGrKw,@sacGrConst,@sacGrStruct,
                                \ @sacGrPrep,sacComment,sacErrInBracket,
                                \ sacRexpPlusStar,sacRexpDot

syn match	sacErrInBracket	display contained "[);{}]\|<%\|%>"

syn match       sacRexpDot      display contained /\./
syn match       sacRexpPlusStar display contained /+\|\*/

" Comments
syn match	sacCommentSkip	    contained "^\s*\*\($\|\s\+\)"
syn region      sacCommentString    contained start=+\\\@<!"+ 
                                    \ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 
                                    \ contains=sacSpecial,sacCommentSkip
syn region      sacComment2String   contained start=+\\\@<!"+ 
                                    \ skip=+\\\\\|\\"+ end=+"+ end="$" 
                                    \ contains=sacSpecial
" FIXME Currently we do not have line comments support
"syn region      sacCommentL	    start="//" skip="\\$" end="$" 
"                                    \ keepend contains=sacTodo,
"                                    \ sacComment2String,sacCharacter,
"                                    \sacNumbersCom,
"                                    \ sacSpaceError,@Spell
syn region      sacComment	    matchgroup=sacCommentStart start="/\*" 
                                    \ end="\*/" contains=sacTodo,
                                    \ sacCommentStartError,sacCommentString,
                                    \ sacCharacter,sacNumbersCom,
                                    \ @Spell fold extend

syn match       sacCommentError      display "\*/"
syn match       sacCommentStartError display "/\*"me=e-1 contained


" Accept %: for # (C99)
syn region      sacCppString	
        \ start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl 
        \ end=+"+ end='$' contains=sacSpecial,sacFormat,@Spell

syn region	sacPreCondit	
        \ start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$"
        \ contains=sacComment,sacCppString,sacCharacter,sacParen,
        \ sacParenError,sacNumbers,sacCommentError

syn match	sacPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"

syn region	sacIncluded	
        \ display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	sacIncluded	display contained "<[^>]*>"
syn match	sacInclude	
        \ display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=sacIncluded

syn region	sacDefine	
        \ start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" 
        \ end="$" keepend contains=@sacGrKw,sacComment 
syn region	sacPreProc	
        \ start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)"
        \ skip="\\$" end="$" keepend 


" Type-related definitions
syn keyword     sacStructure    typedef classtype class
syn keyword     sacStorageClass external inline

" SaC types
syn keyword     sacType         float bool unsigned byte short int
syn keyword     sacType         long longlong ubyte ushort uint ulong
syn keyword     sacType         ulonglong char double void
 
" SaC primitive functions
syn keyword     sacOperator     _dim_A_ _shape_A_ _reshape_VxA_ 
syn keyword     sacOperator     _sel_VxA_ _modarray_AxVxS_
syn keyword     sacOperator     _hideValue_SxA_ _hideShape_SxA_ _hideDim_SxA_   
syn keyword     sacOperator     _cat_VxV_ _take_SxV_ _drop_SxV_ _add_SxS_ 
syn keyword     sacOperator     _add_SxV_ _add_VxS_ _add_VxV_ _sub_SxS_ 
syn keyword     sacOperator     _sub_SxV_ _sub_VxS_ _sub_VxV_ _mul_SxS_
syn keyword     sacOperator     _mul_SxV_ _mul_VxS_ _mul_VxV_ _div_SxS_
syn keyword     sacOperator     _div_SxV_ _div_VxS_ _div_VxV_ _mod_SxS_
syn keyword     sacOperator     _mod_SxV_ _mod_VxS_ _mod_VxV_ _min_SxS_       
syn keyword     sacOperator     _min_SxV_ _min_VxS_ _min_VxV_ _max_SxS_ 
syn keyword     sacOperator     _max_SxV_ _max_VxS_ _max_VxV_ _abs_S_
syn keyword     sacOperator     _abs_V_ _neg_S_ _neg_V_ _reciproc_S_ _reciproc_V_
syn keyword     sacOperator     _mesh_VxVxV_    
syn keyword     sacOperator     _eq_SxS_ _eq_SxV_ _eq_VxS_ _eq_VxV_ 
syn keyword     sacOperator     _neq_SxS_ _neq_SxV_ _neq_VxS_ _neq_VxV_
syn keyword     sacOperator     _le_SxS_ _le_SxV_ _le_VxS_ _le_VxV_
syn keyword     sacOperator     _lt_SxS_ _lt_SxV_ _lt_VxS_ _lt_VxV_ 
syn keyword     sacOperator     _ge_SxS_ _ge_SxV_ _ge_VxS_ _ge_VxV_
syn keyword     sacOperator     _gt_SxS_ _gt_SxV_ _gt_VxS_ _gt_VxV_
syn keyword     sacOperator     _and_SxS_ _and_SxV_ _and_VxS_ _and_VxV_
syn keyword     sacOperator     _or_SxS_ _or_SxV_ _or_VxS_ _or_VxV_
syn keyword     sacOperator     _not_S_ _not_V_ 
syn keyword     sacOperator     _tob_S_ _tos_S_ _toi_S_ _tol_S_ _toll_S_
syn keyword     sacOperator     _toub_S_ _tous_S_ _toui_S_ _toul_S_ _toull_S_
syn keyword     sacOperator     _tof_S_ _tod_S_ _toc_S_ _tobool_S_  


hi def link     sacStatement        Statement
hi def link     sacRepeat           Repeat
hi def link     sacConditional      Conditional
hi def link     sacOperator         Operator
hi def link     sacSpecial          SpecialChar
hi def link     sacString           String
hi def link     sacCharacter        Character
hi def link     sacTodo             Todo
hi def link     sacType             Type
hi def link     sacBoolean          Boolean
hi def link     sacOctalZero        PreProc
hi def link     sacNumber           Number
hi def link     sacOctal            Number
hi def link     sacReal             Float
hi def link     sacStructure        Structure
hi def link     sacStorageClass     StorageClass
hi def link     sacWlModify         Operator
hi def link     sacWith             Repeat
hi def link     sacGeneratorDot     Statement
hi def link     sacWithLoop         Error
hi def link     sacModifyErr        Error
hi def link     sacParenError       Error
hi def link     sacErrInParen       Error
hi def link     sacErrInBracket     Error
hi def link     sacRexpDot          Operator
hi def link     sacRexpPlusStar     Operator
hi def link     sacComment          Comment
hi def link     sacCommentStart     Comment
hi def link     sacCommentError     Error
hi def link     sacCommentString    String
hi def link     sacCommentString2   String
hi def link     sacPreCondit        PreCondit
hi def link     sacPreProc          PreProc
hi def link     sacDefine           Macro
hi def link     sacInclude          String
hi def link     sacCppSkip          Comment
hi def link     sacCppOut           Comment
hi def link     sacCppOut2          Comment
hi def link     sacIncluded         String

let b:current_syntax = "sac"
