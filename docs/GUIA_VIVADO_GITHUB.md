# Setup guide: VS Code + Vivado 2018.1 + GitHub

## Keep the original work

Do not start a new GitHub repository and do not delete `circuito/`, `analisis/` or the existing `evidencias/logica_moore.png` and `evidencias/registros_moore.png` images. This package is an **overlay for the existing repository**. Only `README.md`, `hdl/src/*.sv`, `hdl/sim/*.sv`, `hdl/README.md` and the new documentation need updating/adding.

## 1. Open the repository in VS Code

From Windows PowerShell (Git and VS Code installed):

```powershell
cd $HOME\Documents
git clone https://github.com/Josemedinan/FSM-Parking-Verylog.git
cd FSM-Parking-Verylog
code .
```

If it is already cloned, open the existing folder instead and run `git pull` before merging this package. Do **not** extract the ZIP into another folder and accidentally upload a nested second repository; copy the *contents* of this overlay into the cloned repository root.

## 2. Merge this package

Copy the package's `README.md`, `.gitignore`, `.vscode`, `.code-workspace`, `docs`, `hdl`, and `evidencias/fpga` into the same relative paths of the existing repository. Confirm whether your Windows file manager asks to merge folders / replace modified HDL files. Preserve existing `circuito`, `analisis`, and historical `evidencias`.

For existing `hdl/README.md`, the update includes an explanation of both the original core and the new board top.

## 3. Vivado project

- Product: Vivado HL WebPACK 2018.1.
- FPGA part: `xc7a35tcpg236-1`.
- Design Sources: all `hdl/src/*.sv`.
- Synthesis top: `top_basys3`.
- Simulation Sources: `hdl/sim/testbench_basys3.sv` (plus optional `testbench.sv`).
- Simulation top: `testbench_basys3`.
- Constraints: **one** active copy of `hdl/constraints/basys3.xdc` (do not duplicate its pin assignments).
- Run Behavioral Simulation, then type `run all` in Tcl Console. Verify a PASS message. If the simulator stops earlier with a `$fatal`, capture the error; a screenshot of 600 ns is not a complete pass.
- Run Synthesis > Implementation > Report Timing Summary > Generate Bitstream.
- Program `top_basys3.bit` via Digilent FPGA Utility; it detects the Basys 3 and XC7A35T, even when Vivado Hardware Manager fails to enumerate JTAG on the tested Windows setup.

**Important:** VS Code is the code editor. It does not replace XSim, Vivado synthesis, implementation, or programming tools.

## 4. Files not to upload

Do not commit `*.xpr`, `.Xil/`, `*.runs/`, `*.sim/`, `*.cache/`, `*.hw/`, `*.ip_user_files/` or large simulator wave databases. The portable repo holds only HDL, XDC, tests, explanations and screenshots.

If your course requires the exact generated `.bit`, put it in a tagged GitHub Release or an explicitly documented artifact location and state the target FPGA. The ZIP does **not** contain the user's `.bit` because that local Vivado-generated binary was not attached to this conversation.

## 5. Commit and upload from VS Code

In VS Code open Terminal > New Terminal (PowerShell):

```powershell
git status
git add README.md .gitignore .vscode FSM-Parking-Verylog.code-workspace docs hdl evidencias/fpga
git commit -m "Document Basys 3 Mealy-Moore implementation and evidence"
git push origin main
```

If `git push` is rejected because someone else modified the remote, run `git pull --rebase` and resolve any conflicts before pushing; do not force-push.

## 6. Verify GitHub Markdown

Visit `https://github.com/Josemedinan/FSM-Parking-Verylog` and inspect the README images. Image links are relative to the repository root: `evidencias/fpga/*.png` and `.jpg`. If images are blank, check their names and capitalization in the GitHub file browser.

To preview locally in VS Code: open `README.md`, press `Ctrl+Shift+V`, and select `Open Preview to the Side` if useful.
