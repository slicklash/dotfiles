vim9script

var cache: list<string> = []
var cached_at = reltime()

def g:TmuxWords(): list<string>
  if empty($TMUX)
    return []
  endif
  if !empty(cache) && reltimefloat(reltime(cached_at)) < 2.0
    return cache
  endif

  var lines = systemlist("tmux list-panes -a -F '#{pane_id}' | grep -vxF " .. shellescape($TMUX_PANE)
        \ .. ' | xargs -n1 tmux capture-pane -p -J -t')
  if v:shell_error != 0
    return []
  endif

  var seen: dict<number> = {}
  for line in lines
    for token in split(line)
      var word = matchstr(token, '\w.*\w')
      if !empty(word)
        seen[word] = 1
      endif
    endfor
    for word in split(line, '\W\+')
      if strlen(word) > 1
        seen[word] = 1
      endif
    endfor
  endfor

  cache = sort(keys(seen))
  cached_at = reltime()
  return cache
enddef
