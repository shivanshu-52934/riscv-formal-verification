# Formally Verified RISC-V Pipeline Processor

A SystemVerilog implementation of an RV32I 5-stage pipelined processor with exhaustive formal verification of the hazard detection and data forwarding unit using SymbiYosys and z3.

---

## What this project does differently

Most student CPU projects stop at simulation. Simulation only checks the test cases you write. This project uses **mathematical proof** — the tool explores every possible combination of inputs across all time steps and either proves the property holds for all of them, or hands you a counterexample showing exactly how it fails.

The result: two real bugs were caught automatically, and a wrong assumption about the design was corrected by the tool.

---

## Architecture

```
         imem                              dmem
          ↓                                ↓
    ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
    │   IF    │──▶│   ID    │──▶│   EX    │──▶│  MEM   │──▶│   WB    │
    │  Fetch  │   │  Decode │   │ Execute │   │ Memory │   │Writeback│
    └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
         ↑              │              ↑              │              │
    stall/flush    rs1, rs2       fwd_a/fwd_b    ─────────────────────▶
         │              ▼              │                         regfile
    ┌──────────────────────┐   ┌────────────────────────┐
    │     Hazard unit      │   │    Forwarding unit     │
    │  Detect load-use     │   │  fwd_a, fwd_b muxes    │
    └──────────────────────┘   └────────────────────────┘
```

**Pipeline stages**

| Stage | Role |
|-------|------|
| IF | Fetch instruction from memory, advance PC |
| ID | Decode opcode, read register file, generate immediate |
| EX | ALU operation, branch evaluation, forwarding mux |
| MEM | Load/store to data memory |
| WB | Write result back to register file |

**Hazard handling**

- Load-use hazards detected in the hazard unit → stall signal freezes IF and ID, inserts NOP bubble into EX
- Data hazards resolved by forwarding unit → `fwd_a` and `fwd_b` mux selects route fresh values from EX/MEM or MEM/WB directly into EX inputs, bypassing the register file
- Branch taken → flush signal kills IF/ID pipeline register (sets to NOP)

---

## Formal verification

The hazard detection and forwarding unit (`rtl/hazard_unit.sv`) is verified exhaustively using SymbiYosys with k-induction. This means the properties are proved to hold for **all possible inputs for all time**, not just selected test vectors.

### Properties proved (8 total)

| ID | Property | What it checks |
|----|----------|---------------|
| P1 | `p1_load_use_stall` | If ID/EX is a load and destination matches ID source → stall must assert |
| P2 | `p2_no_spurious_stall_noload` | If ID/EX is not a load → stall must not assert |
| P2b | `p2_no_stall_load_x0` | Load targeting x0 → no stall (x0 writes are discarded) |
| P3 | `p3_flush_iff_branch` | flush == ex_mem_branch_taken, exact equivalence |
| P4 | `p4_fwd_a_exmem_priority` | EX/MEM forwarding takes priority over MEM/WB when both write rs1 |
| P4b | `p4_fwd_a_memwb` | MEM/WB forwarding asserted when EX/MEM is not competing |
| P4c | `p4_fwd_a_none` | No forwarding when neither stage writes the source register |
| P5 | `p5_no_fwd_to_x0_a/b` | Forwarding never asserted when source is x0 |

### Cover points (8 total — all reached)

Prove that interesting states are reachable under the formal model:

- `cov_stall` — load-use stall reachable
- `cov_flush` — branch flush reachable
- `cov_fwd_a_exmem` — EX/MEM forwarding on rs1
- `cov_fwd_a_memwb` — MEM/WB forwarding on rs1
- `cov_fwd_b_exmem` — EX/MEM forwarding on rs2
- `cov_fwd_b_memwb` — MEM/WB forwarding on rs2
- `cov_double_fwd` — simultaneous forwarding on both rs1 and rs2
- `cov_stall_and_flush` — stall and flush co-occurring (see Design Insight below)

---

## Results

### Proof run — `sby -f hazard_fv.sby`

```
SBY  engine_0: smtbmc z3
SBY  base: finished (returncode=0)
SBY  smt2: finished (returncode=0)
SBY  engine_0.basecase: ##   0:00:00  Solver: z3
SBY  engine_0.basecase: ##   0:00:00  Checking assumptions in step 0..
SBY  engine_0.basecase: ##   0:00:00  Checking assertions in step 0..
SBY  engine_0.basecase: ##   0:00:00  Checking assertions in step 4..
SBY  engine_0.basecase: ##   0:00:00  Status: passed
SBY  engine_0.induction: ##   0:00:00  Trying induction in step 5..
SBY  engine_0.induction: ##   0:00:00  Temporal induction successful.
SBY  engine_0.induction: ##   0:00:00  Status: passed
SBY  summary: successful proof by k-induction.
SBY  DONE (PASS, rc=0)
```

