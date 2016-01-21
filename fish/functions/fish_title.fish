function fish_title
	# Disable all setting in iTerm under "Appearence -> Window & Tab titles"

	# $_ = command
	# $argv = commandline
	# $PWD = directory
	
	switch $PWD
		case "$HOME/tado/repo/TadoGrailsApp*"
			set dir (echo $PWD | sed "s#^$HOME/tado/repo/TadoGrailsApp#📡#")
		case "$HOME/tado/repo/webapp*"
			set dir (echo $PWD | sed "s#^$HOME/tado/repo/webapp#🌐#")
		case "$HOME*"
			set dir (echo $PWD | sed "s#^$HOME#~#")
		case "*"
			set dir $PWD
	end

	if [ $_ = 'fish' ]
		set cmd ''
	else if [ $_ = 'grc' -o $_ = 'grails' -o $_ = 'grunt' ]
		set cmd '📶'
	else
		set cmd $_ '•'
	end
	
	echo $cmd $dir
end

