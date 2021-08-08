function __touchbar_git_ticket_action
  if [ "$JIRA_TICKET_ID" ]
     set -l ticket_type  (echo -n $JIRA_TICKET_ID | cut -d '-' -f 1)
     set -l ticket_base_url_var JIRA_TICKET_URL_$ticket_type
     if [ "$$ticket_base_url_var" ]
       open "$$ticket_base_url_var$JIRA_TICKET_ID"
     end
  end
end
