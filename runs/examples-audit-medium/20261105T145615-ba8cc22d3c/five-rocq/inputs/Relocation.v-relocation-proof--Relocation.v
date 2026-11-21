Require FiveFrozen.Source FiveReplay.Source.
Theorem program_equal : FiveFrozen.Source.prog = FiveReplay.Source.prog.
Proof. reflexivity. Qed.
Theorem function_equal : FiveFrozen.Source.f_sum3 = FiveReplay.Source.f_sum3.
Proof. reflexivity. Qed.
Print Assumptions program_equal.
Print Assumptions function_equal.
