# Why install Ruby when I can just build this in Docker?
export JEKYLL_VERSION=3.8
docker run --rm \
	--volume="$PWD:/srv/jekyll" \
	--publish "[::1]:4000:4000" \
	-it jekyll/jekyll:$JEKYLL_VERSION \
	jekyll serve
