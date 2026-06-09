#!/usr/bin/env bash

# Usage:
#  git-provenance.sh [arguments]
#
# Shows commit provenance for a range of commits:
#  - Author (who wrote it)
#  - Committer (who authorized it)
#  - Signer (with verification/trust)
#  - Co-Author (from commit message trailer)
#
# Lines that carry no information are dropped:
#   - Signer is omitted when the signature can't be verified (code E)
#   - Co-Author is omitted when the commit has no Co-Authored-By trailer
#
# Examples:
#   git-provenance.sh                         # full history
#   git-provenance.sh -20                     # last 20 commits
#   git-provenance.sh c2e539c~1..146cf49      # an explicit range
#   git-provenance.sh --author=Spiritualism   # `git log` args

set -euo pipefail

# Build the per-commit format. %n is git's newline; %C(...) are colors.
format='%C(bold yellow)%h%Creset %C(yellow dim)%cs%Creset %C(yellow)%s%C(reset)%n'
format+='%C(dim)Author:   %Creset %an <%ae>%n'
format+='%C(dim)Committer:%Creset %cn <%ce>%n'
format+='%C(dim)Signer:   %Creset %GS  %C(cyan dim)[%G? / trust:%GT]%Creset%n'
format+='%C(dim)Co-Author:%Creset %(trailers:key=Co-Authored-By,valueonly,separator=%x2C%x20)%n'

# --color=always keeps the colors alive through the awk pipe.
git log --color=always --format="$format" "$@" |
	awk '
    {
      # Work on an ANSI-stripped copy so the tests ignore color codes.
      stripped = $0
      gsub(/\033\[[0-9;]*m/, "", stripped)

      # Drop the Signer line when the signature cannot be checked (code E).
      if (stripped ~ /Signer:/ && stripped ~ /\[E /) next

      # Drop the Co-Author line when nothing follows the label.
      if (stripped ~ /Co-Author:/) {
        value = stripped
        sub(/.*Co-Author:[ \t]*/, "", value)
        if (value == "") next
      }

      print
    }
  '
