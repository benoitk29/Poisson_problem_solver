# P1 Finite Element Solver for Poisson's Problem

A complete P1 Finite Element Method (FEM) solver developed from scratch in MATLAB to solve the Poisson equation (`u - Δu = f`) subject to both Neumann and Dirichlet boundary conditions. This repository showcases the fundamental transition from a continuous physical problem to its discrete numerical resolution.

## 📄 Project Documentation
* **[Read the Full Scientific Report (PDF)](TP1_Poisson.pdf)** *(Note: The report and code comments are written in French, but the variable naming and matrix structures follow standard FEM mathematical conventions).*

## Mathematical & Technical Framework
* **Variational Modeling:** Full derivation of the weak formulation, with theoretical proof of existence and uniqueness of the solution using the Lax-Milgram theorem (demonstrating coercivity and continuity of the bilinear form in the H¹(Ω) Hilbert space).
* **Discretization:** Linear (P1) triangular finite elements utilizing barycentric coordinates for the local basis functions.
* **Matrix Assembly:** Efficient local-to-global assembly of the sparse Mass (M) and Stiffness (K) matrices, resulting in the linear system `(M + K)U = L`.
* **Mesh Generation:** Automatic unstructured mesh generation and geometry definition utilizing `gmsh` (`.geo` to `.msh` conversion).

## Validation & Error Analysis
* **Convergence Study:** Rigorous numerical validation against exact analytical solutions. 
* **Error Metrics:** Implementation of custom functions to compute the approximation error in both the L² norm (global error) and H¹ semi-norm (gradient error).
* **Log-Log Analysis:** Empirical verification of the FEM theoretical convergence rates through log-log regression plotting of the normalized errors against the mesh characteristic size (h).

## Requirements
* MATLAB
* GMSH
