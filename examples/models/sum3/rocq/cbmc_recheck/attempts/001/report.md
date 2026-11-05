# sum3 CBMC recheck attempt 001

## Human-readable outcome

**Status: INCOMPLETE for the requested full CBMC recheck.**

- **Question:** [../../problem/Spec.v](../../problem/Spec.v) is the problem statement; it contains no solution to this attempt.
- **Generated proof:** [Proof.v](Proof.v), theorem(s) `sum3_return_value; sum3_cbmc_result_bits`; supporting lemmas are explained below.
- **What was established:** All normal sum3 returns have the derived value; the specified concrete inputs return the expected binary32 bits.
- **Limits / remaining work:** All ten original harness properties remain open at full harness scope. The memcpy byte-copy, uint32 observation and memory checks are not proved. The return-bit subgoal is not the whole problem.
- **Evidence:** the original report below records the fresh compilation, independent Rocq kernel check, inherited assumptions, model configuration and evidence paths.
- **Agent and costs:** GPT-6.1 Sol, requested and observed effort `medium`; [costs.json](costs.json) records time, token and memory measurements.

## Detailed evidence and configuration

ResultBitsGoal proved on the unchanged current model; full CBMC recheck remains pending.

The operational theorem sum3_return_value quantifies over every Csem return path, every initial memory, and arbitrary typed binary32 inputs. It derives the result through frame allocation, parameter stores, expression semantics and a preserved state denotation. sum3_cbmc_result_bits applies it to 0x4b800000, 0x3f800000, 0xcb800000 and proves the returned binary32 word is zero. This is not merely the independent Float32 arithmetic fact.

No Spec changes, new axioms, admitted goals or proof bypass flags. Proof structure was adapted from the archived attempt, then all used local models/support were recompiled into a fresh tree. Kernel command: rocq check -silent ... FiveSum3Proof.Proof, exit 0 (003-rebuild-kernel). Print Assumptions is in that stdout log.

Inherited assumptions: ClassicalDedekindReals.sig_not_dec; ClassicalDedekindReals.sig_forall_dec; FunctionalExtensionality.functional_extensionality_dep; Classical_Prop.classic; Events.external_functions_sem; Events.inline_assembly_sem. These are existing dependency assumptions, not newly declared axioms. The selected sum3 entry has no external calls.

The returned value theorem does not model the harness result/bits locals or memcpy, does not prove byte-copy observation, and does not itself assert existence or termination of an execution. Thus even main.assertion.1 is still pending for the complete original harness observation.

## Exact CBMC properties

| Property | Result | Remaining obligation |
|---|---|---|
| memcpy.pointer.1 | pending | same object violation in (const unsigned char *)(const void *)&result >= (const unsigned char *)(void *)&bits + (signed long int)sizeof(uint32_t) /*4ul*/ ; no translated harness/builtin Csem statement or proof. |
| memcpy.pointer_arithmetic.1 | pending | pointer relation: dead object in (const unsigned char *)(const void *)&result; no translated harness/builtin Csem statement or proof. |
| memcpy.pointer_arithmetic.2 | pending | pointer relation: dead object in (const unsigned char *)(void *)&bits + (signed long int)sizeof(uint32_t) /*4ul*/ ; no translated harness/builtin Csem statement or proof. |
| memcpy.pointer.2 | pending | same object violation in (const unsigned char *)(void *)&bits >= (const unsigned char *)(const void *)&result + (signed long int)sizeof(uint32_t) /*4ul*/ ; no translated harness/builtin Csem statement or proof. |
| memcpy.pointer_arithmetic.3 | pending | pointer relation: dead object in (const unsigned char *)(void *)&bits; no translated harness/builtin Csem statement or proof. |
| memcpy.pointer_arithmetic.4 | pending | pointer relation: dead object in (const unsigned char *)(const void *)&result + (signed long int)sizeof(uint32_t) /*4ul*/ ; no translated harness/builtin Csem statement or proof. |
| main.precondition_instance.1 | pending | memcpy src/dst overlap; no translated harness/builtin Csem statement or proof. |
| main.precondition_instance.2 | pending | memcpy source region readable; no translated harness/builtin Csem statement or proof. |
| main.precondition_instance.3 | pending | memcpy destination region writeable; no translated harness/builtin Csem statement or proof. |
| main.assertion.1 | pending | Csem result/value bits proved; harness memcpy bytes and uint32 read remain unproved. |

