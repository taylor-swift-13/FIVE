#!/usr/bin/env python3
"""Cold-check the symbolic arbitrary-horizon PID saturation placement proof.

The checker compiles immutable snapshots of the complete imported local
source closure, instantiates every canonical goal with its claimed theorem,
prints the actual inherited assumptions, and independently checks both proof
and goal-certificate modules.  --publish installs current hash-bound receipts;
ordinary replay preserves all published evidence.  --run charges commands to
an existing, open proof-author session; otherwise reproduction is tool-only.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import re
import shlex
import shutil
import sys
from datetime import datetime, timezone

ATTEMPT = Path(__file__).resolve().parent
ROOT = ATTEMPT.parents[4]
PROBLEM = ATTEMPT.parent.parent / "problem"
OLD_CONFIGURATION = ROOT / "paparazzi/relations/pid_position_translation/attempts/002/core/BuildConfiguration.py"
MODEL = ROOT / "paparazzi/models/guidance_pid_h_run_pos"
MANIFEST = MODEL / "align/model/compcert-manifest.json"
sys.path.insert(0, str(ROOT / "scripts"))
from five_telemetry import Run
from example_proof_gate import certificate_source, input_index

GOALS = [
    ("source_comparison", "SourceComparisonGoal"),
    ("actual_counterexample", "ActualCounterexampleGoal"),
    ("unconditional_equivalence_refuted", "UnconditionalEquivalenceRefutedGoal"),
]


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dump(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def relative(path):
    return str(Path(path).resolve().relative_to(ROOT))


def config():
    spec = importlib.util.spec_from_file_location("pid_build_configuration", OLD_CONFIGURATION)
    obj = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(obj)
    pairs = list(obj.LOADPATHS)
    pairs.extend([
        ("paparazzi/relations/pid_measurement_robustness/problem", "PidMeasurementProblem"),
        ("paparazzi/relations/pid_measurement_robustness/attempts/001", "PidMeasurementAttempt001"),
        ("paparazzi/relations/pid_alternating_bias/problem", "PidAlternatingProblem"),
        ("paparazzi/relations/pid_alternating_bias/attempts/001", "PidAlternatingAttempt001"),
        ("paparazzi/relations/pid_input_order/problem", "PidInputOrderProblem"),
        ("paparazzi/relations/pid_input_order/attempts/001", "PidInputOrderAttempt001"),
        (relative(PROBLEM), "PidSaturationProblem"),
        (relative(ATTEMPT), "PidSaturationAttempt001"),
    ])
    if len({prefix for _, prefix in pairs}) != len(pairs):
        raise ValueError("Duplicate logical namespace")
    return pairs


def module(path, pairs):
    path = Path(path).resolve()
    candidates = [
        (len(str(ROOT / directory)), directory, prefix)
        for directory, prefix in pairs
        if path.is_relative_to(ROOT / directory)
    ]
    if not candidates:
        raise ValueError("No explicit namespace for " + str(path))
    _, directory, prefix = max(candidates)
    return prefix + "." + ".".join(path.relative_to(ROOT / directory).with_suffix("").parts)


def problem():
    status = json.loads((PROBLEM / "status.json").read_text())
    expected = [goal for goal, _ in GOALS]
    if status.get("requested_goals") != expected:
        raise ValueError("Canonical requested goals differ from the exact checker bindings")
    return {
        "attempt": ATTEMPT,
        "problem": PROBLEM,
        "imports": ["PidSaturationProblem.Spec", "PidSaturationAttempt001.Proof"],
        "bindings": [
            {
                "requested_goal": goal,
                "theorem": "PidSaturationAttempt001.Proof.proved_" + goal,
                "type": "PidSaturationProblem.Spec." + goal_type,
            }
            for goal, goal_type in GOALS
        ],
    }


def semantic_dependencies():
    data = json.loads(MANIFEST.read_text()).get("semantic_dependencies")
    if not isinstance(data, dict) or not data:
        raise ValueError("Missing pinned external semantic dependencies")
    for name, expected in data.items():
        source = Path(name)
        if not source.is_absolute() or not source.is_file() or digest(source) != expected:
            raise ValueError("Changed or missing external semantics: " + str(source))
    return data


def model_binding_inputs():
    """Check relevant frozen source/model bindings without changing stage scope."""
    handoff = MODEL / "align/handoff.json"
    data = json.loads(handoff.read_text())
    if data.get("schema") != "five-stage-handoff/1" or data.get("paths_relative_to") != "case":
        raise ValueError("Unsupported original model handoff")
    roles = {
        "prepared-source", "prepared-bindings", "model-manifest",
        "model-Source.v", "model-Execution.v",
    }
    rows = [row for row in data.get("outputs", []) if row.get("role") in roles]
    if len(rows) != len(roles) or {row["role"] for row in rows} != roles:
        raise ValueError("Missing or duplicate original source/model bindings")
    result = {handoff: digest(handoff)}
    for row in rows:
        source = (MODEL / row["path"]).resolve()
        if not source.is_relative_to(MODEL) or not source.is_file() or digest(source) != row["sha256"]:
            raise ValueError("Original source/model handoff changed: " + str(source))
        result[source] = row["sha256"]
    return result


def source_closure(run, pairs, root_sources):
    flags = [item for directory, prefix in pairs for item in ("-Q", directory, prefix)]
    excluded = {"runs", "inputs", "checked", "exploratory", "__pycache__", "cold-checks"}
    files = set()
    for directory, _ in pairs:
        base = ROOT / directory
        if not base.is_dir():
            continue
        for source in base.rglob("*.v"):
            if set(source.relative_to(base).parts) & excluded:
                continue
            if re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", source.stem):
                files.add(source.resolve())
    for source in root_sources:
        if source.resolve() not in files:
            raise FileNotFoundError("Missing proof root: " + str(source))
    dep = run.command(
        ["rocq", "dep", *flags, *[relative(source) for source in sorted(files)]],
        "cold-proof-dependency-graph", timeout=120, cwd=ROOT,
    )
    graph = {}
    dependency_text = (run.folder / dep["stdout"]).read_text().replace("\\\n", "")
    for line in dependency_text.splitlines():
        if ":" not in line:
            continue
        lhs, rhs = line.split(":", 1)
        targets = shlex.split(lhs)
        if not targets or not targets[0].endswith(".vo"):
            continue
        source = (ROOT / targets[0]).with_suffix(".v").resolve()
        graph[source] = [
            (ROOT / item).with_suffix(".v").resolve()
            for item in shlex.split(rhs)
            if item.endswith(".vo") and (ROOT / item).with_suffix(".v").is_file()
        ]
    order, visiting, done = [], set(), set()

    def visit(source):
        source = source.resolve()
        if source in done:
            return
        if source in visiting:
            raise ValueError("Cyclic local dependency: " + str(source))
        if not source.is_relative_to(ROOT):
            raise ValueError("Unexpected external compilation target: " + str(source))
        if "/attempts/" in str(source) and not any(source.is_relative_to(base) for base in [
            ATTEMPT,
            ROOT / "paparazzi/relations/pid_position_translation/attempts/002",
            ROOT / "paparazzi/relations/pid_measurement_robustness/attempts/001",
            ROOT / "paparazzi/relations/pid_alternating_bias/attempts/001",
            ROOT / "paparazzi/relations/pid_input_order/attempts/001",
        ]):
            raise ValueError("Historical attempt is not an authorized dependency: " + str(source))
        if source not in graph:
            raise ValueError("Missing local dependency declaration: " + str(source))
        visiting.add(source)
        for child in graph[source]:
            visit(child)
        visiting.remove(source)
        done.add(source)
        order.append(source)

    for source in root_sources:
        visit(source)
    return order


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", type=Path, help="existing open metered proof-author run")
    parser.add_argument("--publish", action="store_true", help="install current canonical receipts")
    parser.add_argument("--plan", action="store_true", help="dependency plan only; no proof acceptance")
    parser.add_argument("--timeout", type=int, default=360)
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    owned = args.run is None
    if owned:
        run = Run.start(
            ROOT / "_build/pid-saturation-placement-cold-checks", "five-rocq", [],
            {
                "scope": "tool-only cold reproduction, no mathematical authoring",
                "requested_proof_model": "gpt-6.1-sol",
                "requested_proof_effort": "ultra",
            },
            invocation_kind="tool-only",
        )
    else:
        run = Run(args.run.resolve())
        if run.read("run.json")["status"] != "running":
            raise ValueError("Cannot append to a closed historical run")
    final = {}
    try:
        group = problem()
        pairs = config()
        semantics = semantic_dependencies()
        frozen = model_binding_inputs()
        if not args.publish and not args.plan and (ATTEMPT / "provenance.json").is_file():
            _, indexed_sources = input_index(ROOT, ATTEMPT)
            for source, expected in indexed_sources.items():
                if digest(source) != expected:
                    raise ValueError("Published input changed: " + str(source))
        roots = [ATTEMPT / "Proof.v"]
        order = source_closure(run, pairs, roots)
        if args.plan:
            note = run.folder / "evidence/dependency-plan.json"
            dump(note, {"scope": "dependency plan only", "sources": [relative(source) for source in order]})
            print(note.read_text())
            if owned:
                run.finish("passed", "Dependency plan only; no theorem acceptance.", {"plan": note})
            return
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%f")
        base = (
            ATTEMPT / "evidence/cold-checks"
            if args.publish else ROOT / "_build/pid-saturation-placement-cold-replays"
        ) / stamp
        checked = base / "checked"
        current = {source: digest(source) for source in order}
        extra_inputs = [
            Path(__file__).resolve(), OLD_CONFIGURATION, MANIFEST,
            MODEL / "prepare/source/guidance_pid_h_run_pos.c",
            MODEL / "prepare/source/bindings.json",
        ]
        extra_hashes = {**frozen, **{source: digest(source) for source in extra_inputs}}
        snapshots = {}
        for source, expected in current.items():
            target = checked / relative(source)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            if digest(target) != expected:
                raise ValueError("Source changed while snapshotting: " + str(source))
            snapshots[source] = target
            run.capture(
                target,
                "cold-dependency-" + stamp + "-" + hashlib.sha256(relative(source).encode()).hexdigest()[:18],
                area="inputs",
            )
        cold_flags = [
            item
            for directory, prefix in pairs
            for item in ("-Q", relative(checked / directory), prefix)
        ]
        for source in order:
            run.command(
                ["rocq", "compile", "-q", *cold_flags, relative(snapshots[source])],
                "cold-compile-" + source.stem, timeout=args.timeout, cwd=ROOT,
            )
        theorem_names = [binding["theorem"] for binding in group["bindings"]]
        kernel_modules = list(dict.fromkeys(name.rsplit(".", 1)[0] for name in theorem_names))
        kernel = run.command(
            ["rocq", "check", "-silent", *cold_flags, *kernel_modules],
            "cold-independent-proof-kernel", timeout=args.timeout, cwd=ROOT,
        )
        hashes = {relative(snapshots[source]): expected for source, expected in current.items()}
        proof_receipt = base / "proof-kernel-evidence.json"
        dump(proof_receipt, {
            "kind": "rocq-kernel-check",
            "run": relative(run.folder),
            "command_id": kernel["id"],
            "theorems": theorem_names,
            "statement_artifacts": [relative(snapshots[source.resolve()]) for source in roots],
            "dependency_sha256": hashes,
        })
        target = checked / relative(ATTEMPT) / "GoalBinding.v"
        target.write_text(certificate_source(group["imports"], group["bindings"]))
        run.capture(
            target,
            "cold-certificate-" + hashlib.sha256(relative(target).encode()).hexdigest()[:18],
            area="inputs",
        )
        compile_cmd = run.command(
            ["rocq", "compile", "-q", *cold_flags, relative(target)],
            "cold-exact-goalbinding", timeout=args.timeout, cwd=ROOT,
        )
        certificate_module = module(ATTEMPT / "GoalBinding.v", pairs)
        certificate_kernel = run.command(
            ["rocq", "check", "-silent", *cold_flags, certificate_module],
            "cold-exact-goalbinding-kernel", timeout=args.timeout, cwd=ROOT,
        )
        certificate_receipt = target.parent / "certificate-kernel-evidence.json"
        dump(certificate_receipt, {
            "kind": "rocq-kernel-check",
            "run": relative(run.folder),
            "command_id": certificate_kernel["id"],
            "theorems": [certificate_module + ".goal_" + str(i) for i in range(len(group["bindings"]))],
            "statement_artifacts": [relative(target)],
            "dependency_sha256": {**hashes, relative(target): digest(target)},
        })
        # Publishing happens only after both kernel checks and source-stability
        # checks.  A concurrent edit cannot leave a newly published proved flag.
        for source, expected in {**current, **extra_hashes}.items():
            if digest(source) != expected:
                raise ValueError("Input changed during cold build: " + str(source))
        if semantic_dependencies() != semantics:
            raise ValueError("Semantic dependency map changed during cold build")
        if model_binding_inputs() != frozen:
            raise ValueError("Original model binding changed during cold build")
        if args.publish:
            index = ATTEMPT / "provenance.json"
            if (ATTEMPT / "inputs.json").exists():
                raise ValueError("Do not create competing input indexes")
            indexed = {relative(source): expected for source, expected in {**current, **extra_hashes}.items()}
            dump(index, {
                "schema": "five-proof-inputs/1",
                "dependency_sha256": indexed,
                "semantic_dependencies": semantics,
            })
            rows = [
                {
                    "path": name,
                    "sha256": expected,
                    **({"snapshot": relative(snapshots[ROOT / name])} if ROOT / name in snapshots else {}),
                }
                for name, expected in sorted(indexed.items())
            ]
            validation = ATTEMPT / "evidence/goal-validation.json"
            dump(validation, {
                "schema": "five-proof-validation/1",
                "index": {"path": relative(index), "sha256": digest(index)},
                "inputs": rows,
                "kernel_evidence": relative(proof_receipt),
                "goal_bindings": group["bindings"],
                "certificate": {
                    "path": relative(target),
                    "sha256": digest(target),
                    "module": certificate_module,
                    "imports": group["imports"],
                    "run": relative(run.folder),
                    "compile_command_id": compile_cmd["id"],
                    "kernel_command_id": certificate_kernel["id"],
                    "kernel_evidence": relative(certificate_receipt),
                },
            })
            status_path = PROBLEM / "status.json"
            status = json.loads(status_path.read_text())
            if status.get("requested_goals") != [goal for goal, _ in GOALS]:
                raise ValueError("Canonical goal list changed during build")
            status.update({
                "status": "proved",
                "active_attempt": "../attempts/001",
                "goal_status": {binding["requested_goal"]: "proved" for binding in group["bindings"]},
            })
            dump(status_path, status)
            final["validation"] = validation
        print(json.dumps({
            "status": "passed",
            "source_count": len(order),
            "goals": theorem_names,
            "run": relative(run.folder),
            "kernel_evidence": relative(proof_receipt),
        }, indent=2))
        if owned:
            run.finish(
                "passed",
                "Cold source snapshots, exact typed goals and independent kernels passed.",
                {**final, "kernel": proof_receipt},
            )
    except BaseException:
        if owned and run.read("run.json")["status"] == "running":
            note = run.folder / "evidence/checker-failure.json"
            dump(note, {"scope": "cold checker did not complete; inspect retained command logs"})
            run.finish("failed", "Cold checker failed; no completion claim.", {"failure": note})
        raise


if __name__ == "__main__":
    main()
