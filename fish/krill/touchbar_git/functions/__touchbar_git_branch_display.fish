function __touchbar_git_branch_display --on-variable GIT_BRANCH --on-variable JIRA_TICKET_ID
  if [ "$GIT_BRANCH" ]
    switch "$GIT_BRANCH"
      case "feature/*"
        set icon "🤓"
        set branch (string replace 'feature/' '' $GIT_BRANCH)
      case "bugfix/*"
        set icon "🐞"
        set branch (string replace 'bugfix/' '' $GIT_BRANCH)
      case "*"
        set icon "⌥"
        set branch $GIT_BRANCH
    end

    if [ "$JIRA_TICKET_ID" ]
      set branch (string replace "$JIRA_TICKET_ID-" "" $branch)
    end

    echo -ne "\033]1337;SetKeyLabel=F3=$icon $branch\a"
  else
    echo -ne "\033]1337;SetKeyLabel=F3=F3\a"
  end
end
