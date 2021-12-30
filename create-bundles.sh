#!/bin/bash

rm -f *.bundle

FILTER=

OLDEST=$(git rev-list --first-parent -1 --before=2021-12-01 origin/master)
git branch -f refs/bundles/2021-12-01 $OLDEST
git bundle create 2021-12-01.bundle refs/bundles/2021-12-01 >/dev/null 2>/dev/null

PREVIOUS=refs/bundles/2021-12-01
PREVBUNDLE=2021-12-01.bundle

URL="https://nice-ocean-0f3ec7d10.azurestaticapps.net"

echo "[bundle \"tableOfContents\"]"
echo "	version = 1"
echo

echo "[bundle \"$PREVBUNDLE\"]"
echo "	uri = \"$URL/2021-10-01.bundle\""
echo "	timestamp = $(git log --format=%ct -1 $OLDEST)"
echo

for day in $(seq 2 29)
do
	NEXT=$(git rev-list --first-parent -1 --before=2021-12-$day origin/master)

	if [ "$OLDEST" == "$NEXT" ]
	then
		echo >/dev/null
	else
		BRANCH=refs/bundles/2021-12-$day
		git branch -f $BRANCH $NEXT
		CURRENT=2021-12-$day.bundle
		git bundle create $CURRENT $PREVIOUS..$BRANCH >/dev/null 2>/dev/null &&
		PREVIOUS=$BRANCH &&

		echo "[bundle \"$CURRENT\"]" &&
		echo "	uri = \"$URL/$CURRENT\"" &&
		echo "	timestamp = $(git log --format=%ct -1 $BRANCH)" &&
		echo "	requires = \"$PREVBUNDLE\"" &&
		echo &&
		PREVBUNDLE=$CURRENT
	fi
done



FILTER="blob:none"

OLDEST=$(git rev-list --first-parent -1 --before=2021-12-01 origin/master)
git branch -f refs/bundles/2021-12-01 $OLDEST
./git bundle create 2021-12-01.blobless.bundle --filter=$FILTER  refs/bundles/2021-12-01 >/dev/null 2>/dev/null

PREVIOUS=refs/bundles/2021-12-01
PREVBUNDLE=2021-12-01.blobless.bundle

echo "[bundle \"$PREVBUNDLE\"]"
echo "	uri = \"$URL/$PREVBUNDLE\""
echo "	timestamp = $(git log --format=%ct -1 $OLDEST)"
echo "	filter = $FILTER"
echo

for day in $(seq 2 29)
do
	NEXT=$(git rev-list --first-parent -1 --before=2021-12-$day origin/master)

	if [ "$OLDEST" == "$NEXT" ]
	then
		echo >/dev/null
	else
		BRANCH=refs/bundles/2021-12-$day
		CURRENT=2021-12-$day.blobless.bundle
		./git bundle create $CURRENT --filter=$FILTER $PREVIOUS..$BRANCH >/dev/null 2>/dev/null &&
		PREVIOUS=$BRANCH &&

		echo "[bundle \"$CURRENT\"]" &&
		echo "	uri = \"$URL/$CURRENT\"" &&
		echo "	timestamp = $(git log --format=%ct -1 $BRANCH)" &&
		echo "	requires = \"$PREVBUNDLE\"" &&
		echo "	filter = $FILTER" &&
		echo &&
		PREVBUNDLE=$CURRENT
	fi
done

