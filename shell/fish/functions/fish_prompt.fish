function fish_prompt
    set_color --bold brblack
    echo -n (prompt_pwd)
    echo ""
    set_color normal
    echo -n '> '
    set_color green
    echo -n '$ '
    set_color normal
end
