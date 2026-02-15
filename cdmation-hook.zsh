# cdmation zsh hook: run configured automation when entering a tracked directory.

: "${CDMATION_HOME:=$HOME/.cdmation}"
: "${CDMATION_AUTOMATIONS_FILE:=$CDMATION_HOME/automations.tsv}"

typeset -g __cdmation_current_root=""
typeset -g __cdmation_running=0

_cdmation_is_inside() {
  local dir="$1"
  local root="$2"
  [[ "$dir" == "$root" || "$dir" == "$root"/* ]]
}

_cdmation_match_current_pwd() {
  local pwd_real="$1"
  local best_name=""
  local best_root=""
  local best_script=""

  [[ -f "$CDMATION_AUTOMATIONS_FILE" ]] || return 1

  local name root script
  while IFS=$'\t' read -r name root script; do
    [[ -n "$name" && -n "$root" && -n "$script" ]] || continue

    if _cdmation_is_inside "$pwd_real" "$root"; then
      if (( ${#root} > ${#best_root} )); then
        best_name="$name"
        best_root="$root"
        best_script="$script"
      fi
    fi
  done < "$CDMATION_AUTOMATIONS_FILE"

  [[ -n "$best_root" ]] || return 1
  print -- "$best_name\t$best_root\t$best_script"
}

_cdmation_on_chpwd() {
  (( __cdmation_running )) && return 0

  local pwd_real
  pwd_real="$(pwd -P)"

  if [[ -n "$__cdmation_current_root" ]] && _cdmation_is_inside "$pwd_real" "$__cdmation_current_root"; then
    return 0
  fi

  __cdmation_current_root=""

  local record name root script
  record="$(_cdmation_match_current_pwd "$pwd_real")" || return 0
  IFS=$'\t' read -r name root script <<< "$record"

  [[ -x "$script" ]] || {
    print -u2 -- "[cdmation] script missing or not executable for '$name': $script"
    __cdmation_current_root="$root"
    return 0
  }

  print -- "[cdmation] running '$name'"
  __cdmation_running=1
  zsh "$script"
  local exit_code=$?
  __cdmation_running=0

  if (( exit_code != 0 )); then
    print -u2 -- "[cdmation] '$name' exited with $exit_code"
  fi

  __cdmation_current_root="$root"
}

if [[ -n "${ZSH_VERSION:-}" ]]; then
  autoload -Uz add-zsh-hook

  if (( ${chpwd_functions[(I)_cdmation_on_chpwd]:-0} == 0 )); then
    add-zsh-hook chpwd _cdmation_on_chpwd
  fi

  _cdmation_on_chpwd
fi
