##
# Ody55eus.gitlab.io
#
# @version 0.0.1

all: diag html

init:
	emacs --quick --script init-page.el --funcall=jp/init-webpage

install:
	curl -L http://sourceforge.net/projects/plantuml/files/plantuml.jar/download > ~/plantuml.jar

diag:
	java -jar ~/plantuml.jar diag/*

html:
	emacs --quick --script publish.el --funcall=jp/publish-html

# end