## Model configuration

{
  "schema": "five-source-bindings/1",
  "entry": "sum3",
  "original_source": {
    "git": {
      "repository": "https://github.com/taylor-swift-13/FIVE",
      "commit": "3fc3d86be64876810721f32e6527105a1b9a48cc",
      "path": "examples/sum3/prepare/source/Program.c",
      "git_blob": "fa91c99c730b12edae5d0ca4f870321bcd2691a3",
      "sha256": "252be23b28c39e1d388984ba517a8c63d0b600073d0ede284ab67915fa174157"
    }
  },
  "prepared_source": {
    "path": "prepare/source/sum3.c",
    "sha256": "25143236d5dea5a1721a5f9947573083d3831f51240a6f1b0d23098e09c8ff03"
  },
  "preparation": "Selected sum3 and retained its source-level dependency closure; the original translation unit is identified by Git history.",
  "dependencies": [],
  "target": {
    "semantics": "CompCert Csem/Cexec",
    "arch": "x86",
    "bitsize": 64,
    "system": "linux",
    "endianness": "little",
    "float32": "IEEE754 binary32",
    "rounding": "round-to-nearest-ties-to-even"
  },
  "c_dialect": null,
  "c_dialect_reason": "No dialect fixed during preparation; record actual later tool options.",
  "preprocessor_arguments": [],
  "frontend_options": [],
  "external_call_bindings": [],
  "redirections": [],
  "external_environment": [],
  "correspondence_obligations": [
    "Source extraction and its translation-unit context must be accounted for when transferring properties to a different original build.",
    "Connect mapped CBMC properties to CompCert execution and observations."
  ],
  "entry_signature": "float sum3(float a, float b, float c)",
  "call_closure": {
    "entry": "sum3",
    "function_definitions": [
      "sum3"
    ],
    "direct_callees": [],
    "indirect_calls": [],
    "external_functions": [],
    "global_variables": [],
    "required_headers_or_macros": [],
    "analysis_scope": "Source-level inspection of the selected function; no numeric input preconditions are imposed."
  }
}

Actual imported modules and their complete SHA-256 list: evidence/provenance.json. That file includes all recompiled dependency source hashes, prepared C/original provenance, Spec, proof and checker hashes. All prepare/CBMC/align output handoff hashes verified unchanged.

Architecture x86 64-bit Linux little endian; binary32 round-to-nearest ties-to-even. No external bindings/redirections. Source and Execution namespaces FiveSum3; proof namespace FiveSum3Proof; support FiveShared. Rocq 9.2, OCaml 4.14.2. C dialect unspecified in frozen bindings. Entry float sum3(float,float,float). Operational relation Csem.step over sum3_ge; unrestricted initial memory, fixed concrete inputs only in ResultBitsGoal.

## Identity and costs

Runtime model gpt-6.1-sol, requested effort medium, actual effort medium. Independent session ID 01a1aba4-a195-7003-87e9-309c6237a5ae; the full session is not included. Runtime evidence evidence/runtime-metadata.json.

Costs: costs.json (five-stage-costs/1), with original measurements and session boundary in evidence/. Contract/setup and initial archived-proof inspection preceded the start boundary and are unmeasured; no parent session usage was allocated. See the final costs.json for observed seconds/tokens/RSS. Unknown measurements remain null.

## SHA-256 bindings

