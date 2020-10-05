STRIPTARGET = uplatex.ltx ujarticle.cls
DOCTARGET = uplatex upldoc \
	uplatex-en #upldoc-en
PDFTARGET = $(addsuffix .pdf,$(DOCTARGET))
DVITARGET = $(addsuffix .dvi,$(DOCTARGET))
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

KANJI = -kanji=utf8
#FONTMAP = -f ipaex.map -f uptex-ipaex.map
FONTMAP = -f haranoaji.map -f uptex-haranoaji.map
LTX = uplatex $(KANJI)
DPX = dvipdfmx $(FONTMAP)
MDX = mendex -U

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

PLFMT = uplatex.ltx uplcore.ltx ukinsoku.tex upldefs.ltx \
	jy2mc.fd jy2gt.fd jt2mc.fd jt2gt.fd uptrace.sty

PLFMT_SRC = uplatex.dtx uplvers.dtx uplfonts.dtx ukinsoku.dtx

PLCLS = ujarticle.cls ujreport.cls ujbook.cls ujsize10.clo \
	ujsize11.clo ujsize12.clo ujbk10.clo ujbk11.clo ujbk12.clo \
	utarticle.cls utreport.cls utbook.cls utsize10.clo \
	utsize11.clo utsize12.clo utbk10.clo utbk11.clo utbk12.clo

PLCLS_SRC = ujclasses.dtx

INTRODOC_SRC = uplatex.dtx

PLDOC_SRC = $(PLFMT_SRC) $(PLCLS_SRC)

uplatex.ltx: $(PLFMT_SRC)
	rm -f $(PLFMT)
	$(LTX) uplfmt.ins
	rm uplfmt.log

ujarticle.cls: $(PLCLS_SRC)
	rm -f $(PLCLS)
	$(LTX) uplcls.ins
	rm uplcls.log

uplatex.dvi: $(INTRODOC_SRC)
	rm -f uplatex.cfg
	$(LTX) uplatex.dtx
	$(MDX) -f -s gglo.ist -o uplatex.gls uplatex.glo
	$(LTX) uplatex.dtx
	rm uplatex.aux uplatex.log
	rm uplatex.glo uplatex.gls uplatex.ilg

upldoc.dvi: $(PLDOC_SRC)
	rm -f uplatex.cfg
	rm -f upldoc.tex Xins.ins
	$(LTX) upldocs.ins
	#
	#rm -f mkpldoc*.sh #dstcheck.pl
	#$(LTX) Xins.ins
	#sh mkpldoc.sh
	#rm mkpldoc*.sh #dstcheck.pl
	#
	rm -f upldoc.toc upldoc.idx upldoc.glo
	echo "" > ltxdoc.cfg
	$(LTX) upldoc.tex
	$(MDX) -s gind.ist -d upldoc.dic -o upldoc.ind upldoc.idx
	$(MDX) -f -s gglo.ist -o upldoc.gls upldoc.glo
	echo "\includeonly{}" > ltxdoc.cfg
	$(LTX) upldoc.tex
	echo "" > ltxdoc.cfg
	$(LTX) upldoc.tex
	#
	rm *.aux *.log upldoc.toc upldoc.idx upldoc.ind upldoc.ilg
	rm upldoc.glo upldoc.gls upldoc.tex Xins.ins
	rm ltxdoc.cfg upldoc.dic

uplatex-en.dvi: $(INTRODOC_SRC)
	# built-in echo in shell is troublesome, so use perl instead
	perl -e "print \"\\\\newif\\\\ifJAPANESE\\n"\" >uplatex.cfg
	$(LTX) -jobname=uplatex-en uplatex.dtx
	$(MDX) -f -s gglo.ist -o uplatex-en.gls uplatex-en.glo
	$(LTX) -jobname=uplatex-en uplatex.dtx
	rm uplatex-en.aux uplatex-en.log
	rm uplatex-en.glo uplatex-en.gls uplatex-en.ilg
	rm uplatex.cfg

upldoc-en.dvi: $(PLDOC_SRC)
	# built-in echo in shell is troublesome, so use perl instead
	perl -e "print \"\\\\newif\\\\ifJAPANESE\\n"\" >uplatex.cfg
	rm -f upldoc.tex Xins.ins
	$(LTX) upldocs.ins
	#
	#rm -f mkpldoc*.sh #dstcheck.pl
	#$(LTX) Xins.ins
	#sh mkpldoc-en.sh
	#rm mkpldoc*.sh #dstcheck.pl
	#
	rm -f upldoc-en.toc upldoc-en.idx upldoc-en.glo
	echo "" > ltxdoc.cfg
	$(LTX) -jobname=upldoc-en upldoc.tex
	$(MDX) -s gind.ist -d upldoc.dic -o upldoc-en.ind upldoc-en.idx
	$(MDX) -f -s gglo.ist -o upldoc-en.gls upldoc-en.glo
	echo "\includeonly{}" > ltxdoc.cfg
	$(LTX) -jobname=upldoc-en upldoc.tex
	echo "" > ltxdoc.cfg
	$(LTX) -jobname=upldoc-en upldoc.tex
	#
	rm *.aux *.log upldoc-en.toc upldoc-en.idx upldoc-en.ind upldoc-en.ilg
	rm upldoc-en.glo upldoc-en.gls upldoc.tex Xins.ins
	rm ltxdoc.cfg upldoc.dic
	rm uplatex.cfg

uplatex.pdf: uplatex.dvi
	$(DPX) $<
upldoc.pdf: upldoc.dvi
	$(DPX) $<
uplatex-en.pdf: uplatex-en.dvi
	$(DPX) $<
upldoc-en.pdf: upldoc-en.dvi
	$(DPX) $<

.PHONY: install clean cleanstrip cleanall cleandoc
install:
	mkdir -p ${TEXMF}/doc/uplatex/base
	cp ./LICENSE ${TEXMF}/doc/uplatex/base/
	cp ./README.md ${TEXMF}/doc/uplatex/base/
	cp ./*.pdf ${TEXMF}/doc/uplatex/base/
	#cp ./*.txt ${TEXMF}/doc/uplatex/base/
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
