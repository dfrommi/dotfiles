function __my_man_page -a main second third
  if [ $main = "aws" ]
    aws $second $third help
    return 0
  end

  return 1
end
