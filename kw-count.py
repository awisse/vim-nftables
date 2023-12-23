#!/usr/bin/env python3
# pylint: disable=invalid-name
r"""
Counting keywords
=================
Count number of definitions for each keyword definition
1. Look at lines starting with "syn(tax) keyword" and "syn(tax) match" and
   lines with "\" as first non whitespace character.
2. Extract keywords from those lines.  All keywords become keys of a
   dictionary.
3. The values of the dictionary are lists of tuples of filenames and
   linenumbers representing the position of the keyword, as well as whether
   they were found in a "syn keyword" line or a "syn match" line.
4. By default: Display all keywords that are found in more than one syntax
   highlighting group.

Colors
======
1. Collect highlight group-names in "syn ( match | keyword ) <group-name>"
   These are the "used" (to be defined) groups.
2. Collect "from-group" names in "hi link <to-group> <from-group>",
   if "from-group" is not one of the Vim default group-names.
   These are also used groups.
3. Collect "to-group" names in "hi link <to-group> <from-group>", these
   are defined group names.
4. Collect  group-names in "hi <group-name> ctermfg=", these are also
   defined group names.
5. Display defined group-names and whether they are in the collection of
   used group names. Display also the filenames and linenumbers where
   they are defined.
6. Display used group-names and whether they are in the collection of
   defined group names.
"""

import argparse
import re
from collections import namedtuple, Counter

# Vim default syntax colors: Already defined
# ctermfg=4, guifg=Blue
VIM_DEFAULTS = ["Comment"]
# ctermfg=1, guifg=Magenta
VIM_DEFAULTS += ["Constant", "String", "Character", "Number", "Boolean",
                 "Float"]
# ctermfg=6, guifg=DarkCyan
VIM_DEFAULTS += ["Identifier", "Function"]
# ctermfg=130, gui=bold, guifg=Brown
VIM_DEFAULTS += ["Statement", "Conditional", "Repeat", "Label", "Operator",
                 "Keyword", "Exception"]
# ctermfg=5, guifg=#6a0dad
VIM_DEFAULTS += ["PreProc", "Include", "Define", "Macro", "PreCondit"]
# ctermfg=2, gui=bold, guifg=SeaGreen
VIM_DEFAULTS += ["Type", "StorageClass", "Structure", "Typedef"]
# ctermfg=5, guifg=#6a5acd
VIM_DEFAULTS += ["Special", "SpecialChar", "Tag", "Delimiter",
                 "SpecialComment", "Debug"]
# ctermfg=0, ctermbg=11
VIM_DEFAULTS += ["Todo"]
syn_kw_pat = re.compile(r"syn(?:tax)?\s+keyword\s+(\w+)")
syn_match_pat = re.compile(r"syn(?:tax)?\s+match\s+(\w+)")
syn_region_pat = re.compile(r"syn(?:tax)?\s+region\s+(\w+)")
hilink_pat = re.compile(r"hi\s+link\s+(\w+)\s+(\w+)")
hicolor_pat = re.compile(r"hi\s+(\w+)\s+ctermfg=(\d{1,3})")
match_kw_pat = re.compile(r"(?<=[<(|])[-A-Za-z0-9_]{2,}")
bs_pat = re.compile(r"\s+\\")
KW_WIDTH = 25  # Width of keyword column in table
SYN_WIDTH = 8  # Width of syn column in table
DEF_GROUP_HDR = (
    "Group                     Definition           Used Line File\n"
    "-----                     ----------           ---- ---- ----")
USED_GROUP_HDR = (
    "Group                     Defined Count\n"
    "-----                     ------- -----")
TB_HEADER = "Keyword                   Line syn     Filename"
FORMAT_STR = ["        {syn_type:%ds} {fn}: {line}  " % SYN_WIDTH,
              "{kw:%ds} {line:4d} {syn_type:%ds} {fn}" % (KW_WIDTH, SYN_WIDTH)]
MATCH_STR = "(match)"


class KwLen:
    """Helper class to track longest keyword."""

    # pylint: disable=too-few-public-methods
    length = 0
    keyword = ''

    def update(self, kw):
        """
        Update instance with new kw if it is longer than all keywords
        seen until now.
        """
        l = len(kw)
        if l > self.length:
            self.length, self.keyword = l, kw

