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
color_match = re.compile(r"hi\s+link\s+(\w+)\s+(\w+)")
kw_match = re.compile(r"(?<=[<(|])[-A-Za-z0-9_]{2,}")
bs_match = re.compile(r"\s+\\")
del_match = re.compile(r"syn(tax)?\s+match\s+\w+")
TB_HEADER = "keyword              Line Match   Filename"
FORMAT_STR = ["        {fn}: {line}  {comment}",
              "{kw:23s} {line:4d} {comment:7s} {fn}"]
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

def parse_keywords(fn, keywords):
    """
    Parse one file and update the keywords dictionary.
    """
    with open(fn, 'r') as f:
        for lineno, line in enumerate(f, start=1):
            # Lines starting with "syn keyword"
            if syn_match.match(line):
                kw_list = re.split('\s+', line.strip())[3:]
            # Lines with "\" as first non whitespace character
            elif bs_match.match(line):
                kw_list = re.split('\s+', line.strip())[1:]
            # Lines starting with "syn match"
            elif match_match.match(line):
                # Assumption: match expression contains no whitespace
                # Everything after position 3 is a syntax argument
                kw_list = kw_match.findall(line.split()[3])
            else:
                continue
            for kw in kw_list:
                keywords.setdefault(kw, []).append((fn, lineno))

def parse_matches(fn, keywords, matches):
    """
    Find lines with "syntax match" that contain keywords.
    """
    def find_keyword():
        for kw, positions in keywords.items():
            # Don't count matches that were already counted in keywords
            if re.search(r'[^-]\b{}\b[^-]'.format(kw), line) \
                    and not (fn, lineno) in positions:
                return kw
        return ''

    with open(fn, 'r') as f:
        for lineno, line in enumerate(f, start=1):
            if match_match.match(line):
                # Exclude "syn(tax) match [word]" from match"
                line = del_match.sub('', line)
                kw = find_keyword()
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

def parse_colors(files, color_defs):
    """
    Parse color groups and highlight group definitions.
    Identify highlight groups to be defined.
    Identify unused defined highlight groups.
    """

def print_results(keywords, matches, pattern='.*', table=False, pr_all=False):
    """
    Print information for duplicate entries.
    """
    # Multiple matches must appear at least twice.
    # With the option `pr_all`, appearing once is fine
    multi = 0 if pr_all else 1
    # Find longest keyword
    key_len = KwLen()
    # Count multiple defined keywords
    multi_count = 0
    if table:
        print(TB_HEADER)
    for kw, context in keywords.items():
        key_len.update(kw)
        found_kwds = len(context)
        if (found_kwds > multi) or (kw in matches):
            if found_kwds > 1:
                multi_count += 1
            if not re.match(pattern, kw):
                continue
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

    parser.add_argument('--regex', '-r',
                        default='.*',
                        help="Print keywords matching regex pattern")

    parser.add_argument('--all', '-a',
                        action='store_true',
                        default=False,
                        help=("Print all found keywords with line number "
                              "and filename"))

    parser.add_argument('--colors', '-c',
                        default='store_true',
                        help=("Print color definitions, undefined colors, "
                              "defined but unused colors"))

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

    print_results(keywords, matches, args.regex, args.table, args.all)

if __name__ == '__main__':
    main()
