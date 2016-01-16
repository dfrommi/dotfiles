function fish_title
	# $_ = command
	# $argv = commandline
	# $PWD = directory
	
	switch $PWD
		case "$HOME/tado/repo/TadoGrailsApp*"
			set dir (echo $PWD | sed "s#^$HOME/tado/repo/TadoGrailsApp#tga#")
		case "$HOME/tado/repo/webapp*"
			set dir (echo $PWD | sed "s#^$HOME/tado/repo/TadoGrailsApp#webapp#")
		case "$HOME*"
			set dir (echo $PWD | sed "s#^$HOME#~#")
		case "*"
			set dir $PWD
	end

	if [ $_ = 'fish' ]
		set cmd ''
	else
		set cmd $_ '|'
	end
	
	echo $cmd $dir
end
