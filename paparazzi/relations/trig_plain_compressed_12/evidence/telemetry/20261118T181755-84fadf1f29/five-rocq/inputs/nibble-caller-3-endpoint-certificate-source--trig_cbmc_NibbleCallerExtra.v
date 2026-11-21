
Definition expected_nibble_call(caller:function)(kont:cont)(e:env)(mi:mem)
 (tempid:ident)(bt:block)(p:Z)(s:Csem.state):Prop:=exists t,
 s=Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]
 (Kcall caller e(fun x=>Eassign(nibble_lhs t tempid bt)x short_type)nibble_return_type kont)mi.
Theorem nibble_caller_exact_first_call : forall ge caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 first_call_certificate ge(expected_nibble_call caller kont e mi tempid bt p)
 (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m).
Proof.
 intros ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE.
 eapply nibble_caller_certificate;try eassumption.
 intro t;apply first_call_here;exists t;reflexivity.
Qed.
Theorem every_nibble_caller_first_call : forall ge caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 (exists trace next,star Csem.step ge
   (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m)trace next /\
   expected_nibble_call caller kont e mi tempid bt p next) /\
 (forall trace fd args k mc,first_call_prefix ge
   (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m)trace(Callstate fd args k mc) ->
   expected_nibble_call caller kont e mi tempid bt p(Callstate fd args k mc)).
Proof.
 intros ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE.
 pose proof(@nibble_caller_exact_first_call ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE)as CERT.
 split;[exact(@first_call_execution_exists _ _ _ CERT)|].
 intros trace fd args k mc PREFIX;eapply every_first_call_covered;[|exact CERT|exact PREFIX].
 intros s[t EQ];subst s;repeat eexists;reflexivity.
Qed.