# All information related to a keyword.
# 1. Found in a `syn keyword` line or a `syn match` line.
# 2. Filename where it was found.
# 3. Linenumber in that filename.
KwInfo = namedtuple('KwInfo', 'syn filename linenumber')

# Information related to a color definition
# 1. color (ctermfg=)
# 2. link (group name)
# 3. Filename where it was found.
# 4. Linenumber in that filename.
ColorInfo = namedtuple('ColorInfo', 'color link filename linenumber')

def parse_keywords(f, filename, keywords):
    """
    Parse file object f and update the keywords dictionary.
    """
    def update_keywords(syn='keyword'):
        for kw in kw_list:
            keywords.setdefault(kw, []).append(KwInfo(syn, filename, lineno))

    for lineno, line in enumerate(f, start=1):
        # Lines starting with "syn keyword"
        if syn_kw_pat.match(line):
            kw_list = re.split(r'\s+', line.strip())[3:]
            update_keywords()
        # Lines with "\" as first non whitespace character
        elif bs_pat.match(line):
            kw_list = re.split(r'\s+', line.strip())[1:]
            update_keywords()
        # Lines starting with "syn match"
        elif syn_match_pat.match(line):
            # Assumption: match expression contains no whitespace
            # Everything after position 3 is a syntax argument
            kw_list = match_kw_pat.findall(line.split()[3])
            update_keywords('match')

def parse_colors(f, filename, color_defs, used_groups):
    """
    Parse highlight groups and color definitions into the
    dictionary `color_defs`.
    """
    for lineno, line in enumerate(f, start=1):
        color_match = hicolor_pat.match(line)
        link_match = hilink_pat.match(line)
        kw_match = syn_kw_pat.match(line)
        match_match = syn_match_pat.match(line)
        region_match = syn_region_pat.match(line)
        if color_match:
            group, color = color_match.groups()
            color_defs.setdefault(group, []).append(
                ColorInfo(color, None, filename, lineno))
        elif link_match:
            group, link = link_match.groups()
            color_defs.setdefault(group, []).append(
                ColorInfo(None, link, filename, lineno))
            # The linked group is considered "used". It must exist.
            if link not in VIM_DEFAULTS:
                used_groups[link] += 1
        elif kw_match:
            used_groups[kw_match[1]] += 1
        elif match_match:
            used_groups[match_match[1]] += 1
        elif region_match:
            used_groups[region_match[1]] += 1

def parse_files(files, parse_function, *args):
    """
    Parse each file with the `parse_function` and update the `args`
    which are dictionaries and are passed to the `parse_function`.
    """
    for filename in files:
        with open(filename, 'r', encoding='utf-8') as f:
            parse_function(f, filename, *args)

def print_colors(color_defs, used_groups, yes, no):
    """
    Print color definitions and linked highlight groups
    Print lines with "Yes" in "Used" if `yes`.
    Print lines with "No" in "Used" if `no`.
    """

    # 1. Collect all strings to be printed.
    #
    output = []
    for group, context  in color_defs.items():
        used = group in used_groups
        if used and yes:
            yesno = "Yes"
        elif not used and no:
            yesno = "No"
        else:
            continue

        for c in context:
            if c.color:
                color_def = f"ctermfg={c.color:12}"
            elif c.link:
                color_def = f"{c.link:20}"
            else:
                color_def = "*****UNDEFINED******"
            output.append(f"{group:25} {color_def} {yesno:4} "
                          f"{c.linenumber:4} {c.filename}")
    print("Defined Groups")
    print("==============")
    print(DEF_GROUP_HDR)
    for line in sorted(output):
        print(line)

def print_used_groups(color_defs, used_groups, yes, no):
    """
    Print used color groups and whether they are defined.
    Print lines with "Yes" in "Defined" if `yes`.
    Print lines with "No" in "Defined" if `no`.
    """
    print("\nUsed Groups")
    print("===========")
    print(USED_GROUP_HDR)
    for group in sorted(used_groups):
        defined = group in color_defs
        if defined and yes:
            yesno = "Yes"
        elif not defined and no:
            yesno = "No"
        else:
            continue
        print(f"{group:25} {yesno:7} {used_groups[group]}")


