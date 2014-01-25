.PHONY: open build watch amazon tag deploy

open:
	subl --project ./project.sublime-project

build:
	grunt

watch:
	grunt watch

amazon:
	mkdir deploy
	cp bootstrap-windows.js deploy/bootstap-windows-$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();").js
	cp bootstrap-windows.min.js deploy/bootstap-windows-$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();").min.js
	cp bootstrap-windows.min.css deploy/bootstap-windows-$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();").min.css
	cp bootstrap-windows.js deploy/bootstap-windows.latest.js
	cp bootstrap-windows.min.js deploy/bootstap-windows.latest.min.js
	cp bootstrap-windows.min.css deploy/bootstap-windows.latest.min.css
	s3cmd sync deploy/* \
		--add-header=Expires:max-age=604800 \
		--acl-public \
		s3://iopeak/lib/boostrap-windows/
	rm -rf deploy

tag:
	git tag -m "" -a v$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();")
	git push origin v$(shell python -c "import json;f=open('package.json');print(json.load(f)['version']);f.close();")

deploy: build tag amazon
