#!/bin/bash

rm -f *.bundle

OLDEST=$(git rev-list --first-parent -1 --before=2021-10-01 origin/master)
git branch -f refs/bundles/2021-10-01 $OLDEST
git bundle create 2021-10-01.bundle refs/bundles/2021-10-01 >/dev/null 2>/dev/null

PREVIOUS=refs/bundles/2021-10-01
PREVBUNDLE=2021-10-01.bundle

echo "["
echo "	{"
echo "		\"uri\" : {base}/2021-10-01.bundle,"
echo "		\"timestamp\" : $(git log --format=%ct -1 $OLDEST),"
echo "	},"

for day in $(seq 2 29)
do
	NEXT=$(git rev-list --first-parent -1 --before=2021-10-$day origin/master)

	if [ "$OLDEST" == "$NEXT" ]
	then
		echo >/dev/null
	else
		BRANCH=refs/bundles/2021-10-$day
		git branch -f $BRANCH $NEXT
		git bundle create 2021-10-$day.bundle $PREVIOUS..$BRANCH >/dev/null 2>/dev/null
		PREVIOUS=$BRANCH

		echo "	{"
		echo "		\"uri\" : \"{base}/2021-10-$day.bundle\","
		echo "		\"timestamp\" : $(git log --format=%ct -1 $NEXT),"
		echo "		\"requires\" : \"{base}/$PREVBUNDLE\","
		echo "	},"

		PREVBUNDLE=2021-10-$day.bundle
	fi
done

echo "]"