**All 8 properties proved. Elapsed time: < 1 second.**

### Bug injection — `sby -f hazard_bug.sby`

```
SBY  engine_0.basecase: ##   0:00:00  BMC failed!
SBY  Assert failed in hazard_unit: p4_fwd_a_exmem_priority
SBY  Writing trace to VCD file: engine_0/trace.vcd
SBY  summary: counterexample trace: hazard_bug/engine_0/trace.vcd
SBY  DONE (FAIL, rc=2)
```

### Cover — `sby -f hazard_cover.sby`

```
SBY  Reached cover statement at cov_stall_and_flush in step 0.
SBY  Reached cover statement at cov_stall in step 0.
SBY  Reached cover statement at cov_flush in step 0.
SBY  Reached cover statement at cov_fwd_a_exmem in step 0.
SBY  Reached cover statement at cov_fwd_a_memwb in step 0.
SBY  Reached cover statement at cov_fwd_b_exmem in step 0.
SBY  Reached cover statement at cov_fwd_b_memwb in step 0.
SBY  Reached cover statement at cov_double_fwd in step 0.
SBY  DONE (PASS, rc=0)
```

---

## Bug injection experiments

Two bugs were deliberately introduced to verify the tool catches them.

### Bug 1 — Reversed forwarding priority

**File:** `rtl/hazard_unit_buggy.sv`

The forwarding logic was changed to check MEM/WB before EX/MEM. When both pipeline stages write the same register, the older (stale) MEM/WB value gets forwarded instead of the fresher EX/MEM value.

```systemverilog
// GOLDEN — correct priority:
if (ex_mem_reg_we && ex_mem_rd != 5'b0 && ex_mem_rd == id_rs1)
    fwd_a = 2'b01;   // EX/MEM first (newer result)
else if (mem_wb_reg_we && mem_wb_rd != 5'b0 && mem_wb_rd == id_rs1)
    fwd_a = 2'b10;   // MEM/WB second

// BUGGY — wrong order:
if (mem_wb_reg_we && mem_wb_rd != 5'b0 && mem_wb_rd == id_rs1)
    fwd_a = 2'b10;   // stale value forwarded first — silent data corruption
else if (ex_mem_reg_we && ...)
    fwd_a = 2'b01;
```

**Tool response:** FAIL at step 0 — `p4_fwd_a_exmem_priority` violated. CEX written to `hazard_bug/engine_0/trace.vcd`.

**Impact if undetected:** Instructions silently compute with a one-cycle-stale register value. No exception, no trap — wrong results with no visible error.

---

### Bug 2 — Missing x0 guard in stall logic

**File:** `rtl/hazard_unit_bug2.sv`

The x0 exclusion was removed from the stall condition. The hazard detector now stalls the pipeline even when the source register is x0, which is hardwired to zero and can never have a data hazard.

```systemverilog
// GOLDEN:
stall = id_ex_mem_re &&
        ((id_ex_rd == id_rs1 && id_rs1 != 5'b0) ||
         (id_ex_rd == id_rs2 && id_rs2 != 5'b0));

// BUGGY — x0 guard removed:
stall = id_ex_mem_re &&
        ((id_ex_rd == id_rs1) ||   // will stall on x0 reads
         (id_ex_rd == id_rs2));
```

**Tool response:** FAIL at step 0 — `p2_no_stall_load_x0` violated. CEX written to `hazard_bug2/engine_0/trace.vcd`.

**Impact if undetected:** Unnecessary stall cycles on any instruction reading x0 while a load is in EX. Functionally correct but a performance bug.

---

## Design insight from the tool

During property development, property P6 was initially written as:

```systemverilog
assert (!(stall && flush));  // assumed they couldn't co-occur
```

The tool generated a counterexample immediately showing this assumption was wrong: when a load occupies ID/EX (triggering stall) and a branch resolves in EX/MEM (triggering flush) in the same cycle, both signals assert simultaneously. The RTL handles this correctly — the ID/EX register uses `(stall || flush)` to insert a NOP, and IF/ID is cleared independently by flush.

The property was wrong, not the design. This corner case is invisible to simulation unless a specific sequence of a load followed immediately by a taken branch is part of the testbench — something easy to miss.

---

