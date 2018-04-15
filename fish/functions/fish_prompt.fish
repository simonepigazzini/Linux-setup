function fish_prompt --description 'Write out the prompt'
    #Save the return status of the previous command
    set stat (math (ps | wc -l)-4)

    # Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_color_blue
        set -g __fish_color_blue (set_color -o blue)
    end

    if not set -q __fish_color_red
        set -g __fish_color_red (set_color -o red)
    end

    #Set the color for the status depending on the value
    set __fish_color_status (set_color -o green)
    if test $stat -gt 0
        set __fish_color_status (set_color -o red)
    end

    switch $USER

        case root toor

            if not set -q __fish_prompt_cwd
                if set -q fish_color_cwd_root
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
                else
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                end
            end

            printf '%s@%s %s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

        case '*'

            if not set -q __fish_prompt_cwd
                set -g __fish_prompt_cwd (set_color $fish_color_cwd)
            end

            if not set -q -g __fish_robbyrussell_functions_defined
                set -g __fish_robbyrussell_functions_defined
                function _git_branch_name
                    echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
                end

                function _is_git_dirty
                    echo (git status -s --ignore-submodules=dirty ^/dev/null)
                end

                function _is_git_repo
                    type -q git; or return 1
                    git status -s >/dev/null ^/dev/null
                end

                function _hg_branch_name
                    echo (hg branch ^/dev/null)
                end

                function _is_hg_dirty
                    echo (hg status -mard ^/dev/null)
                end

                function _is_hg_repo
                    type -q hg; or return 1
                    hg summary >/dev/null ^/dev/null
                end

                function _repo_branch_name
                    eval "_$argv[1]_branch_name"
                end

                function _is_repo_dirty
                    eval "_is_$argv[1]_dirty"
                end

                function _repo_type
                    if _is_hg_repo
                        echo 'hg'
                    else if _is_git_repo
                        echo 'git'
                    end
                end
            end

            set -l cyan (set_color -o cyan)
            set -l yellow (set_color -o yellow)
            set -l red (set_color -o red)
            set -l blue (set_color -o blue)
            set -l normal (set_color normal)

            set -l arrow "$red➜ "
            if [ $USER = 'root' ]
                set arrow "$red# "
            end

            set -l cwd $cyan(basename (prompt_pwd))

            set -l repo_type (_repo_type)
            if [ $repo_type ]
                set -l repo_branch $red(_repo_branch_name $repo_type)
                set repo_info "$blue $repo_type:($repo_branch$blue)"

                if [ (_is_repo_dirty $repo_type) ]
                    set -l dirty "$yellow ✗"
                    set repo_info "$repo_info$dirty"
                end
            end

            printf '[%s] %s%s@%s %s%s %s(%s)%s%s%s\f\r> ' (date "+%H:%M:%S") "$__fish_color_blue" "$USER" "$__fish_prompt_hostname" "$__fish_prompt_cwd" "$PWD" "$__fish_color_status" "$stat" "$__fish_prompt_normal" "$repo_info" "$normal"

    end
end



# function fish_prompt --description 'Write out the prompt'
# 	#Save the return status of the previous command
#     set stat (math (ps | wc -l)-4)

#     if not set -q __fish_prompt_normal
#         set -g __fish_prompt_normal (set_color normal)
#     end

#     if not set -q __fish_color_blue
#         set -g __fish_color_blue (set_color -o blue)
#     end

#     #Set the color for the status depending on the value
#     set __fish_color_status (set_color -o green)
#     if test $stat -gt 0
#         set __fish_color_status (set_color -o red)
#     end

#     switch "$USER"

#         case root toor

#             if not set -q __fish_prompt_cwd
#                 if set -q fish_color_cwd_root
#                     set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
#                 else
#                     set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#                 end
#             end

#             printf '%s@%s %s%s%s# ' $USER (prompt_hostname) "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

#         case '*'

#             if not set -q __fish_prompt_cwd
#                 set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#             end

#             printf '[%s] %s%s@%s %s%s %s(%s)%s \f\r> ' (date "+%H:%M:%S") "$__fish_color_blue" $USER (prompt_hostname) "$__fish_prompt_cwd" "$PWD" "$__fish_color_status" "$stat" "$__fish_prompt_normal"

#     end
# end
