Bundles
=======

This repository is just an example of how we can host Git bundles in a way
that supports fetching data from precomputed bundles without the origin
server needing to manage those bundles.

This repository is mirrored as an Azure Static Web Site at
`https://nice-ocean-0f3ec7d10.azurestaticapps.net`.

This repository contains a set of bundles corresponding to the data of
[the `git/git` repository](https://github.com/git/git) in its `master`
branch at different timepoints throughout October 2021.

Proposal for fetching bundles
-----------------------------

Git clients can fetch a "table of contents" from some predetermined URL,
such as [`https://nice-ocean-0f3ec7d10.azurestaticapps.net/bundles.json`](https://nice-ocean-0f3ec7d10.azurestaticapps.net/bundles.json)
hosted by this repository.

This URL stores a JSON list with objects containing a few known members:

* `uri` (required): the URI of the bundle being referenced.
* `timestamp`: the timestamp of this URI.
* `requires`: If this bundle is not closed under reachability (and might
  contain thin packs), then which `uri` is the "previous" one that contains
  a previous set of objects. (This assumes that the bundles can be ordered
  linearly.)

### Cloning

The `clone.sh` script shows how we can create a new repository using these
bundles. After initializing a new repository, we can use `fetch.py` to
download all of the bundles in the JSON list. We then add the `origin`
remote and fetch the remaining data from that list.

```ShellSession
stolee@stolee-linux-metal:/_git$ rm -rf git-bundle-test trace2.txt && GIT_TRACE2_PERF=/_git/trace2.txt /_git/bundles/clone.sh https://github.com/git/git git-bundle-test
Initialized empty Git repository in /_git/git-bundle-test/.git/
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-01.bundle to .git/bundles/0.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-4.bundle to .git/bundles/1.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-7.bundle to .git/bundles/2.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-12.bundle to .git/bundles/3.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-13.bundle to .git/bundles/4.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-14.bundle to .git/bundles/5.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-15.bundle to .git/bundles/6.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-19.bundle to .git/bundles/7.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-26.bundle to .git/bundles/8.bundle
Note: switching to 'FETCH_HEAD'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at af6d1d602a Git 2.33.1

stolee@stolee-linux-metal:/_git$ cd git-bundle-test/
stolee@stolee-linux-metal:/_git/git-bundle-test$ git branch -v
* (HEAD detached at FETCH_HEAD) af6d1d602a Git 2.33.1
  refs/bundles/2021-10-01       cefe983a32 The ninth batch
  refs/bundles/2021-10-12       2a97289ad8 Twelfth batch
  refs/bundles/2021-10-13       2bd2f258f4 Sync with Git 2.33.1
  refs/bundles/2021-10-14       9875c51553 Merge branch 'ja/doc-status-types-and-copies'
  refs/bundles/2021-10-15       f443b226ca Thirteenth batch
  refs/bundles/2021-10-19       9d530dc002 The fourteenth batch
  refs/bundles/2021-10-26       e9e5ba39a7 The fifteenth batch
  refs/bundles/2021-10-4        0785eb7698 The tenth batch
  refs/bundles/2021-10-7        106298f7f9 The eleventh batch

stolee@stolee-linux-metal:/_git/git-bundle-test$ ls .git/objects/pack/
stolee@stolee-linux-metal:/_git/git-bundle-test$ ls -al .git/objects/pack/
total 241064
drwxrwxr-x 2 stolee stolee      4096 Oct 28 11:52 .
drwxrwxr-x 4 stolee stolee      4096 Oct 28 11:52 ..
-rw-rw-r-- 1 stolee stolee   8877836 Oct 28 11:52 multi-pack-index
-r--r--r-- 1 stolee stolee     18152 Oct 28 11:52 pack-0de3636531b9ce15eae60de09224e8a62d9d0a4c.idx
-r--r--r-- 1 stolee stolee   1515581 Oct 28 11:52 pack-0de3636531b9ce15eae60de09224e8a62d9d0a4c.pack
-r--r--r-- 1 stolee stolee      9612 Oct 28 11:52 pack-1938b2e1527f7167687ee27e18951aac9a0baed1.idx
-r--r--r-- 1 stolee stolee    849728 Oct 28 11:52 pack-1938b2e1527f7167687ee27e18951aac9a0baed1.pack
-r--r--r-- 1 stolee stolee   8514836 Oct 28 11:52 pack-3174045eb5b62a6749b1daf60c0acfe8fda0facc.idx
-r--r--r-- 1 stolee stolee 100176426 Oct 28 11:52 pack-3174045eb5b62a6749b1daf60c0acfe8fda0facc.pack
-r--r--r-- 1 stolee stolee    298880 Oct 28 11:52 pack-43362f7e98023f4698ac7c3ace1f739616212d34.idx
-r--r--r-- 1 stolee stolee  11376553 Oct 28 11:52 pack-43362f7e98023f4698ac7c3ace1f739616212d34.pack
-r--r--r-- 1 stolee stolee     10928 Oct 28 11:52 pack-67d22f7b765041b551444e1c21c5950b3e9392d8.idx
-r--r--r-- 1 stolee stolee   1231140 Oct 28 11:52 pack-67d22f7b765041b551444e1c21c5950b3e9392d8.pack
-r--r--r-- 1 stolee stolee     27756 Oct 28 11:52 pack-6ab2c38b678cf338a9fa0cf2faf65653ef00f1cb.idx
-r--r--r-- 1 stolee stolee   1942093 Oct 28 11:52 pack-6ab2c38b678cf338a9fa0cf2faf65653ef00f1cb.pack
-r--r--r-- 1 stolee stolee      9780 Oct 28 11:52 pack-8271f33d606a5ab8804c97a1135f441a1c2ca361.idx
-r--r--r-- 1 stolee stolee    517529 Oct 28 11:52 pack-8271f33d606a5ab8804c97a1135f441a1c2ca361.pack
-r--r--r-- 1 stolee stolee     15324 Oct 28 11:52 pack-937b1699b65fd2cacbd9bc119b09fb05fd1a685c.idx
-r--r--r-- 1 stolee stolee   1166484 Oct 28 11:52 pack-937b1699b65fd2cacbd9bc119b09fb05fd1a685c.pack
-r--r--r-- 1 stolee stolee     14428 Oct 28 11:52 pack-98e8a35d1a2ad91a56b29b5b3e60182ca7dcbdaa.idx
-r--r--r-- 1 stolee stolee   1082390 Oct 28 11:52 pack-98e8a35d1a2ad91a56b29b5b3e60182ca7dcbdaa.pack
-r--r--r-- 1 stolee stolee   8499240 Oct 28 11:52 pack-b805e409cb3ed85b98e4c58697e33e1027f367a7.idx
-r--r--r-- 1 stolee stolee 100595382 Oct 28 11:52 pack-b805e409cb3ed85b98e4c58697e33e1027f367a7.pack
-r--r--r-- 1 stolee stolee      1324 Oct 28 11:52 pack-f58f8c9ebfd3fdfa41a79f6558bc5122019778d7.idx
-r--r--r-- 1 stolee stolee     37462 Oct 28 11:52 pack-f58f8c9ebfd3fdfa41a79f6558bc5122019778d7.pack
```

### Fetching

As we download and store the bundles from the list of URIs, we update the
`bundle.latestTimestamp` config value. This allows us to reexamine the
table of contents and only download the bundles that are newer than that
timestamp.

(If the timestamps have altered in a way that our previously-downloaded
bundles are no longer in the list, hopefully we could use the `requires`
members to download bundles until closing the missing objects. This is
not implemented in `fetch.py`.)

Here is a test of the idea by manually modifying `bundle.latestTimestamp`:

```ShellSession
stolee@stolee-linux-metal:/_git/git-bundle-test$ git config --replace-all bundle.latestTimestamp 1634072372
stolee@stolee-linux-metal:/_git/git-bundle-test$ git config --local --list
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
bundle.latesttimestamp=1634072372
remote.origin.url=https://github.com/git/git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
stolee@stolee-linux-metal:/_git/git-bundle-test$ /_git/bundles/fetch.py
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-14.bundle to .git/bundles/0.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-15.bundle to .git/bundles/1.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-19.bundle to .git/bundles/2.bundle
Downloading https://nice-ocean-0f3ec7d10.azurestaticapps.net/2021-10-26.bundle to .git/bundles/3.bundle
```

### Custom things to this implementation

* The bundles attempt to store refs as `refs/bundles/<X>`, but somehow the
  bundles end up putting the refs as `refs/heads/refs/bundles/<X>`. To avoid
  polluting `refs/remotes/` or other refspaces, the `refs/heads/` is stripped
  out in these cases. The ref space could be very flexible, depending on how
  the bundle organizer designs it.

* The first bundle is big: it includes all data in `master` from around
  30 days ago. The rest are picking daily updates (if `master` moved in
  that time). This layout could shift over time, and I would expect the
  bundle maintenance to merge the oldest two bundles after generating a
  new, "latest" bundle.

* These bundles only care about `master`, but they could be a full
  snapshot of `refs/heads/`. They could also contain all of the tags, if
  we wanted. (Tags would not want to be hidden away in another ref namespace,
  I think.)

* Here, I am using a static web page to serve the data, but it could be
  a fancy web service with a real REST API. Specifically, it might be nice
  to add a `GET` parameter to the table of contents that allows us to
  specify a filter, such as `https://{uri}/bundles?filter=blob:none`.
  Alternatively, we could list the filter as part of the JSON objects and
  let the client decide without special modification to the URL.

* **Note:** Bundles require modification to allow object filters, but that
  would be valuable for allowing these bundles to work at huge scale.

* These bundle table of contents could be located via CDN, but they could
  also be on a GHES replica or some other tiny service. They could even
  be hosted as a route on `github.com` and backed by a near-the-edge
  microservice.

* Notice that I don't include any details about "how does the client
  discover the table of contents?" This is currently vauge, but we could
  add things to the Git protocol to advertise the table's location. I
  think separating the table itself out of the origin Git server is helpful
  because we might want multiple, geodistributed locations. The GVFS Cache
  Servers do this: the origin advertises the possible cache server URLs
  and then the cache servers manage their own lists of precomputed packs.
  The client can decide which of those locations is best for them. The
  client _could_ use a ping to test latency and choose the closest one that
  way. The specific way that Git could advertise this could look a lot like
  the `gvfs/config` endpoint which has other data than just the cache servers.
  We could create a "config" endpoint for clones that advertises these
  tables, but also advertises things like "you should use `--filter=blob:none`
  here" or other advanced recommendations.