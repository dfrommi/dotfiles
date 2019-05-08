function __touchbar_aws_assume_role_display --on-variable AWS_DEFAULT_PROFILE
  if [ "$AWS_DEFAULT_PROFILE" ]
    echo -ne "\033]1337;SetKeyLabel=F2=☁️  $AWS_DEFAULT_PROFILE\a"
  else
    echo -ne "\033]1337;SetKeyLabel=F2=☀️\\a"
  end
end
