color="white"
if [ "$USER" = "root" ]; then
  color="red"
fi;

setopt prompt_subst
PROMPT='%B%F{blue}%~ %b%F{green}$(git_info) %B%F{yellow}$(git_modified_sign)%f%k%b
%F{$color}%# %b%f'
