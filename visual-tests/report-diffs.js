// Generates a PR comment body from Playwright visual test results.
// Compares screenshots rendered from main (baseline) against the PR branch.
// Reads test-results/ directory for diff/actual/expected images.

const fs = require("fs");
const path = require("path");

const resultsDir = path.join(__dirname, "test-results");

function findDiffs() {
  if (!fs.existsSync(resultsDir)) return [];

  const diffs = [];
  for (const entry of fs.readdirSync(resultsDir)) {
    const dir = path.join(resultsDir, entry);
    if (!fs.statSync(dir).isDirectory()) continue;

    const files = fs.readdirSync(dir);
    const hasActual = files.some((f) => f.endsWith("-actual.png"));
    const hasExpected = files.some((f) => f.endsWith("-expected.png"));
    const hasDiff = files.some((f) => f.endsWith("-diff.png"));

    if (hasActual) {
      diffs.push({ name: entry, hasExpected, hasDiff });
    }
  }
  return diffs;
}

function displayName(name) {
  return name
    .replace(/-pages-spec-ts-/g, " / ")
    .replace(/-visual-snapshot.*$/, "")
    .replace(/-/g, " ");
}

function generateComment(diffs) {
  if (diffs.length === 0) return "";

  const lines = [
    "## Visual Regression Tests",
    "",
    `This PR changes the appearance of **${diffs.length}** page(s) compared to \`main\`.`,
    "These may be intentional. Download the **visual-test-results** artifact from this workflow run for full-resolution before/after/diff images.",
    "",
    "<details>",
    "<summary>Changed pages</summary>",
    "",
    "| Page | Status |",
    "|------|--------|",
  ];

  for (const { name, hasExpected, hasDiff } of diffs) {
    const page = displayName(name);
    const status = hasExpected && hasDiff ? "changed" : "new (no baseline)";
    lines.push(`| ${page} | ${status} |`);
  }

  lines.push("");
  lines.push("</details>");

  return lines.join("\n");
}

const diffs = findDiffs();
const comment = generateComment(diffs);
const outputFile = process.env.GITHUB_OUTPUT;
if (outputFile) {
  const delimiter = "EOF_" + Date.now();
  fs.appendFileSync(
    outputFile,
    `comment_body<<${delimiter}\n${comment}\n${delimiter}\n`
  );
  fs.appendFileSync(outputFile, `has_diffs=${diffs.length > 0}\n`);
} else {
  console.log(comment);
}
