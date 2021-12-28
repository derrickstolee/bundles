#!/usr/bin/python3

import subprocess
import requests
import urllib
import json
import os

headers = {
    "Accept": "text/html,text/json",
}

resp = requests.get("https://nice-ocean-0f3ec7d10.azurestaticapps.net/bundles.json", headers=headers)

j = json.loads(resp.text)

timestamp_str = subprocess.run(["git", "config","--get","bundle.latestTimestamp"], capture_output=True, text=True).stdout

latest_timestamp = 0
if len(timestamp_str) > 0:
	latest_timestamp=int(timestamp_str)

if not os.path.isdir(".git/bundles"):
	os.mkdir(".git/bundles")

i = 0
for bundle in j:
	timestamp = int(bundle['timestamp'])

	if bundle['timestamp'] <= latest_timestamp:
		continue

	location = ".git/bundles/" + str(i) + ".bundle"
	print("Downloading", bundle['uri'], "to", location)

	r = requests.get(bundle['uri'], stream=True)

	with open(location, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024 * 8):
                if chunk:
                    f.write(chunk)
                    f.flush()
                    os.fsync(f.fileno())

	result = subprocess.run(["git", "bundle", "unbundle", location], capture_output=True, text=True)

	for line in result.stdout.split("\n"):
		if len(line) < 40:
			break
		elements = line.split()
		branch = elements[1]
		if branch.startswith("refs/heads/refs/bundles/"):
			branch = branch[len("refs/heads/"):]
		subprocess.call(["git", "branch", "-f", branch, elements[0]])

	latest_timestamp = timestamp
	subprocess.call(["git", "config", "--replace-all", "bundle.latestTimestamp", str(timestamp)])

	i += 1
