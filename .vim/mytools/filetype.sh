#!/bin/bash

for s in 'c' 'cc' 'cpp' 'java' 'm' 'py'
do
	cmd="find . -name '*.${s}' -print"
	ss=`eval $cmd`
	if test -n "$ss"
	then
	case $s in
		"c")	echo "c";;
		"cc")	echo "c++";;
		"cpp")	echo "c++";;
		"java") echo "java";;
		"m")	echo "matlab";;
		"py")	echo "python";;
	esac
	fi
done
