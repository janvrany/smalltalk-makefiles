#!/usr/bin/env python3
#
# This script is intended to be used as git hook to check each git 
# commit message against guidelines [1]. The script needs to be 
# executable and it will be invoked when a 'git commit' command is 
# issued. 
#
# To install, simply make a symlink from .git/hooks/commit-msg to this file
#
# [1]: https://www.eclipse.org/projects/handbook/#resources-commit
#
import sys

DESC_MAX_LEN = 70
BODY_MAX_LEN = 72

DEBUG=False

def main():
    message_file = sys.argv[1]
    with open(message_file, 'r') as file:
        message = file.read()

    # remove git generated messages
    commit = ""
    for line in message.split('\n'):
        if not line.startswith('#'):
            commit += line + '\n'
        elif line.startswith('# ------------------------ >8 -'):
            # Stop processing after seeing the snip marker.
            break

    desc, body = commit.split("\n", 1)

    # check commit desc length
    desc_len = len(desc)

    if DEBUG:
        print(f"desc is >>{desc}<<, length is {desc_len}")

    if 0 < desc_len <= DESC_MAX_LEN:
        # shortcut to skip commit message checking
        if desc.lower().startswith('skip') or desc.lower().startswith('fixup'):
            exit(0)

        if desc[0].isupper() or desc[0] == '[':
            state = "success"
        else:
            state = "failure"
            description = "Commit description should begin with a capital letter or with [TOPIC] mark"
    else:
        state = "failure"
        description = f"Commit description should be less than {DESC_MAX_LEN+1} characters: actual {desc_len}"

    # check commit message body length
    if state == "success":
        for j, line in enumerate(body.split('\n')):
            line = line.strip()
            if DEBUG:
                print(f"line is >>{line}, length is {len(line)}")
            if 0 <= len(line) <= 72:
                if j == 0 and len(line) != 0:
                    state = "failure"
                    description = "Commit message after desc should be blank."
                    break
                else:
                    state = "success"
            else:
                state = "success"
                print(f"[WARNING] Commit body should be wrapped at {BODY_MAX_LEN} characters, where reasonable: line {j+1} actual {len(line)}")

    if state == "success":
        lines = body.split('\n')
        if not lines:
            state = "failure"
            description = "Commit requires a message body."
        elif len(lines) < 2:
            state = "failure"
            description = "Commit requires a message body explaining your changes."
        
    if state == "failure":
        print(f"FAILED: {description}\n\nPlease see guidelines: https://www.eclipse.org/projects/handbook/#resources-commit\n\n")
        exit(1)

    exit(0)

if __name__ == "__main__":
    main()
