function __aws_session_monitor -e fish_prompt
    if [ ! "$AWS_SESSION_EXPIRATION" ]
        return 0
    end

    set now (date -u +"%Y-%m-%dT%H:%M:%SZ")
    if expr "$AWS_SESSION_EXPIRATION" \< "$now" > /dev/null
        # EXPIRED
        set -ge AWS_DEFAULT_PROFILE
        set -ge AWS_ACCESS_KEY_ID
        set -ge AWS_SECRET_ACCESS_KEY
        set -ge AWS_SESSION_TOKEN
        set -ge AWS_SESSION_EXPIRATION
    end
end