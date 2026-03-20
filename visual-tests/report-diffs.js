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
  // e.g. "pages-homepage-visual-snapshot-desktop" → "homepage (desktop)"
  const m = name.match(/^pages-(.+)-visual-snapshot-(.+)$/);
  if (!m) return name;
  const page = m[1].replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
  return `${page} (${m[2]})`;
}

function generateComment(diffs) {
  if (diffs.length === 0) return "";

  const pages = [...new Set(diffs.map(({ name }) => {
    const m = name.match(/^pages-(.+)-visual-snapshot/);
    return m ? m[1].replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase()) : name;
  }))];

  const repo = process.env.GITHUB_REPOSITORY || "";
  const runId = process.env.GITHUB_RUN_ID || "";
  const prNumber = process.env.PR_NUMBER || "";
  const artifactUrl = repo && runId
    ? `https://github.com/${repo}/actions/runs/${runId}#artifacts`
    : "";
  const previewUrl = prNumber
    ? `https://julialang.netlify.app/previews/PR${prNumber}`
    : "";

  const lines = [
    "## Visual Regression Check",
    `Visual changes have been detected on the following pages: **${pages.join("**, **")}**.
    These changes may or may not be expected. Please review. Note that only [main pages](https://github.com/${repo}/blob/main/visual-tests/pages.spec.ts) are checked.`,
    artifactUrl
      ? `- Download the [visual-test-results](${artifactUrl}) artifact for before/after/diff images.`
      : "- Download the **visual-test-results** artifact for before/after/diff images.",
    previewUrl ? `- Preview the full site at ${previewUrl}.` : "",
  ].filter(Boolean);

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
