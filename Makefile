.PHONY: open build watch amazon tag deploy

watch:
	grunt watch

build:
	grunt

tag:
	git tag -m "" -a v$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();")
	git push origin v$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();")

vevn:
	npm install
	bower install jquery bootstrap jquery-touchswipe
