
VERSION=$(shell grep ^version pyproject.toml | cut -d\" -f2)

.PHONY: default
default:
	@echo "Known targets:"
	@echo "dev - install all the dependencies"
	@echo "test - run the tests"
	@echo "docs - build the docs"
	@echo "wheel - build the wheel distribution"
	@echo "upload - tag it and upload to pypi"


.PHONY: dev
dev: pyproject.toml
	pip install -e .[dev]

.PHONY: test
test:
	pytest

.PHONY: docs
docs:
	$(MAKE) -C docs html

.PHONY: wheel
wheel:
	@echo "Removing previous builds..."
	-rm -rf dist
	@echo "Building Source and Wheel (universal) distribution..."
	python -m build

.PHONY: upload
upload: wheel
        @echo "Uploading the package to PyPI via Twine..."
        twine upload dist/*

        @echo "Pushing git tags..."
	git tag v$(VERSION)
        git push --tags

 
