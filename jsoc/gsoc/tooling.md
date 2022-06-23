# Tooling

## Static Analysis with Semgrep

**Difficulty**: Hard

**Duration**: 350 hours

[Semgrep](https://semgrep.dev/) is an open source multi-language static analysis toolkit, based on the [tree-sitter](https://tree-sitter.github.io/tree-sitter/) parser generator. The project would involve adding Julia support to Semgrep, as well as creating a standard ruleset for Julia. It might be necessary to improve the [Julia tree-sitter grammer](https://github.com/tree-sitter/tree-sitter-julia) for this project. 

**Resources**:
@@tight-list
* [Semgrep Website](https://semgrep.dev/) 
* Documentation on [adding a new language](https://semgrep.dev/docs/contributing/adding-a-language/) to Semgrep
@@

**Recommended Skills**: A deep knowledge of parsing techniques is required for this project. A familiarity with OCaml might be useful. 

**Expected Output**: A library and ruleset that can be used for practical static analysis of real world Julia code. 

**Mentors**: [Avik Sengupta](https://github.com/aviks/), [Joris Kraak](https://github.com/bauglir)
