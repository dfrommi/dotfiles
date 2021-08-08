function __git_status_event_handler --on-event fish_prompt --on-variable PWD
  set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
  if [ "$git_root" != "$GIT_ROOT" ]
    if [ -n "$git_root" ]
      set -g GIT_ROOT "$git_root"
      set -g GIT_REPO (string replace --all --regex -- "^.*/" "" "$GIT_ROOT")
    else
      set -e GIT_ROOT
      set -e GIT_REPO
    end
  end

  set -l branch_name
  if set -q GIT_ROOT
    set branch_name (command git symbolic-ref --short HEAD 2>/dev/null \
        || command git describe --tags --exact-match HEAD 2>/dev/null \
        || command git rev-parse --short HEAD 2>/dev/null)
  end

  if [ "$branch_name" != "$GIT_BRANCH" ]
    if [ -n "$branch_name" ]
      set -g GIT_BRANCH "$branch_name"

      set -l ticket_id_from_branch (string match -r "^([A-Za-z]+/)?([A-Za-z]+-[0-9]+)-.+" $branch_name)[3]
      if [ -n "$ticket_id_from_branch" ]
        set -g JIRA_TICKET_ID (string upper "$ticket_id_from_branch")
      else
        set -e JIRA_TICKET_ID
      end
    else
      set -e GIT_BRANCH
      set -e JIRA_TICKET_ID
    end
  end
end
