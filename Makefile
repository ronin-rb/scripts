test: test_install test_dev

test_install:
	./test/ronin_install_test.sh

test_dev:
	./test/ronin_dev_test.sh

.PHONY: test test_install test_dev