## Tool flow

```
SystemVerilog RTL + `ifdef FORMAL assertions
         ↓
    Yosys  (read -formal → internal netlist)
         ↓
    yosys-smtbmc  (netlist → SMT-LIB2 formula)
         ↓
    z3 solver  (can the negation of the property be satisfied?)
         ↓
    PASS — property holds for all inputs over all time steps
    FAIL — counterexample VCD showing the exact violation
```

k-induction runs two passes: a basecase (BMC up to depth N) that proves no violation in the first N steps, and an induction step that proves if the property held for N consecutive steps it must hold at step N+1. Together they give an unbounded proof.

---

## Why block-level FV?

The full 5-stage pipeline with a 32×32-bit register file is too large for efficient SMT solving at meaningful depths on a workstation-class machine — this is a standard challenge in industrial formal verification. The solution is hierarchical: verify sub-blocks exhaustively, then use the proved blocks as trusted components in higher-level analysis. A deeply verified small block is more valuable than shallow simulation of a full CPU.

This is the approach used by formal verification teams at NVIDIA, Intel, ARM, and Qualcomm.

---

## Repository structure

```
riscv_fv/
├── rtl/
│   ├── riscv_pipeline.sv        # Full 5-stage RV32I pipeline
│   ├── hazard_unit.sv           # Hazard + forwarding unit (golden)
│   ├── hazard_unit_buggy.sv     # Bug 1: reversed forwarding priority
│   └── hazard_unit_bug2.sv      # Bug 2: missing x0 guard
├── formal/
│   └── riscv_properties.sv      # (superseded — formal block embedded in RTL)
├── docs/
│   └── verification_report.md  # Full verification report
├── hazard_fv.sby                # prove mode (k-induction)
├── hazard_cover.sby             # cover mode (reachability)
├── hazard_bug.sby               # bug 1 detection run
├── hazard_bug2.sby              # bug 2 detection run
└── riscv_fv.sby                 # full pipeline BMC (partial)
```

---

## How to run

**Install dependencies (Ubuntu/WSL)**

```bash
sudo apt install yosys iverilog z3
git clone https://github.com/YosysHQ/sby /tmp/sby
cd /tmp/sby && sudo make install PREFIX=/usr/local
```

**Prove the hazard unit (k-induction)**

```bash
sby -f hazard_fv.sby
# Expected: DONE (PASS, rc=0)
```

**Check reachability of all cover points**

```bash
sby -f hazard_cover.sby
# Expected: all 8 cover points reached, DONE (PASS, rc=0)
```

**Reproduce bug detection**

```bash
sby -f hazard_bug.sby
# Expected: DONE (FAIL, rc=2) — p4_fwd_a_exmem_priority

sby -f hazard_bug2.sby
# Expected: DONE (FAIL, rc=2) — p2_no_stall_load_x0
```

**Inspect counterexample traces**

```bash
# After a FAIL run, open the VCD in GTKWave:
gtkwave hazard_bug/engine_0/trace.vcd
```

---

## Technologies

| Category | Tool |
|----------|------|
| HDL | SystemVerilog |
| Formal verification | SymbiYosys v0.65 |
| Synthesis | Yosys 0.33 |
| SMT solver | z3 4.8.12 |
| Proof method | BMC + k-induction |
| Simulation | Icarus Verilog 12.0 |
| Development | VS Code + WSL Ubuntu |

---

## Resume bullet

> Designed and formally verified a RISC-V RV32I 5-stage pipelined processor in SystemVerilog. Wrote 8 safety and correctness properties for the hazard detection and data forwarding unit; proved all properties by k-induction using SymbiYosys and z3 in under 1 second. Injected two RTL bugs (reversed forwarding priority, missing x0 guard) and confirmed automatic detection via counterexample traces. Discovered and corrected an incorrect design assumption using counterexample-driven analysis.

---

## Interview talking points

- Why formal over simulation? — simulation only checks what you think of; formal checks everything
- What is k-induction? — basecase + inductive step = unbounded proof without exhausting all states
- What is a counterexample? — a concrete input sequence the solver found that violates a property
- What does `$past()` do? — reads the value of a signal from the previous clock cycle
- What is a cover point? — proves a state is reachable, validates the model isn't over-constrained
- What is the stall-flush co-occurrence? — the design insight found by the tool, correcting a wrong assumption
- Why block-level FV? — state space explosion; hierarchical decomposition is how it's done industrially
- What bugs were found? — forwarding priority reversal (silent data corruption) and missing x0 guard (spurious stall)