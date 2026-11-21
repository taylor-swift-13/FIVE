# update_pid_df

Original Paparazzi incremental floating PID update at commit abfee3dd56eeab12c528635504a429db3daf409a. Only standalone entry linkage qualifiers were normalized.

See [prepared source](prepare/source/update_pid_df.c), [actual CBMC ledger](cbmc/properties.json), [original CompCert AST](align/model/Source.v), and [Rocq report](rocq/report/report.md). The CBMC run reports 81/81 actual emitted properties successful with arbitrary binary32 fields and input.

The [cross-model relation](../../relations/pid_df_positional_roundoff/README.md) proves exact positional equivalence and an explicit arbitrary-horizon roundoff bound with original-memory observations. Numerical assumptions constrain the theorem, not the generated machine model.
