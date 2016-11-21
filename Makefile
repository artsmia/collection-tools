symlink: mia tombstone miamg mia-update
	echo $^ | tr ' ' '\n' | while read command; do \
		rm ~/bin/$$command; \
		ln -s $$(pwd)/$$command ~/bin/$$command; \
	done
