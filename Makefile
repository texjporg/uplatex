TARGET1 = uplatex.ltx ujarticle.cls
TARGET2 = uplatex.pdf upldoc.pdf
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f uptex-ipaex.map

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
	for x in $(PLFMT); do \
	if [ -e $$x ]; then rm $$x; fi \
	done
	uplatex $(KANJI) uplfmt.ins
	rm uplfmt.log

ujarticle.cls: $(PLCLS_SRC)
	for x in $(PLCLS); do \
	if [ -e $$x ]; then rm $$x; fi \
	done
	uplatex $(KANJI) uplcls.ins
	rm uplcls.log

uplatex.pdf: $(INTRODOC_SRC)
	uplatex $(KANJI) uplatex.dtx
	mendex -U -f -s gglo.ist -o uplatex.gls uplatex.glo
	uplatex $(KANJI) uplatex.dtx
	dvipdfmx $(FONTMAP) uplatex.dvi
	rm uplatex.aux uplatex.log uplatex.dvi
	rm uplatex.glo uplatex.gls uplatex.ilg

upldoc.pdf: $(PLDOC_SRC)
	for x in upldoc.tex Xins.ins; do \
	if [ -e $$x ]; then rm $$x; fi \
	done
	uplatex $(KANJI) upldocs.ins
	uplatex $(KANJI) Xins.ins
	sh mkpldoc.sh
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
