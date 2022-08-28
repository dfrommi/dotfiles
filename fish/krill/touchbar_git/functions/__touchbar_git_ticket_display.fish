function __touchbar_git_ticket_display --on-variable JIRA_TICKET_ID
  if [ "$JIRA_TICKET_ID" ]
    echo -ne "\033]1337;SetKeyLabel=F4=📎 $JIRA_TICKET_ID\a"
  else
    echo -ne "\033]1337;SetKeyLabel=F4=F4\a"
  end
end
