all: uplatex.ltx ujarticle.cls \
	uplatex.pdf upldoc.pdf

.PHONY: $(TARGET1) $(TARGET2)

uplatex.ltx:
	uplatex uplfmt.ins
	rm uplfmt.log

ujarticle.cls:
	uplatex uplcls.ins
	rm uplcls.log

uplatex.pdf:
	uplatex uplatex.dtx && \
	uplatex uplatex.dtx && \
	dvipdfmx uplatex.dvi
	rm uplatex.aux uplatex.log uplatex.dvi

upldoc.pdf:
	for x in jltxdoc.cls upldoc.tex Xins.ins; do \
	if [ -e $$x ]; then rm $$x; fi \
	done
	uplatex upldocs.ins && \
	uplatex Xins.ins && sh mkpldoc.sh && \
	dvipdfmx upldoc.dvi
	rm *.aux *.log upldoc.toc upldoc.idx upldoc.ind upldoc.ilg
	rm upldoc.glo upldoc.gls *.dvi
	rm *.cfg upldoc.dic mkpldoc.sh dstcheck.pl
