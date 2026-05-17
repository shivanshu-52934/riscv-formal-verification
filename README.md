# 🚀 Formally Verified RISC-V Pipeline Processor

> A SystemVerilog-based educational RISC-V pipelined CPU with formal verification using SymbiYosys, temporal assertions, counterexample-driven debugging, and hazard detection logic.

---

# 🔥 Why This Project Stands Out

Most student CPU projects stop at simulation.

This project goes significantly deeper by integrating:

✅ Pipelined RISC-V CPU Architecture
✅ Hazard Detection & Pipeline Stalling
✅ Bubble Insertion Logic
✅ Formal Verification with SymbiYosys
✅ Temporal Assertions using `$past()`
✅ Counterexample Trace Debugging
✅ GTKWave Waveform Analysis
✅ Real Pipeline Timing Bug Discovery

This project demonstrates both:

* RTL Design Skills
* Formal Verification Methodology

making it highly aligned with:

* NVIDIA Formal Verification Engineer
* ASIC Verification Engineer
* CPU Verification Engineer
* Hardware Verification Roles

---

# 🧠 Project Overview

This project implements and formally verifies an educational pipelined RISC-V processor using SystemVerilog and SymbiYosys.

The processor includes:

* Instruction Fetch (IF)
* Instruction Decode (ID)
* Execute (EX)
* Write Back (WB)
* Pipeline Registers
* Hazard Detection Logic
* Pipeline Stall Mechanism
* Bubble Insertion
* Temporal Assertions
* Counterexample Debugging

Unlike traditional simulation-only projects, this design uses mathematical proof techniques to verify pipeline correctness properties and uncover hidden timing bugs.

---

# 🏗️ Processor Architecture

## Pipeline Stages

| Stage | Description        |
| ----- | ------------------ |
| IF    | Instruction Fetch  |
| ID    | Instruction Decode |
| EX    | ALU Execution      |
| WB    | Register Writeback |

---

# 📂 Project Structure

```text
riscv-formal/
│
├── rtl/                 # SystemVerilog RTL modules
├── sim/                 # Testbenches
├── formal/              # Formal verification files
├── docs/                # Documentation and screenshots
├── waveforms/           # GTKWave traces
├── README.md
└── .gitignore
```

---

# ⚙️ Technologies Used

| Category                | Tools / Technologies |
| ----------------------- | -------------------- |
| HDL                     | SystemVerilog        |
| Formal Verification     | SymbiYosys           |
| Synthesis Engine        | Yosys                |
| SMT Solver              | Yices                |
| Simulation              | Icarus Verilog       |
| Waveform Debugging      | GTKWave              |
| Development Environment | VS Code + WSL Ubuntu |

---

# 🧩 Major RTL Modules

## ✅ ALU

Supports:

* ADD
* SUB
* AND
* OR
* XOR

Formally verified using assertions.

---

## ✅ Register File

Features:

* 32 RISC-V architectural registers
* Dual read ports
* Single write port
* x0 architectural protection

---

## ✅ Pipeline Registers

Implemented:

* IF/ID Register
* ID/EX Register
* EX/WB Register

These maintain instruction flow across pipeline stages.

---

## ✅ Hazard Detection Unit

Implements RAW (Read-After-Write) hazard detection.

Responsible for:

* pipeline stalling
* dependency handling
* preventing stale register reads

---

## ✅ Stall Controller

Implements deterministic multi-cycle stall logic.

Used to:

* freeze PC updates
* freeze IF/ID pipeline registers
* control bubble insertion

---

# 🧪 Simulation Results

## Sample CPU Output

```text
x1 = 5
x2 = 10
x3 = 15
```

---

# 🔍 Formal Verification

## Why Formal Verification?

Simulation only checks selected test vectors.

Formal verification mathematically explores:

* all possible legal states
* hidden timing bugs
* corner cases
* invalid pipeline interactions

This project uses:

* SymbiYosys
* Yosys
* SMT solving
* Temporal Assertions

---

# ✅ Formal Properties Implemented

## Property 1 — x0 Protection

Ensures writes to register x0 never occur.

---

## Property 2 — PC Stability During Stall

Assertion:

```systemverilog
stall |-> $stable(pc)
```

Ensures PC remains frozen during hazards.

---

## Property 3 — IF/ID Stability

Ensures instruction fetch pipeline registers remain stable during stall cycles.

---

## Property 4 — Bubble Insertion Correctness

Verifies EX-stage control signals clear after pipeline stalls.

This property intentionally exposed a hidden pipeline timing bug.

---

# 🧠 Temporal Assertions Used

This project uses sequential temporal reasoning concepts including:

* `$past()`
* cycle-based assertions
* symbolic state exploration
* temporal alignment debugging

Example:

```systemverilog
if ($past(dut.stall))
    assert(dut.id_ex_inst.ex_reg_write == 0);
```

---

# 🐞 Counterexample-Driven Debugging

One of the strongest aspects of this project is the use of formal verification to discover hidden pipeline timing issues.

