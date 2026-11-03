#!/usr/bin/env python3
"""Generate/audit original CompCert executable models; never approve from generation alone."""
import argparse,json
from compcert_backend import export,audit,tool_paths,target_of

def main():
 p=argparse.ArgumentParser(description=__doc__);s=p.add_subparsers(dest='action',required=True)
 s.add_parser('target')
 e=s.add_parser('export');e.add_argument('--source',required=True);e.add_argument('--function',required=True)
 e.add_argument('--output',required=True);e.add_argument('--namespace',default='FiveCompCert')
 e.add_argument('--include-dir',action='append',default=[]);e.add_argument('--define',action='append',default=[])
 e.add_argument('--request');e.add_argument('--session');e.add_argument('--clightgen');e.add_argument('--compcert-lib')
 a=s.add_parser('audit');a.add_argument('--manifest',required=True)
 args=p.parse_args()
 if args.action=='target':
  print(json.dumps(target_of(tool_paths()[1]),indent=2));return
 if args.action=='export':
  m=export(args.source,args.function,args.output,args.namespace,args.include_dir,args.define,args.request,args.session,args.clightgen,args.compcert_lib)
  goals=m['generated_obligations']
  print(json.dumps({'status':'generated','backend':m['backend'],'coverage_status':m['coverage_status'],
   'obligations':{'status':goals['status'],'precondition':goals['precondition_status'],
                  'proofs':goals['proof_status']},'delivery_accepted':False},indent=2))
 elif args.action=='audit':print(json.dumps(audit(args.manifest),indent=2))

if __name__=='__main__':main()
