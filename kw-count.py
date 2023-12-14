#!/usr/bin/env python3
"""
Count number of definitions for each keyword definition
1. Look at lines starting with "syn keyword".
1a. Concatenate lines if the first non whitespace character in
    the next line is a "\\".
2. All keywords become keys of a dictionary.
3. The values of the dictionary are lists of tuples of filenames and
   linenumbers representing the position of the keyword.
4. At the end, output all dictionary items with more than one element in the
   list of values.
"""

import argparse
import re
from collections import namedtuple

syn_kw_pat = re.compile("syn(tax)?\s+keyword\s+\w+")
syn_match_pat = re.compile("syn(tax)?\s+match\s+\w+")
hilink_pat = re.compile(r"hi\s+link\s+(\w+)\s+(\w+)")
hicolor_pat = re.compile(r"hi\s+(\w+)\s+ctermfg=")
match_kw_pat = re.compile(r"(?<=[<(|])[-A-Za-z0-9_]{2,}")
bs_pat = re.compile(r"\s+\\")
KW_WIDTH = 25 # Width of keyword column in table
SYN_WIDTH = 8 # Width of syn column in table
TB_HEADER = "Keyword                   Line syn     Filename"
FORMAT_STR = ["        {syn_type:%ds} {fn}: {line}  " % SYN_WIDTH,
              "{kw:%ds} {line:4d} {syn_type:%ds} {fn}" % (KW_WIDTH, SYN_WIDTH)]
MATCH_STR = "(match)"

class KwLen:
    """
    Helper class to track longest keyword
    """
    length = 0
    keyword = ''

    def update(self, kw):
        l = len(kw)
        if l > self.length:
            self.length, self.keyword = l, kw

"""
All information related to a keyword.
1. Filename where it was found.
2. Linenumber in that filename.
3. Found in a `syn keyword` line or a `syn match` line.
"""
KwInfo = namedtuple('KwInfo', 'filename linenumber syn')

def parse_keywords(f, filename, keywords):
    """
    Parse file object f and update the keywords dictionary.
    """
    def update_keywords(syn='keyword'):
        for kw in kw_list:
            keywords.setdefault(kw, []).append(KwInfo(filename, lineno, syn))

    for lineno, line in enumerate(f, start=1):
        # Lines starting with "syn keyword"
        if syn_kw_pat.match(line):
            kw_list = re.split('\s+', line.strip())[3:]
            update_keywords()
        # Lines with "\" as first non whitespace character
        elif bs_pat.match(line):
            kw_list = re.split('\s+', line.strip())[1:]
            update_keywords()
        # Lines starting with "syn match"
        elif syn_match_pat.match(line):
            # Assumption: match expression contains no whitespace
            # Everything after position 3 is a syntax argument
            kw_list = match_kw_pat.findall(line.split()[3])
            update_keywords('match')

def parse_files(files, keywords):
    """
    Parse each file with the parse function and update the dictionary.
    `args` are passed to the `parse_function`.
    """
    for filename in files:
        with open(filename, 'r') as f:
            parse_keywords(f, filename, keywords)

def parse_colors(fn, hlgroups, color_defs):
    """
    Parse highlight groups and color definitions into the two
    dictionaries `hlgroups` and `color_defs`.
    """

def parse_colors(files, hlgroups, color_defs):
    """
    Parse color groups and highlight group definitions.
    Identify highlight groups to be defined.
    Identify unused defined highlight groups.
    """
    for fn in files:
        parse_colors(fn, hlgroups, color_defs)


def print_results(keywords, pattern='.*', table=False, print_all=False):
    """
    Print information for duplicate entries.
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
    if table:
        print(TB_HEADER)
    for kw, context in keywords.items():
        key_len.update(kw)
        found_kwds = len(context)
        if (found_kwds > multi):
            if found_kwds > 1:
                multi_count += 1
            if not kw_sel.match(kw):
                continue
            if not table:
                print(f"{kw}: ")
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

def prepare_options():
    """
    Prepare the option parser.
    """
    parser = argparse.ArgumentParser(
            description="Identify duplicate keywords in VIM Syntax file")

    # One or more positional arguments: filenames to be parsed
    parser.add_argument('files', nargs='+',
                        help="One or more files to parse")

    parser.add_argument('--table', '-t', action='store_true',
                        default=False,
                        help=("Print output in table format "
                              "(fixed width columns)"))

    parser.add_argument('--regex', '-r',
                        default='.*',
                        help="Print keywords matching regex pattern")

    parser.add_argument('--all', '-a',
                        action='store_true',
                        default=False,
                        help=("Print all keywords with filename and "
                              "and line number"))

    parser.add_argument('--colors', '-c',
                        default='store_true',
                        help=("Print color definitions, undefined colors, "
                              "defined but unused colors"))

    return parser

def main():

    parser = prepare_options()
    args = parser.parse_args()

    keywords = {}
    parse_files(args.files, keywords)

    print_results(keywords, args.regex, args.table, args.all)

    if args.colors:
        hlgroups, color_defs = {}, {}

if __name__ == '__main__':
    main()
