# Repository publication

This publication includes the two setter models, the parameter-order relation,
their reports and costs, and the transitively referenced historical run receipts.
Only referenced run directories and the small indexed authoring-tool archive are
included from otherwise ignored directories. Compiled caches and model-session
conversation logs are excluded. Historical sources, snapshots and receipts were
not reformatted or rewritten for publication.

The existing artifact validator passed all 11 active problems in the recorded
WSL repository, `/home/yangfp/five`. No proof or CBMC verification was rerun for
this publication; the check validates the already retained evidence.

The retained-receipt validator compares actual historical absolute source and
compiler paths. An index-only checkout under a different `/tmp` directory was
also checked: it rejected those original-path bindings, rather than reporting
missing evidence files. Consequently, historical metadata acceptance currently
requires the recorded repository path; relocation needs fresh audited receipts
or explicit relocation support in the validator. This publication does not
rewrite old receipts or weaken that validator to make another path pass.
