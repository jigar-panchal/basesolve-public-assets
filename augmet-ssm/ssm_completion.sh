#!/bin/bash

# Bash completion script for the ssm command

_ssm_completions() {
    local cur prev opts config_file aliases

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--help --version --alias --target --aws-profile --region --orole-arn"

    config_file="$HOME/.ssm/config"
    aliases=""

    # Dynamically collect aliases from the config file
    if [[ -f "$config_file" ]]; then
        aliases=$(grep -oP '^host\s+\K[a-zA-Z0-9._-]+' "$config_file")
    fi

    # Provide completions
    case "$prev" in
        -a|--alias)
            COMPREPLY=( $(compgen -W "$aliases" -- "$cur") )
            return 0
            ;;
        -p|--aws-profile)
            COMPREPLY=( $(compgen -W "$(aws configure list-profiles)" -- "$cur") )
            return 0
            ;;
        -r|--region)
            COMPREPLY=( $(compgen -W "us-east-1 us-west-2 eu-west-1" -- "$cur") )
            return 0
            ;;
        *)
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;
    esac
}

complete -F _ssm_completions ssm

