##
# Ody55eus.gitlab.io
#
# @version 0.0.1

make: html

install:
	emacs --quick --script requirements.el

download-puml:
	curl -L http://sourceforge.net/projects/plantuml/files/plantuml.jar/download > ~/plantuml.jar

diag:
	java -jar ~/plantuml.jar diag/*

html:
	emacs --quick --script publish.el --funcall=jp/publish-html

# end