def print_keywords(keywords, pattern='.*', table=False, print_all=False,
                   exclude=None, quiet=False):
    """
    Print result corresponding to user options.
    `pattern`: Only print keywords matching this pattern.
    `table`: Print in human readable table format
    `print_all`: Print all keywords, not only multiple defined ones.
    `exclude`: List of keywords not to print.
    `quiet`: Only print keywords, not filename and linenumber where
             they are defined.
    """
    # Multiple matches must appear at least twice.
    # With the option `print_all`, appearing once is fine
    multi = 0 if print_all else 1
    # Find longest keyword
    key_len = KwLen()
    # Count multiple defined keywords
    multi_count = 0
    # Keyword selection pattern
    kw_sel = re.compile(pattern)
    excluded = exclude or []
    if table:
        print(TB_HEADER)
    for kw, context in keywords.items():
        if kw in excluded:
            continue
        key_len.update(kw)
        found_kwds = len(context)
        if found_kwds > multi:
            if found_kwds > 1:
                multi_count += 1
            if not kw_sel.match(kw):
                continue
            if not table or quiet:
                print(f"{kw}")
                if quiet:
                    continue
            for c in context:
                print(FORMAT_STR[table]
                      .format(fn=c.filename, line=c.linenumber,
                              kw=kw[:KW_WIDTH], syn_type=c.syn))

    if not table:
        # Longest keyword
        print(f"Longest keyword      : {key_len.keyword} "
              f"({key_len.length} characters)")
        # Number of keys
        print(f"Number of keywords   : {len(keywords)}")
        # Number of keywords defined in multiple contexts
        print(f"Multiple defined kwds: {multi_count}")

def exclude_file(arg):
    """
    Parse the file name `arg` for keywords. Return keywords as a list.
    """
    try:
        with open(arg, 'r', encoding='ascii') as f:
            kw_str = f.read()
    except FileNotFoundError:
        raise ValueError from FileNotFoundError

    # Remove trailing whitespace, including empty lines
    kw_str = re.sub(r'\s+\Z', '', kw_str)
    keywords = re.split(r'\s+', kw_str)
    return keywords

def prepare_options():
    """
    Prepare the option parser.
    """
    parser = argparse.ArgumentParser(description=__doc__,
                        formatter_class=argparse.RawDescriptionHelpFormatter)

    # One or more positional arguments: filenames to be parsed
    parser.add_argument('files', nargs='+',
                        help="One or more files to parse")

    parser.add_argument('--table', '-t', action='store_true',
                        default=False,
                        help=("Print output in table format "
                              "with fixed width columns"))

    parser.add_argument('--regex', '-r',
                        default='.*',
                        help="Print keywords matching regex pattern")

    parser.add_argument('--all', '-a',
                        action='store_true',
                        default=False,
                        help=("Print all keywords with filename and "
                              "and line number"))

    parser.add_argument('--colors', '-c',
                        action='store_true',
                        default=False,
                        help=("Print color definitions, and whether they "
                              "are used."))

    parser.add_argument('--used-groups', '-u',
                        action='store_true',
                        default=False,
                        help=("Print used color groups and whether they "
                              "are defined."))

    parser.add_argument('--no',
                        action='store_true',
                        default=False,
                        help=("For --colors and --used-groups. Only show "
                              "lines with \"No\" in the \"Used\" or "
                              "\"Defined\" columns."))

    parser.add_argument('--yes',
                        action='store_true',
                        default=False,
                        help=("For --colors and --used-groups. Only show "
                              "lines with \"Yes\" in the \"Used\" or "
                              "\"Defined\" columns."))

    parser.add_argument('--exclude',
                        type=exclude_file,
                        default=None,
                        help=("Exclude keywords listed in filename provided "
                              "as argument to this option."))

    parser.add_argument('--quiet', '-q',
                        action='store_true',
                        default=False,
                        help=("Only display keywords, not context where "
                              "they appear"))
    return parser

def main():
    """
    Main program: parse options, call function depending on arguments.
    """

    parser = prepare_options()
    args = parser.parse_args()

    if args.colors or args.used_groups:
        color_defs = {}
        used_groups = Counter()
        parse_files(args.files, parse_colors, color_defs,
                    used_groups)
        showall = not (args.yes or args.no)
        yes = args.yes or showall
        no = args.no or showall
        if args.colors:
            print_colors(color_defs, used_groups, yes, no)
        if args.used_groups:
            print_used_groups(color_defs, used_groups, yes, no)
    else:
        keywords = {}
        parse_files(args.files, parse_keywords, keywords)
        print_keywords(keywords, args.regex, args.table, args.all,
                       args.exclude, args.quiet)

if __name__ == '__main__':
    main()
