#!/usr/bin/env python3
"""Final evidence acceptance for CompCert correspondence and CBMC reproof.

This checks existing evidence; it does not generate models or write proofs.
Additional functional, safety and termination goals require their own evidence.
"""
import argparse
import json
from pathlib import Path

from compcert_gate import accept_compcert_delivery


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    actions = parser.add_subparsers(dest='action', required=True)
    gate = actions.add_parser('gate', help='Check existing execution and CBMC-reproof evidence')
    gate.add_argument('--request', required=True)
    gate.add_argument('--request-sha256', required=True)
    gate.add_argument('--contract', required=True)
    gate.add_argument('--manifest', required=True)
    gate.add_argument('--spec-recheck', required=True)
    args = parser.parse_args()
    result = accept_compcert_delivery(
        Path(__file__).resolve().parents[1],
        request_path=args.request, contract_path=args.contract,
        expected_request_sha256=args.request_sha256,
        manifest_path=args.manifest, spec_recheck_path=args.spec_recheck)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
