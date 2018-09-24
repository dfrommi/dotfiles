function aws_assume_role -d "interactive AWS assume role"
    cat ~/.aws/config | read -z awsConfig

    echo "$awsConfig" | grep -e '^\[profile .*\]' | cut -d ' ' -f 2 | cut -d ']' -f 1 | fzf | read profile
    if [ ! "$profile" ]
        return 1
    end

    echo "Assuming role for profile '$profile'"

    # Get config section of selected profile
    echo "$awsConfig" | sed -e "1,/\[profile $profile\]/d" | sed -e '/\[/,$d' | read -z profileConfig
    
    set role (echo "$profileConfig" | grep -e '^role_arn' | cut -d '=' -f 2 | xargs)
    if [ ! "$role" ]
        echo "No role configured for profile '$profile'"
        return 1
    end

    set mfaSerial (echo "$profileConfig" | grep -e '^mfa_serial' | cut -d '=' -f 2 | xargs)
    if [ "$mfaSerial" ]
        if test -e "$HOME/.aws/$profile.mfa"
            set mfaSecret (cat "$HOME/.aws/$profile.mfa")
            set mfa (oathtool --base32 --totp "$mfaSecret")
        else
            read -P "MFA> " mfa
        end

        if [ ! "$mfa" ]
            return 1
        end
    end

    set randomSuffix (date +%s | shasum | base64 | head -c 6 ; echo)

    if [ "$mfaSerial" ]
        set credentials (aws sts assume-role --profile default --role-arn $role --role-session-name "TempSession$randomSuffix" --serial-number $mfaSerial --token-code $mfa)
    else
        set credentials (aws sts assume-role --profile default --role-arn $role --role-session-name "TempSession$randomSuffix")
    end

    if [ $status -gt 0 ]
        echo "Error assuming role $role of profile $profile (status $status)"
        return 1
    end

    set -gx AWS_DEFAULT_PROFILE $profile
    set -gx AWS_ACCESS_KEY_ID (echo $credentials | jq -r ".Credentials.AccessKeyId")
    set -gx AWS_SECRET_ACCESS_KEY (echo $credentials | jq -r ".Credentials.SecretAccessKey")
    set -gx AWS_SESSION_TOKEN (echo $credentials | jq -r ".Credentials.SessionToken")
    set -gx AWS_SESSION_EXPIRATION (echo $credentials | jq -r ".Credentials.Expiration")

    eval (aws ecr get-login --no-include-email) 2> /dev/null

    # activate expiration event handler
    __aws_session_monitor
end