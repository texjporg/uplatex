TARGET1 = uplatex.ltx ujarticle.cls
TARGET2 = uplatex.pdf upldoc.pdf
TARGET3 = uplatex.dvi upldoc.dvi
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f uptex-ipaex.map

default: $(TARGET1) $(TARGET3)
all: $(TARGET1) $(TARGET2)

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

.PHONY: clean
clean:
	rm -f $(PLFMT) $(PLCLS) \
	uplatex.dvi upldoc.dvi \
	uplatex.pdf upldoc.pdf \
	upldoc.tex Xins.ins
