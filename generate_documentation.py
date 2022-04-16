#!/usr/bin/env python

from pathlib import Path
from typing import Pattern, TextIO
import re

CLASS_DOCSTRING_REGEX = re.compile('(?s)\n\n"""\n(.*?)\n\n(.*?)"""\n\n')
METHOD_REGEX = re.compile("func ([^_].*):")
MEMBER_REGEX = re.compile("var ([^_][_a-zA-Z0-9]*) ")
SIGNAL_REGEX = re.compile("signal ([^_].*)")

def get_documented(content: str, part_regex: Pattern) -> dict[str, str]:
    """Returns a dictionary mapping the item names matched by the
    part_regex to the documentation written in the comments above
    the item.
    """
    documented = {}
    comment = ""
    for line in content.split("\n"):
        if not line:
            comment = ""
            continue
        if line[0] == "#":
            comment += line
        else:
            result = part_regex.match(line)
            if result and comment:
                documented[result.group(1)] = comment.replace("# ", "")
            comment = ""
    return documented


def generate_part_markdown(documented: dict[str, str]) -> str:
    """Returns a formatted version of the given documented items."""
    return "\n".join(map(
            lambda item: "### {item}\n\n{docstring}".format(
                item=item[0], docstring=item[1]
            ),
            documented.items()
    ))


def generate_markdown(file: TextIO) -> str | None:
    """Searches the given script for documented items and returns
    a pretty markdown page. If no items where documented, returns None
    """
    class_name: str = Path(file.name).stem
    short_desc: str = ""
    docstring: str = ""
    methods: dict[str, str] = {}
    signals: dict[str, str] = {}
    members: dict[str, str] = {}

    content = file.read()
    
    result = CLASS_DOCSTRING_REGEX.search(content)
    if result:
        short_desc, docstring = result.groups()

    methods = get_documented(content, METHOD_REGEX)
    signals = get_documented(content, SIGNAL_REGEX)
    members = get_documented(content, MEMBER_REGEX)
    markdown = f"# {class_name}\n"
    if short_desc:
        markdown += f"\n{short_desc}\n"
    if docstring:
        markdown += f"\n## Description\n\n{docstring}\n"
    if signals:
        markdown += f"\n## Signals\n\n{generate_part_markdown(signals)}"
    if members:
        markdown += f"\n## Members\n\n{generate_part_markdown(members)}"
    if methods:
        markdown += f"\n## Methods\n\n{generate_part_markdown(methods)}"
    if any([short_desc, methods, signals, members]):
        return markdown 


def main():
    documentation_dir = Path("docs")
    documentation_dir.mkdir(exist_ok=True)
    root = Path()
    for script_path in root.glob("**/*.gd"):
        with script_path.open() as script:
            markdown = generate_markdown(script)
            if not markdown:
                continue
            markdown_file = documentation_dir / (script_path.stem + ".md")
            with markdown_file.open("w") as markdown_file:
                markdown_file.write(markdown)

if __name__ == "__main__":
    main()