- examples/models/sum3/align/handoff.json: 30db4ed4f0a1337729cd6dc683a78c128b969d1ef46ae59cd22c8e58fc2daa45
- examples/models/sum3/align/model/Execution.v: cac05564097b235e3c31d3bf9a826b8bfd1929b2d9dba7368737baa4a0f79ebe
- examples/models/sum3/align/model/Source.v: 73e34704b1ea03671de34f619daa475cc70dff336f1720e64c431995008d373e
- examples/models/sum3/align/model/compcert-manifest.json: c4c5a5b39e4c0cf2f1e05ce18f6454af9652b2bd4d1dac1b0f9bc0f8d87f04f2
- examples/models/sum3/align/model/proof/Obligations.v: e2f1294af7aea0efa22eba759d46d1526a44ffbbe0e7b051ace62c2535ccf921
- examples/models/sum3/align/model/proof/Precondition.v: 6fde969151ee4cc1fd9eef30e63c447e056cabf85ec30564434e80d6069c6933
- examples/models/sum3/align/spec-map.json: 8ff1ec196054c7d49efbd06467a1140705dc6f0b77977e3f3e57bf184ca9d310
- examples/models/sum3/cbmc/handoff.json: c7838907f22ec6721747eef2d77d40425712961fd6649ab0d0aae764a52de0f9
- examples/models/sum3/prepare/source/bindings.json: c7ea3a535f1984b4117a388e470c1e1db7e51ef196500028e320a91d126ba5a4
- examples/models/sum3/prepare/source/sum3.c: 25143236d5dea5a1721a5f9947573083d3831f51240a6f1b0d23098e09c8ff03
- examples/models/sum3/rocq/cbmc_recheck/attempts/001/Proof.v: 9af47be1c8b6173a5ff1e77b4a6870f75471faebd841afa89026bbd4fcacadd2
- examples/models/sum3/rocq/cbmc_recheck/attempts/001/check.py: a292d66001e1ea3cf105dca938adf782408d22a0566b9d67ea7a48e7dce82735
- examples/models/sum3/rocq/cbmc_recheck/problem/Spec.v: 7eda10914c5582ba8570576acb48c25441717aa997879f9ea34716368597d82d
- examples/models/sum3/rocq/support/Entry.v: 144fde663e938008680e1fddb779851147b0256b62d3c927eeb74f7e07b07169
- examples/models/sum3/rocq/support/Functional.v: b1e0190488260dea65af6b89f6b701460f213db2aa005d6f0120dd1f798b5ecc
- examples/models/sum3/rocq/support/Invariant.v: 92be3cbd46bcdcedf8f57d7ec0328a91629a2afb6bd5bf27f2374282d5d6a367
- examples/models/sum3/rocq/support/NormalCorrespondence.v: f1e510ae1a44e3c45baf03990deec55c724105e5e983f6e3839b3f156a261eb1
- examples/models/sum3/rocq/support/PureProgress.v: a592e89a8ee0d9ed729217253d99deb590fecb8f78c18540583d7438ca0bbedb
- examples/models/sum3/rocq/support/SourceInvariant.v: bc9c565d9a74113594c661cd8303594c294e98268d544ab38b0bfc6e25dbe419
- shared/compcert_libc/Library.v: 8bd3bef221bd6e9ffd8c73bad23f057a855fc536ff91a70bc6eecf2bd56e0f5d
- shared/pure_semantics/SemanticsSupport.v: c788b34e8e9d3b84660250496472580d515d39de02e80be566f5381988c92de5
- shared/verification/Obligations.v: b248d4397fbd3ddc2ea8f6324f32752d1493d6a5f48f097e0fd214212010a6b4

Observed costs (proof-work boundary): wall 182.5352268218994 s; tool CPU 46.73 s; token input/output/total 609138/5039/614177; cache 589184; reasoning 426; tree RSS 1390829568 bytes. Costs recorded; setup before boundary and post-finish delivery administration excluded.

Archived evidence: evidence/run.json contains the actual rebuild/check command and exit status; evidence/logs/003-rebuild-kernel.stdout.log contains Print Assumptions and successful final kernel-check confirmation, with stderr and GNU time beside it. evidence/metrics.json fixes the original proof-work cost boundary. evidence/runtime-metadata.json records extracted actual turn_context model and effort. No full session transcript is included. All report evidence paths are relative to this attempt.
