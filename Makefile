.PHONY: test

export TF_PATH

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(TF_PATH) ./sql_test.go

#test_extended:
#	cd tests && go test -v -timeout 60m -run TestSql ./sql_extended_test.go -tags extended
