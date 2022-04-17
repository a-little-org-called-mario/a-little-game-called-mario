#!/usr/bin/env python

"""
Script to generate markdown documentation from GDScript files.
"""

from pathlib import Path
from typing import Iterable, Pattern, TextIO
import re

CLASS_DOCSTRING_REGEX = re.compile('(?s)\n\n"""\n(.*?)\n\n(.*?)"""\n\n')
METHOD_REGEX = re.compile("func ([^_].*):")
MEMBER_REGEX = re.compile("var ([^_][_a-zA-Z0-9]*) ")
SIGNAL_REGEX = re.compile("signal ([^_].*)")
DOCUMENTED_ITEM = "### {name}[↪](" +\
    "https://github.com/a-little-org-called-mario/a-little-game-called-mario" +\
    "/blob/main/{file}#L{line})\n\n{docstring}"

class DocumentedItem():
    """An element in the script that has been documented."""
    def __init__(self, name, docstring, line, file):
        self.name: str = name
        self.docstring: str = docstring
        self.line: int = line
        self.file: Path = file


def get_documented(content: str, script_file: Path,
        part_regex: Pattern) -> list[DocumentedItem]:
    """Returns a dictionary mapping the item names matched by the
    part_regex to the documentation written in the comments above
    the item.
    """
    documented: list[DocumentedItem] = []
    comment = ""
    for line_num, line in enumerate(content.split("\n"), 1):
        if not line:
            comment = ""
            continue
        if line[0] == "#":
            comment += line
        else:
            result = part_regex.match(line)
            if result and comment:
                documented.append(DocumentedItem(result.group(1),
                    comment.replace("# ", ""), line_num, script_file))
            comment = ""
    return documented


def get_document_section(name: str, items: list[DocumentedItem]) -> Iterable[str]:
    """Returns a list of markdown sections that document the given items.

    Also adds a header using the given name. If there are no items,
    returns an empty array."""
    if len(items) == 0:
        return []
    return [
        f"## {name}",
        *map(lambda item: DOCUMENTED_ITEM.format(**vars(item)), items)
    ]


def generate_markdown(file: TextIO) -> str | None:
    """Searches the given script for documented items and returns
    a pretty markdown page. If no items where documented, returns None
    """
    script_file = Path(file.name)
    class_name: str = script_file.stem
    short_desc: str = ""
    docstring: str = ""

    content = file.read()
    
    result = CLASS_DOCSTRING_REGEX.search(content)
    if result:
        short_desc, docstring = result.groups()

    methods = get_documented(content, script_file, METHOD_REGEX)
    signals = get_documented(content, script_file, SIGNAL_REGEX)
    members = get_documented(content, script_file, MEMBER_REGEX)

    markdown: list[str] = [f"# {class_name}"]
    if short_desc:
        markdown.append(short_desc)
    if docstring:
        markdown += ["## Description", docstring]
    markdown += [
        *get_document_section("Signals", signals),
        *get_document_section("Members", members),
        *get_document_section("Methods", methods),
    ]
    if any([short_desc, methods, signals, members]):
        return "\n\n".join(markdown)


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
