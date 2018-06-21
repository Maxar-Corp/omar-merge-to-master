# Accepts argument release-tag-name, parses JSON on site_admin
# Returns ID on stdout

import json, sys
releaseId = "";
releaseTag = sys.argv[1];
releases = json.load(sys.stdin)
for release in releases["data"]:
    if release["tag_name"] == releaseTag:
        releaseId = release["id"];
        break;
print(releaseId);
sys.exit(0);