Formal verification generated counterexample traces exposing:

* incorrect bubble timing
* stale control signal propagation
* incomplete pipeline interlocking

GTKWave was used to inspect:

* stall behavior
* PC stability
* EX-stage control signals
* pipeline register states

This workflow closely resembles real industry formal verification methodology.

---

# 📸 Recommended Screenshots to Add

Add these images inside:

```text
docs/images/
```

Recommended screenshots:

1. GTKWave pipeline waveform
2. Formal FAIL output from SymbiYosys
3. Successful ALU formal PASS
4. CPU simulation output
5. Project directory structure

Then embed them like:

```markdown
![Pipeline Waveform](docs/images/pipeline_waveform.png)
```

---

# 🚀 How to Run

## Simulation

```bash
iverilog -g2012 -o cpu_pipeline_sim \
rtl/*.sv sim/cpu_pipeline_tb.sv

vvp cpu_pipeline_sim
```

---

## Formal Verification

```bash
cd formal
sby -f pipeline.sby
```

---

# 💡 Key Learning Outcomes

## Hardware Design

* RISC-V architecture
* pipeline design
* hazard detection
* control signal management
* interlocking

---

## Formal Verification

* temporal assertions
* symbolic reasoning
* counterexample analysis
* property checking
* sequential correctness debugging

---

# 🎯 Resume Bullet

Developed and formally verified a pipelined RV32I RISC-V processor in SystemVerilog using SymbiYosys and temporal assertions. Implemented hazard detection, stalling, and bubble insertion logic, and used counterexample-driven debugging to identify pipeline timing violations.

---

# 🗣️ Interview Talking Points

This project enables discussion on:

* pipeline architecture
* RAW hazards
* forwarding vs stalling
* temporal assertions
* `$past()` semantics
* formal vs simulation verification
* counterexample debugging
* symbolic state exploration
* pipeline timing bugs

---

# 🌟 Future Improvements

Potential future extensions:

* complete RV32I ISA support
* branch prediction
* forwarding network
* memory stage support
* load/store instructions
* full interlock redesign
* coverage-driven formal verification

---

# 📌 Final Takeaway

This project demonstrates a rare combination of:

* RTL implementation
* processor architecture understanding
* formal verification methodology
* temporal debugging skills

The combination of CPU design + formal verification makes this project highly differentiated for hardware verification and formal verification roles.

---

# 🔗 Repository

GitHub Repository:

