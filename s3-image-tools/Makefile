# a copy of the collection data on the local filesystem
collectionData = ~/tmp/collection/objects/

# Object IDs for each full image on S3
fullImagesOnS3.txt:
	s3cmd ls s3://object-images/full/ \
		| tee rawS3FullImageList.txt \
		| rev | cut -d'/' -f1 | rev | sed 's/.jpg//' \
		| grep -v '.txt$$' \
		| sort \
		> $@

# List public domain and non-PD object IDs
publicDomain.txt:
	ag -l 'rights_type": "Public Domain"' $(collectionData) \
		| cut -d'/' -f8 \
		| sed 's/.json//' \
		| sort \
		> $@
notPublicDomain.txt:
	ag -l -v 'rights_type": "Public Domain"' $(collectionData) \
		| cut -d'/' -f8 \
		| sed 's/.json//' \
		| sort \
		> $@

# This takes the union of all the full sized images in our bucket 
# and the images identified as 'not public domain' to determine the
# set of images we need to mark with `--acl-private`
imagesToMarkPrivate.txt: fullImagesOnS3.txt notPublicDomain.txt
	comm -1 -2 $^ > $@

# Show how many images from which rights types are privatized
# This is slow because it means hitting the filesystem once for each
# id in `imagesToMarkPrivate.txt`
privatizedImageRightsInfo.txt: imagesToMarkPrivate.txt
	cat $< | xargs mia | jq -r '.rights_type' \
		| sort | uniq -c \
		| sponge $@

.PHONY: imagesToMarkPrivate.txt

# util - turns an object ID into a full-size image path on S3
idToS3Path = sed 's|^|s3://object-images/full/|; s/$$/.jpg/'

privatizeNonPDImages: imagesToMarkPrivate.txt
	s3cmd setacl --acl-private $$($(idToS3Path) $<)

# Returns a signed url that will remain valid for some `duration`
#   `image` - the id of the image to sign
#   `duration` - how long the access lasts, in seconds (default 50,000  / 13.8888888889 hours)
duration = 50000
signImage:
	@echo s3cmd signurl $$($(idToS3Path) <<<$(image)) $$((`date +%s` + $(duration)))

