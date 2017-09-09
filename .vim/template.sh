#!/bin/bash

name=${1%%.*}
ex=${1##*.}

cpp="#include <iostream>
using namespace std;

int main()
{
	
}"

java="public class $name
{
	public static void main (String[] args)
	{
		
	}
}"

bash="#!/bin/bash

"

tex="\documentclass[a4paper,14pt,russian]{extarticle}
\usepackage[russian]{babel}
\usepackage[margin=1.5cm]{geometry}
\pagestyle{empty}

\usepackage{comment}
\usepackage{indentfirst}

\usepackage[cm-default]{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial}

\begin{document}

\end{document}"

html="<!DOCTYPE html> 
<html>
	<head>
		<meta charset = \"utf-8\"/>
		<title>Title</title>
	</head>
	<body>
	</body>
</html>"

if [ "$ex" == "cpp" ]
then
	echo "$cpp" >> $1
elif [ "$ex" == "java" ]
then
	echo "$java" >> $1
elif [ "$ex" == "sh" ]
then
	echo "$bash" >> $1
elif [ "$ex" == "tex" ]
then
	echo "$tex" >> $1
elif [ "$ex" == "html" ]
then
	echo "$html" >> $1
fi