[https://github.com/shivanshu-52934/riscv-formal-verification](https://github.com/shivanshu-52934/riscv-formal-verification)

---

# Formally Verified Educational RISC-V Pipeline CPU

## Project Overview

This project implements and formally verifies an educational pipelined RISC-V processor using SystemVerilog and SymbiYosys. The processor includes a multi-stage pipeline, hazard detection logic, pipeline stalls, bubble insertion mechanisms, and temporal assertions for formal verification.

The primary goal of the project is not only to build a functioning processor pipeline but also to demonstrate industry-style formal verification methodologies used in modern hardware verification flows.

---

# Motivation

Modern processors rely heavily on pipeline control logic and hazard management. Simulation alone often fails to expose subtle timing bugs and architectural corner cases. This project explores how formal verification can mathematically prove pipeline correctness properties and automatically discover hidden bugs through counterexample traces.

This project aligns strongly with formal verification engineering workflows used in companies such as NVIDIA, AMD, Intel, Qualcomm, and Apple.

---

# Technologies Used

| Category                | Tools / Technologies |
| ----------------------- | -------------------- |
| HDL                     | SystemVerilog        |
| Formal Verification     | SymbiYosys           |
| Synthesis Engine        | Yosys                |
| SMT Solver              | Yices                |
| Simulation              | Icarus Verilog       |
| Waveform Debugging      | GTKWave              |
| Development Environment | VS Code + WSL Ubuntu |

---

# Processor Architecture

## Pipeline Structure

The processor is implemented as a simplified educational RISC-V pipeline.

### Stages

1. IF — Instruction Fetch
2. ID — Instruction Decode
3. EX — Execute
4. WB — Write Back

---

# Major RTL Components

## 1. Program Counter (pc.sv)

Responsible for:

* tracking instruction address
* stalling during hazards
* sequential instruction flow

### Verified Properties

* PC stability during stall
* Correct PC progression

---

## 2. Instruction Memory (imem.sv)

Stores preloaded RISC-V instructions.

Used for:

* instruction fetch
* pipeline validation
* simulation testing

---

## 3. Decoder (decoder.sv)

Extracts:

* opcode
* funct3
* funct7
* rs1
* rs2
* rd

Demonstrates RTL comprehension and ISA decoding.

---

## 4. Control Unit (control_unit.sv)

Generates control signals for:

* ALU operation selection
* register write enable
* ALU source selection

---

## 5. Register File (regfile.sv)

Implements:

* 32 architectural registers
* dual read ports
* single write port
* x0 protection logic

### Important Architectural Rule

RISC-V register x0 must always remain zero.

Formal verification was used to validate x0 protection.

---

## 6. ALU (alu.sv)

Supports:

* ADD
* SUB
* AND
* OR
* XOR

Initially verified independently using formal assertions.

---

## 7. Pipeline Registers

### IF/ID Register

Stores:

* fetched instruction
* fetched PC

### ID/EX Register

Stores:

* decoded operands
* immediate values
* control signals

### EX/WB Register

Stores:

* ALU result
* destination register
* writeback control signals

---

# Hazard Handling Logic

## RAW Hazard Detection

Implemented hazard detection logic for:

* read-after-write dependencies
* pipeline stalls
* instruction interlocking

---

## Bubble Insertion

Bubble insertion logic was implemented to:

* prevent stale register reads
* freeze instruction fetch
* avoid pipeline corruption

Formal verification later exposed timing limitations in bubble propagation.

---

# Formal Verification Methodology

## Why Formal Verification?

Simulation only checks selected test vectors.

Formal verification mathematically explores:

* all possible legal states
* corner cases
* hidden timing interactions

This makes formal verification extremely powerful for hardware correctness.

---

# Formal Properties Implemented

## Property 1 — x0 Protection

Assertion:

* writes to register x0 must never occur

Purpose:

* preserve RISC-V ISA correctness

---

## Property 2 — PC Stability During Stall

Assertion:

* if stall is asserted, PC must remain stable

Purpose:

* prevent incorrect instruction fetch during hazards

---

## Property 3 — IF/ID Stability During Stall

Assertion:

* IF/ID pipeline registers must remain stable during stall

Purpose:

* preserve instruction ordering correctness

---

## Property 4 — Bubble Insertion Correctness

Assertion:

* EX stage control signals must clear after stall

Purpose:

* ensure safe NOP insertion

This property intentionally exposed a timing-related pipeline bug.

---

# Temporal Assertions Used

The project uses temporal reasoning concepts such as:

* $past()
* cycle-based assertions
* sequential correctness checking
* temporal alignment debugging

Example:

```systemverilog
if ($past(dut.stall))
    assert(dut.id_ex_inst.ex_reg_write == 0);
```

---

# Counterexample-Driven Debugging

One of the strongest outcomes of the project was discovering hidden pipeline timing issues using formal verification.

Formal verification generated counterexample traces showing:

* incorrect bubble timing
* stale control signal propagation
* incomplete pipeline interlocking

These bugs were difficult to isolate using simulation alone.

GTKWave was used to inspect:

* stall behavior
* PC stability
* EX-stage control signals
* pipeline register states

---

# Key Learning Outcomes

## Hardware Design

* SystemVerilog RTL development
* RISC-V instruction decoding
* pipeline architecture
* hazard handling
* control signal management

---

## Formal Verification

* writing temporal assertions
* property checking
* symbolic reasoning
* counterexample analysis
* debugging sequential timing failures

---

## Tools & Workflow

* SymbiYosys proof flow
* Yosys formal elaboration
* GTKWave waveform analysis
* WSL Linux development
* simulation + formal integration

---

# Sample Simulation Output

```text
x1 = 5
x2 = 10
x3 = 15
```

---

# Sample Formal Verification Result

```text
SBY DONE (FAIL)
failed assertion: bubble insertion correctness
counterexample trace generated
```

This demonstrated successful bug discovery through formal methods.

---

# Future Improvements

Possible future extensions include:

* full forwarding network
* branch handling
* memory stage support
* load/store instructions
* multi-cycle hazard tracking
* complete RV32I ISA support
* stronger formal coverage properties

---

# Resume Bullet Points

## Option 1

Developed and formally verified a pipelined RV32I RISC-V processor in SystemVerilog using SymbiYosys and temporal assertions. Implemented hazard detection, stalling, and bubble insertion logic, and used counterexample-driven debugging to identify pipeline timing violations.

---

## Option 2

Built a formally verified educational RISC-V pipeline CPU featuring RAW hazard handling, pipeline interlocks, and temporal property checking using SystemVerilog, Yosys, and SymbiYosys.

---

## Option 3

Implemented formal verification workflows for a pipelined processor, including assertion-based verification, symbolic property checking, GTKWave counterexample analysis, and pipeline invariant validation.

---

# Interview Talking Points

## Topics You Can Confidently Discuss

* pipeline architecture
* RAW hazards
* stalls vs forwarding
* pipeline interlocks
* bubble insertion
* temporal logic assertions
* $past() semantics
* formal vs simulation verification
* counterexample debugging
* symbolic state exploration

---

# Final Project Value

This project demonstrates both:

1. RTL design capability
2. Formal verification methodology

The combination of processor architecture + formal verification makes the project highly relevant for:

* NVIDIA Formal Verification Engineer
* CPU Verification Engineer
* ASIC Verification Engineer
* Design Verification Engineer
* Hardware Verification roles

especially for entry-level and new graduate positions.
