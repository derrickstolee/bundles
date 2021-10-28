#!/bin/sh

git init $2

(
	cd $2
	/_git/bundles/fetch.py
	git remote add origin $1
	git fetch -q origin
	git checkout FETCH_HEAD
)
