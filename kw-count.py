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

syn_match = re.compile("syn(tax)?\s+keyword")
match_match = re.compile("syn(tax)?\s+match")
bs_match = re.compile(r"\s+\\")
del_match = re.compile(r"syn(tax)?\s+match\s+\w+")
FORMAT_STR = ["        {fn}:{line}  {comment}",
          "{kw:20s} {line:3d} {comment:7s} {fn}"]
MATCH_STR = "(match)"

def parse_keywords(fn, keywords):
    """
    Parse one file and update the keywords dictionary.
    """
    with open(fn, 'r') as f:
        for lineno, line in enumerate(f, start=1):
            if syn_match.match(line):
                kw_start = 3
            elif bs_match.match(line):
                kw_start = 1
            else:
                continue
            kw_list = re.split('\s+', line.strip())[kw_start:]
            for kw in kw_list:
                keywords.setdefault(kw, []).append((fn, lineno))

def parse_matches(fn, keywords, matches):
    """
    Find lines with "syntax match" that contain keywords.
    """
    def find_keyword(line):
        for kw in keywords:
            if re.search(r'\b{}\b'.format(kw), line):
                return kw
        return ''

    with open(fn, 'r') as f:
        for lineno, line in enumerate(f, start=1):
            if match_match.match(line):
                # Exclude "syn(tax) match [word]" from match"
                line = del_match.sub('', line)
                kw = find_keyword(line)
                if kw:
                    matches.setdefault(kw, []).append((fn, lineno))

    return matches

def parse_files(files, keywords):
    """
    1. Create the dictionary.
    2. Parse each file and update the dictionary.
    """
    if keywords:
        matches = {}
        for fn in files:
            parse_matches(fn, keywords, matches)

        return matches

    for fn in files:
        parse_keywords(fn, keywords)

def print_results(keywords, matches, table=False):
    """
    Print information for duplicate entries.
    """
    for kw, context in keywords.items():
        if (len(context) > 1) or (kw in matches):
            if not table:
                print(f"{kw}: ")
            for filename, linenumber in context:
                print(FORMAT_STR[table]
                      .format(fn=filename, line=linenumber,
                              kw=kw, comment=''))
            if kw in matches:
                for filename, linenumber in matches[kw]:
                    print(FORMAT_STR[table]
                          .format(fn=filename, line=linenumber,
                                  kw=kw, comment=MATCH_STR))

def prepare_options():
    """
    Prepare the option parser.
    """
    parser = argparse.ArgumentParser(
            description="Identify duplicate keywords in VIM Syntax file")

    # One or more positional arguments: filenames to be parsed
    parser.add_argument('file', nargs='+',
                        help="One or more files to parse")

    # Check if keywords appear in matches. These keywords will be
    # highlighted with the "keyword" color rule given the precedence
    # of syntax highlighting in VIM. Print the lines
    # With keywords in matches.
    parser.add_argument('--match', '-m', action='store_true',
                        default=False,
                        help="Print keywords appearing in matches")

    parser.add_argument('--table', '-t', action='store_true',
                        default=False,
                        help="Print output in table format")

    return parser

def main():

    parser = prepare_options()
    args = parser.parse_args()

    keywords = {}
    matches = parse_files(args.file, keywords)

    if args.match:
        matches = parse_files(args.file, keywords)
    else:
        matches = {}

    print_results(keywords, matches, args.table)

if __name__ == '__main__':
    main()
