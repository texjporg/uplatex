STRIPTARGET = uplatex.ltx ujarticle.cls
PDFTARGET = uplatex.pdf upldoc.pdf
DVITARGET = uplatex.dvi upldoc.dvi
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f uptex-ipaex.map
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

PLFMT = uplatex.ltx uplcore.ltx ukinsoku.tex upldefs.ltx \
	jy2mc.fd jy2gt.fd jt2mc.fd jt2gt.fd uptrace.sty

PLFMT_SRC = uplatex.dtx uplvers.dtx uplfonts.dtx plcore.dtx \
	ukinsoku.dtx

PLCLS = ujarticle.cls ujreport.cls ujbook.cls ujsize10.clo \
	ujsize11.clo ujsize12.clo ujbk10.clo ujbk11.clo ujbk12.clo \
	utarticle.cls utreport.cls utbook.cls utsize10.clo \
	utsize11.clo utsize12.clo utbk10.clo utbk11.clo utbk12.clo

PLCLS_SRC = ujclasses.dtx

INTRODOC_SRC = uplatex.dtx

PLDOC_SRC = uplatex.dtx uplvers.dtx uplfonts.dtx \
	ukinsoku.dtx ujclasses.dtx

uplatex.ltx: $(PLFMT_SRC)
	rm -f $(PLFMT)
	uplatex $(KANJI) uplfmt.ins
	rm uplfmt.log

ujarticle.cls: $(PLCLS_SRC)
	rm -f $(PLCLS)
	uplatex $(KANJI) uplcls.ins
	rm uplcls.log

uplatex.dvi: $(INTRODOC_SRC)
	uplatex $(KANJI) uplatex.dtx
	mendex -U -f -s gglo.ist -o uplatex.gls uplatex.glo
	uplatex $(KANJI) uplatex.dtx
	rm uplatex.aux uplatex.log
	rm uplatex.glo uplatex.gls uplatex.ilg

upldoc.dvi: $(PLDOC_SRC)
	rm -f upldoc.tex Xins.ins
	uplatex $(KANJI) upldocs.ins
	rm -f mkpldoc.sh dstcheck.pl
	uplatex $(KANJI) Xins.ins
	sh mkpldoc.sh
	rm *.aux *.log upldoc.toc upldoc.idx upldoc.ind upldoc.ilg
	rm upldoc.glo upldoc.gls upldoc.tex Xins.ins
	rm ltxdoc.cfg upldoc.dic mkpldoc.sh dstcheck.pl

uplatex.pdf: uplatex.dvi
	dvipdfmx $(FONTMAP) uplatex.dvi
upldoc.pdf: upldoc.dvi
	dvipdfmx $(FONTMAP) upldoc.dvi

.PHONY: install clean cleanstrip cleanall cleandoc
install:
	mkdir -p ${TEXMF}/doc/uplatex/base
	cp ./LICENSE ${TEXMF}/doc/uplatex/base/
	cp ./README.md ${TEXMF}/doc/uplatex/base/
	cp ./*.pdf ${TEXMF}/doc/uplatex/base/
	cp ./*.txt ${TEXMF}/doc/uplatex/base/
	mkdir -p ${TEXMF}/source/uplatex/base
	cp ./Makefile ${TEXMF}/source/uplatex/base/
	cp ./*.dtx ${TEXMF}/source/uplatex/base/
	cp ./*.ins ${TEXMF}/source/uplatex/base/
	mkdir -p ${TEXMF}/tex/uplatex/base
	cp ./ukinsoku.tex ${TEXMF}/tex/uplatex/base/
	cp ./*.clo ${TEXMF}/tex/uplatex/base/
	cp ./*.cls ${TEXMF}/tex/uplatex/base/
	cp ./*.fd  ${TEXMF}/tex/uplatex/base/
	cp ./*.ltx ${TEXMF}/tex/uplatex/base/
	cp ./*.sty ${TEXMF}/tex/uplatex/base/
	mkdir -p ${TEXMF}/tex/uplatex/config
	cp ./uplatex.ini ${TEXMF}/tex/uplatex/config/
clean:
	rm -f $(PLFMT) $(PLCLS) \
	$(DVITARGET) \
	upldoc.tex Xins.ins
cleanstrip:
	rm -f $(PLFMT) $(PLCLS) \
	upldoc.tex Xins.ins
cleanall:
	rm -f $(PLFMT) $(PLCLS) \
	$(DVITARGET) $(PDFTARGET) \
	upldoc.tex Xins.ins
cleandoc:
	rm -f $(DVITARGET) $(PDFTARGET)
