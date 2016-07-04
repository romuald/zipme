# Directory where source resides
SCRDIR := src

# Main package name
PACKAGE := zipme

# Output executable zip file
ZIPFILE := ${PACKAGE}

# root __main__.py file that will be executed
MAIN    := "from ${PACKAGE} import main; main()"

# Temporary files
TMPDIR  := $(shell mktemp -d temp.XXXXXXX)
TMPZIP  := ${TMPDIR}/${ZIPFILE}.zip # zip tool needs a .zip extension
TMPMAIN := ${TMPDIR}/__main__.py

default: build

clean:
	rm -f ${TMPZIP}
	find ${SCRDIR} -name '*.py[co]' -delete

build: clean
	cd ${SCRDIR} && zip -r ../${TMPZIP} *
	echo ${MAIN} > ${TMPMAIN}
	zip -j ${TMPZIP} ${TMPMAIN}

	echo "#!/usr/bin/env python" > ${ZIPFILE}
	cat ${TMPZIP} >> ${ZIPFILE}
	rm -r ${TMPDIR}
	chmod +x ${ZIPFILE}


