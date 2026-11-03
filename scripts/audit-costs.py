#!/usr/bin/env python3
"""Strictly audit finished FIVE stage costs; exit nonzero if any are incomplete."""
import argparse
import json
from pathlib import Path
from cost_audit import audit_run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--run', action='append', required=True, type=Path)
    args = parser.parse_args()
    results = [audit_run(path) for path in args.run]
    print(json.dumps({'status': 'complete' if all(r['status'] == 'complete' for r in results) else 'incomplete',
                      'stages': results}, ensure_ascii=False, indent=2))
    return 0 if all(r['status'] == 'complete' for r in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
