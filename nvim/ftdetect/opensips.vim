" Vim filetype detection file
" Language: OpenSIPS configuration

" Detect by extension
au BufNewFile,BufRead *.cfg call s:CheckOpenSIPS()
au BufNewFile,BufRead *.opensips set filetype=opensips
au BufNewFile,BufRead opensips.cfg set filetype=opensips
au BufNewFile,BufRead */opensips/*.cfg set filetype=opensips

" Check content for OpenSIPS-specific patterns
function! s:CheckOpenSIPS()
  let l:max_lines = min([line("$"), 50])
  for l:n in range(1, l:max_lines)
    let l:line = getline(l:n)
    " Check for OpenSIPS-specific patterns
    if l:line =~ '\v^\s*(loadmodule|modparam|route\[|mpath|listen|socket)'
      set filetype=opensips
      return
    endif
    if l:line =~ '\v^\s*(branch_route|failure_route|onreply_route|error_route)'
      set filetype=opensips
      return
    endif
    if l:line =~ '\v\$[a-zA-Z_]+\('
      set filetype=opensips
      return
    endif
  endfor
endfunction
