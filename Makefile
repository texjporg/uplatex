TARGET1 = uplatex.ltx ujarticle.cls
TARGET2 = uplatex.pdf upldoc.pdf
FONTMAP = -f ipaex.map -f uptex-ipaex.map -f otf-ipaex.map

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
	uplatex --kanji=utf8 uplfmt.ins
	rm uplfmt.log

ujarticle.cls: $(PLCLS_SRC)
	uplatex --kanji=utf8 uplcls.ins
	rm uplcls.log

uplatex.pdf: $(INTRODOC_SRC)
	uplatex --kanji=utf8 uplatex.dtx && \
	uplatex --kanji=utf8 uplatex.dtx && \
	dvipdfmx $(FONTMAP) uplatex.dvi
	rm uplatex.aux uplatex.log uplatex.dvi

upldoc.pdf: $(PLDOC_SRC)
	for x in upldoc.tex Xins.ins; do \
	if [ -e $$x ]; then rm $$x; fi \
	done
	uplatex --kanji=utf8 upldocs.ins && \
	uplatex --kanji=utf8 Xins.ins && sh mkpldoc.sh && \
	dvipdfmx $(FONTMAP) upldoc.dvi
	rm *.aux *.log upldoc.toc upldoc.idx upldoc.ind upldoc.ilg
	rm upldoc.glo upldoc.gls *.dvi upldoc.tex Xins.ins
	rm *.cfg upldoc.dic mkpldoc.sh dstcheck.pl

.PHONY: clean
clean:
	for x in $(PLFMT) $(PLCLS) \
	uplatex.pdf upldoc.pdf \
	upldoc.tex Xins.ins; do \
	if [ -e $$x ]; then rm $$x; fi \
	done
