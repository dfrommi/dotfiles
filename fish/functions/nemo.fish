function nemo -a cmd
    set -e argv[1]

    switch $cmd
        case "init"
            __nemo_init $argv
        case "sync"
            __nemo_sync $argv
        case "reset"
            __nemo_reset $argv
        case '*':
            echo "ERROR: command '$cmd' unknown"
            return 1
    end
end

function __nemo_fish_config_path; echo "$HOME/.config/fish"; end
function __nemo_base_path; echo "$nemo_base_path"; end

function __nemo_package_target_dir -a package
    echo (__nemo_base_path)/(string replace "/" "-" "$package")
end

function __nemo_init -a base_path
    if [ -z "$base_path" ]
        echo "ERROR: base path missing"
        return 1
    end

    set -g nemo_base_path $base_path
    __nemo_update_fish_config
end

function __nemo_update_fish_config
    set -l base_path (__nemo_base_path)

    for func in (find "$base_path" -type d -name functions 2>/dev/null)
        if not contains $func $fish_function_path
            set fish_function_path $func $fish_function_path
        end
    end

    for completion in (find "$base_path" -type d -name completions 2>/dev/null)
        if not contains $completion $fish_complete_path
            set fish_complete_path $completion $fish_complete_path
        end
    end

    for file in (find "$base_path" -path "*/conf.d/*.fish" -type f 2>/dev/null)
        builtin source $file 2> /dev/null
    end
end

function __nemo_dependencies
    set -l fishfiles (find (__nemo_fish_config_path) (__nemo_base_path) -type f -name fishfile 2>/dev/null)

    if [ (count $fishfiles) -gt 0 ]
        for f in $fishfiles; cat $f; echo; end | sort -u | sed '/./,$!d'
    end
end

function __nemo_install_package -a package
    set -l target_dir (__nemo_package_target_dir $package)

    test -d "$target_dir"; and rm -r "$target_dir"

    mkdir -p "$target_dir"
    curl -sL "https://api.github.com/repos/$package/tarball" | tar xz --strip=1 -C "$target_dir"

    if test $status -ne 0
        echo "ERROR: Installation of $package failed"
        rm -r "$target_dir"
        return 1
    end

    set -l top_level_functions (find "$target_dir" -maxdepth 1 -type f -name "*.fish" 2>/dev/null)
    if [ -n "$top_level_functions" ]
        mkdir -p "$target_dir/functions"
        mv $top_level_functions "$target_dir/functions"
    end

    return 0
end

function __nemo_sync
    while true
        set -l packages (__nemo_dependencies)
        set -l new_installations 0

        for package in $packages
            [ -d (__nemo_package_target_dir $package) ]; and continue

            echo "installing $package"
            __nemo_install_package "$package"

            if test $status -ne 0
                echo "ERROR: couldn't install $package"
                return 1
            end

            set new_installations (math $new_installations + 1)
        end

        [ $new_installations -eq 0 ]; and break
    end

    __nemo_update_fish_config

    return 0
end

function __nemo_reset -d "reinstall all dependencies"
    rm -rf (__nemo_deps_base_dir); and nemo sync
    return $status
end
